# Resolvendo Problemas do Token SafeSign no Firefox no Ubuntu 22.04 e 24.04

## Introdução

Este guia aborda a solução para o problema de reconhecimento do token SafeSign no navegador Firefox no Ubuntu 22.04. Partimos do pressuposto de que o token já está instalado no Ubuntu 22.04 e 24.04

## Problema

O problema ocorre porque o token não é reconhecido no navegador Firefox. Para resolver isso, é necessário adicionar o pacote `/usr/lib/libaetpkss.so` no Firefox. No entanto, no Ubuntu 22.04, o Firefox é instalado por padrão via Snap, o que impede a configuração correta do token.

## Solução
### Método 1: Fazer os comandos manualmente 

> Caso esteja usando uma rede interna, atente-se ao proxy. Configure as variáveis de ambiente do proxy antes de adicionar o repositório e instalar o Firefox. No terminal, execute os seguintes comandos, substituindo `proxy.example.com:8080` pelo endereço do seu proxy:

```bash
export http_proxy="http://usuario:senha@endereço:porta"
export https_proxy="http://admin:admin@proxy.example.com:8080"
```

Para resolver o problema, é preciso desinstalar o Firefox do Snap e instalá-lo a partir do repositório oficial do Firefox. Siga os passos abaixo:


```bash
#Remove a instalacao anterior do Firefox via snap
sudo snap remove --purge firefox

#Remove o pacote fake que redireciona para o snap
sudo apt remove firefox -y

#Adiciona o repositorio PPA do Mozilla Team
sudo add-apt-repository ppa:mozillateam/ppa -y

#Adiciona configuracoes para priorizar a instalacao via PPA
sudo nano /etc/apt/preferences.d/mozillateamppa


#Definindo Prioridade Alta
Package: firefox* 
Pin: release o=LP-PPA-mozillateam 
Pin-Priority: 501
#Bloqueando firefox snap no repositorio do Ubuntu
Package: firefox* 
Pin: release o=Ubuntu
Pin-Priority: -1

Configura atualizacoes automaticas
echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox

Atualiza repositorios e instala o Firefox
sudo apt update && sudo apt install firefox -y
```
### Método 2: Utilizar Script Automatizado

Para facilitar o processo, você pode utilizar o script `firefoxppa-install.sh`, que automatiza todos os passos necessários. Siga os passos abaixo para usar o script:

1. Baixe o script `firefoxppa-install.sh` para o seu diretório de preferência.
2. Torne o script executável:
    ```bash
    chmod +x firefoxppa-install.sh
    ```
3. Execute o script:
    ```bash
    sudo bash firefoxppa-install.sh
    ```

### Passo 3: Configurar o Token no Firefox

1. Abra o Firefox.
2. Vá para `Preferências` > `Privacidade e Segurança` > `Dispositivos de Segurança`.
3. Adicione o módulo de segurança apontando para o arquivo `/usr/lib/libaetpkss.so`.

Após seguir esses passos, o token SafeSign deverá ser reconhecido corretamente no Firefox no Ubuntu 22.04.

## Conclusão

Com a desinstalação do Firefox via Snap e a instalação pelo repositório oficial, o Firefox poderá reconhecer e utilizar o token SafeSign corretamente, resolvendo o problema de incompatibilidade.
