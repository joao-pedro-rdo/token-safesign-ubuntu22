#!/bin/bash

# Função para exibir mensagens de erro e sair
erro() {
    echo "Erro: $1" >&2
    exit 1
}

# Remove a instalação anterior do Firefox via snap
echo "Removendo o Firefox instalado via snap..."
sudo snap remove --purge firefox || erro "Falha ao remover o Firefox via snap"

# Remove o pacote fake que redireciona para o snap
echo "Removendo o pacote fake do Firefox..."
sudo apt remove firefox -y || erro "Falha ao remover o pacote fake do Firefox"

# Adiciona o repositório PPA do Mozilla Team
echo "Adicionando o repositório PPA do Mozilla Team..."
sudo add-apt-repository ppa:mozillateam/ppa -y || erro "Falha ao adicionar o repositório PPA do Mozilla Team"

# Cria o arquivo de preferências para priorizar a instalação via PPA
echo "Configurando prioridades para o repositório PPA..."
sudo tee /etc/apt/preferences.d/mozillateamppa > /dev/null <<EOL
Package: firefox*
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 501

Package: firefox*
Pin: release o=Ubuntu
Pin-Priority: -1
EOL

# Configura atualizações automáticas
echo "Configurando atualizações automáticas para o Firefox..."
echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox || erro "Falha ao configurar atualizações automáticas"

# Atualiza repositórios e instala o Firefox
echo "Atualizando repositórios e instalando o Firefox..."
sudo apt update && sudo apt install firefox -y || erro "Falha ao atualizar repositórios ou instalar o Firefox"

echo "Instalação do Firefox via PPA concluída com sucesso!"