#!/bin/bash

# Verifica se está sendo executado como root
if [ "$EUID" -ne 0 ]; then
    echo "Execute com sudo."
    exit 1
fi

# Solicita o usuário
read -p "Digite o nome do usuário que deseja remover: " usuario

# Valida o nome
if [[ ! "$usuario" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
    echo "Nome de usuário inválido."
    exit 1
fi

# Protege contas importantes
if [[ "$usuario" == "root" || "$usuario" == "ubuntu" ]]; then
    echo "Operação bloqueada: usuário protegido!"
    exit 1
fi

# Verifica se o usuário existe
if ! id "$usuario" &>/dev/null; then
    echo "Usuário não encontrado."
    exit 1
fi

# Verifica se o disco está montado
if ! mountpoint -q /mnt/disco2; then
    echo "ERRO: /mnt/disco2 não está montado!"
    exit 1
fi

base="/mnt/disco2/publica"
diretorio="$base/$usuario"

# Verifica a existência da pasta principal
if [[ ! -d "$base" ]]; then
    echo "Diretório publica não encontrado."
    exit 1
fi

# Evita remover um link simbólico
if [[ -L "$diretorio" ]]; then
    echo "ERRO: o diretório do usuário é um link simbólico."
    exit 1
fi

# Verifica se o usuário está executando processos
if pgrep -u "$usuario" >/dev/null; then
    echo "O usuário possui processos ativos."
    echo "Encerre as sessões antes de removê-lo."
    exit 1
fi

echo ""
echo "ATENÇÃO: você está prestes a remover:"
echo "Usuário: $usuario"
echo "Diretório pessoal: /home/$usuario"
echo "Pasta compartilhada: $diretorio"
echo ""

read -p "Digite REMOVER para confirmar: " confirmacao

if [[ "$confirmacao" != "REMOVER" ]]; then
    echo "Operação cancelada."
    exit 0
fi

echo ""
echo "Removendo conta Samba..."

smbpasswd -x "$usuario" 2>/dev/null

echo "Removendo usuário Linux..."

if ! userdel -r "$usuario"; then
    echo "Erro ao remover usuário Linux."
    exit 1
fi

echo "Removendo diretório compartilhado..."

if [[ -d "$diretorio" ]]; then
    rm -rf -- "$diretorio" || exit 1
fi

# Remove grupo privado vazio, se existir e não for usado
grupo=$(getent group "$usuario")

if [[ -n "$grupo" ]]; then
    gid=$(echo "$grupo" | cut -d: -f3)
    membros=$(echo "$grupo" | cut -d: -f4)

    if ! getent passwd | awk -F: -v gid="$gid" \
        '$4 == gid {found=1} END {exit !found}' \
        && [[ -z "$membros" ]]; then
        groupdel "$usuario"
    fi
fi

echo ""
echo "================================"
echo "USUÁRIO REMOVIDO COM SUCESSO!"
echo "================================"
