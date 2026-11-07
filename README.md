# Samba User Manager

Scripts desenvolvidos em Bash para automatizar o gerenciamento de usuários, diretórios e permissões em um servidor Linux com Samba.

## Sobre o projeto

Este projeto surgiu de uma necessidade prática: facilitar a transferência de arquivos grandes entre amigos.

Anteriormente, utilizávamos o Google Drive como meio de armazenamento e compartilhamento, criando pastas e organizando os arquivos manualmente. Para buscar uma alternativa mais centralizada, configurei um servidor Ubuntu Server com Samba, permitindo o compartilhamento de arquivos por meio de uma rede.

Com a implementação do servidor, surgiu outro desafio: gerenciar individualmente os usuários e suas permissões de acesso. Realizar esse processo manualmente sempre que alguém precisava entrar ou sair do compartilhamento tornava a administração repetitiva.

Para solucionar esse problema, desenvolvi dois scripts em Shell Script (`.sh`) que automatizam a criação e a remoção de usuários, incluindo o gerenciamento das contas Samba, dos diretórios individuais e de suas permissões.

Assim, o projeto combina administração de servidores Linux, compartilhamento de arquivos e automação de tarefas com Bash.

## Funcionalidades

### Criação de usuários
- Criação de usuários no Linux.
- Cadastro e habilitação de contas no Samba.
- Criação automática de diretórios individuais.
- Configuração de proprietário e permissões dos diretórios.

### Remoção de usuários
- Remoção da conta do Samba.
- Exclusão do usuário Linux.
- Remoção do diretório individual do usuário.
- Verificações e confirmação antes da execução da remoção.

## Estrutura do projeto

```text
samba-user-manager/
├── criar_usuario_samba.sh
├── remover_usuario_samba.sh
└── README.md
```

## Requisitos

- Ubuntu Server ou outra distribuição Linux compatível.
- Bash.
- Samba instalado e configurado.
- Permissões administrativas (`sudo`).
- Diretório de armazenamento montado em `/mnt/disco2`.
- Grupo `samba_publica` previamente configurado.

## Como utilizar

Primeiro, clone o repositório:

```bash
git clone https://github.com/SEU_USUARIO/samba-user-manager.git
cd samba-user-manager
```

Dê permissão de execução aos scripts:

```bash
chmod +x criar_usuario_samba.sh
chmod +x remover_usuario_samba.sh
```

### Criar um usuário

Execute:

```bash
sudo bash criar_usuario_samba.sh
```

O script solicitará o nome do usuário e realizará o processo de criação e configuração da conta Linux e Samba, além de preparar seu diretório individual.

### Remover um usuário

Execute:

```bash
sudo bash remover_usuario_samba.sh
```

O script solicitará o nome do usuário e uma confirmação antes de realizar a remoção.

## Organização das permissões

Os diretórios individuais seguem uma estrutura semelhante a esta:

```text
/mnt/disco2/publica/
├── kenzo/
├── lucas/
└── ubuntu/
```

Cada usuário possui controle total sobre seu próprio diretório, enquanto os demais usuários possuem permissão de leitura e acesso aos diretórios dos outros participantes, sem permissão de escrita.

## Tecnologias utilizadas

- Ubuntu Server
- Linux
- Bash Shell Script
- Samba
- Git e GitHub

## Objetivo

Praticar e aplicar conhecimentos de administração de sistemas Linux, gerenciamento de usuários e permissões, compartilhamento de arquivos em rede e automação de tarefas utilizando Shell Script.

## Aviso

O script de remoção executa operações destrutivas, podendo excluir contas Linux, cadastros Samba e arquivos dos diretórios individuais.

Utilize com cuidado e mantenha backups dos dados importantes. Antes de utilizar em um ambiente real, revise os scripts e adapte as configurações à sua infraestrutura.
