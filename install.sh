#!/bin/bash
echo -e "\nChecking that minimal requirements are ok"

# Detecta o Sistema Operacional
if [ -f /etc/centos-release ]; then
    inst() {
       rpm -q "$1"
    } 
    if (inst "centos-stream-repos"); then
    OS="CentOS-Stream"
    else
    OS="CentOs"
    fi    
    VERFULL="$(sed 's/^.*release //;s/ (Fin.*$//' /etc/centos-release)"
    VER="${VERFULL:0:1}"
elif [ -f /etc/fedora-release ]; then
    inst() {
       rpm -q "$1"
    } 
    OS="Fedora"
    VERFULL="$(sed 's/^.*release //;s/ (Fin.*$//' /etc/fedora-release)"
    VER="${VERFULL:0:2}"
elif [ -f /etc/lsb-release ]; then
    OS="$(grep DISTRIB_ID /etc/lsb-release | sed 's/^.*=//')"
    VER="$(grep DISTRIB_RELEASE /etc/lsb-release | sed 's/^.*=//')"
elif [ -f /etc/os-release ]; then
    OS="$(grep -w ID /etc/os-release | sed 's/^.*=//' | tr -d '"')"
    VER="$(grep -w VERSION_ID /etc/os-release | sed 's/^.*=//' | tr -d '"')"
else
    OS="$(uname -s)"
    VER="$(uname -r)"
fi

ARCH=$(uname -m)
echo "Detected : $OS $VER $ARCH"

# Validação de versão (Ubuntu 20.04, 22.04 ou 24.04)
if [[ "$OS" == "ubuntu" || "$OS" == "Ubuntu" ]] && [[ "$VER" == "20.04" || "$VER" == "22.04" || "$VER" == "24.04" ]] && [[ "$ARCH" == "x86_64" ]] ; then
    echo "OS Check: Ok."
else
    echo "Sorry, this OS is not supported by Xtream UI."
    echo "Use actual Ubuntu LTS Version 20.04, 22.04 or 24.04."
    exit 1
fi

# Início da instalação com saída visível
echo -e "\n>>> Updating system repositories..."
sudo apt-get update

echo -e "\n>>> Installing Python and dependencies..."
# Nota: Python 2 pode falhar em versões muito novas do Ubuntu (24.04), mas o script tentará instalar o que estiver disponível
sudo apt-get -y install python3 python3-dev unzip wget curl

echo -e "\n>>> Downloading XUI Package..."
cd /root
wget https://github.com/brunodesouza2007/Repo/releases/download/arquivo2/XUI_1.5.12.zip -O XUI_1.5.12.zip

echo -e "\n>>> Unzipping XUI Package..."
unzip -o XUI_1.5.12.zip

# Se você já tem o seu script install.py (o que fizemos no passo anterior) no servidor, 
# ele será chamado agora. Se você baixar o arquivo externo, ele usará a versão da internet.
# Vou assumir que você vai usar o script Python automático que criamos.

echo -e "\n>>> Starting Python Installer (install.python3)..."
# Se você salvou o script anterior como install.py, mude o nome abaixo:
python3 /root/install.python3
