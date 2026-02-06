#!/bin/bash

echo -e "\n🔍 Checking that minimal requirements are ok"

# Detect OS
if [ -f /etc/centos-release ]; then
    inst() {
       rpm -q "$1" &> /dev/null
    }
    if (inst "centos-stream-repos"); then
        OS="CentOS-Stream"
    else
        OS="CentOS"
    fi
    VERFULL="$(sed 's/^.*release //;s/ (Fin.*$//' /etc/centos-release)"
    VER="${VERFULL:0:1}"

elif [ -f /etc/fedora-release ]; then
    OS="Fedora"
    VERFULL="$(sed 's/^.*release //;s/ (Fin.*$//' /etc/fedora-release)"
    VER="${VERFULL:0:2}"

elif [ -f /etc/lsb-release ]; then
    OS="$(grep DISTRIB_ID /etc/lsb-release | sed 's/^.*=//')"
    VER="$(grep DISTRIB_RELEASE /etc/lsb-release | sed 's/^.*=//')"

elif [ -f /etc/os-release ]; then
    OS="$(grep -w ID /etc/os-release | sed 's/^.*=//')"
    VER="$(grep -w VERSION_ID /etc/os-release | sed 's/^.*=//')"

else
    OS="$(uname -s)"
    VER="$(uname -r)"
fi

ARCH=$(uname -m)
echo "🖥 Detected : $OS  $VER  $ARCH"

if [[ "$OS" = "Ubuntu" && ( "$VER" = "20.04" || "$VER" = "22.04" || "$VER" = "24.04" ) && "$ARCH" == "x86_64" ]]; then
    echo "✅ OS supported."
else
    echo "❌ Sorry, this OS is not supported by Xtream UI."
    echo "👉 Use Ubuntu LTS 20.04, 22.04 or 24.04."
    exit 1
fi

echo -e "\n📦 Updating system..."
sudo DEBIAN_FRONTEND=noninteractive apt-get update

echo -e "\n🐍 Installing Python packages..."
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install python python-dev unzip
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install python2 python2-dev unzip
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install python2.7 python2.7-dev unzip
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install python2.8 python2.8-dev unzip
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install python3 python3-dev unzip

echo -e "\n📂 Moving to /root..."
cd /root || exit 1

echo -e "\n⬇ Downloading XUI 1.5.12..."
wget https://github.com/amidevous/xui.one/releases/download/test/XUI_1.5.12.zip -O XUI_1.5.12.zip

echo -e "\n📦 Extracting XUI..."
unzip XUI_1.5.12.zip

echo -e "\n⬇ Downloading installer..."
wget https://raw.githubusercontent.com/amidevous/xui.one/master/install.python3 -O /root/install.python3

echo -e "\n🚀 Running installer..."
python3 /root/install.python3

echo -e "\n✅ Installation finished."
