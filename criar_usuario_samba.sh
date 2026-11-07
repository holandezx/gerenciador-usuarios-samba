#!/bin/bash

# Verifica se está sendo executado como root
if [ "$EUID" -ne 0 ]; then
    echo "Execute este script como root ou com sudo."
    exit 1
fi

# Confere se o disco está montado
if ! mountpoint -q /mnt/disco2; then
    echo "ERRO: /mnt/disco2 não está montado!"
    exit 1
fi

# Solicita o nome do usuário
read -p "Digite o nome do novo usuário: " usuario

# Valida o nome
if [[ ! "$usuario" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
    echo "Nome de usuário inválido."
    exit 1
fi

# Verifica se o usuário já existe
if id "$usuario" &>/dev/null; then
    echo "O usuário $usuario já existe!"
    exit 1
fi

echo "Criando usuário..."

useradd -m -U -s /bin/bash -G samba_publica "$usuario"

# Define senha do Linux
echo "Defina a senha do Linux:"
passwd "$usuario" || exit 1

# Cadastra senha no Samba
echo "Defina a senha do Samba:"
smbpasswd -a "$usuario" || exit 1

# Habilita o usuário no Samba
smbpasswd -e "$usuario"

# Cria diretório individual
mkdir -p "/mnt/disco2/publica/$usuario"

# Define proprietário
chown "$usuario:$usuario" "/mnt/disco2/publica/$usuario"

# Define permissões
chmod 755 "/mnt/disco2/publica/$usuario"

echo "--------------------------------"
echo "Usuário criado com sucesso!"
echo "Usuário: $usuario"
echo "Diretório: /mnt/disco2/publica/$usuario"
echo "Permissões: 755"
echo "Grupo Samba: samba_publica"
echo "--------------------------------"
