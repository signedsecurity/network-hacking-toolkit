#!/usr/bin/env bash

NHT_CONFIGURATIONS="${NHT}/configurations"

export DEBIAN_FRONTEND=noninteractive

# CONFIGURATIONS="/tmp/configurations"

# export DEBIAN_FRONTEND=noninteractive

echo -e " + up(date|grade)"

apt-get update && \
apt-get upgrade -qq -y

echo -e " + install essentials"

apt-get install -y -qq --no-install-recommends \
	tar \
	git \
	curl \
	wget \
	tree \
	unzip \
	xauth \
	libxss1 \
	apt-utils \
	p7zip-full \
	ca-certificates \
	build-essential

echo -e " + install/generate locales"

apt-get install -y -qq --no-install-recommends locales
localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

echo -e " + extract configuration"

7z x ${NHT_CONFIGURATIONS}.7z -o${NHT}

echo -e " + System Setup"

echo -e " +++++ Terminal"

echo -e " +++++++++ Shell (zsh)"

if [ ! -x "$(command -v zsh)" ]
then
	apt-get install -y -qq zsh
fi

if [ "${SHELL}" != "$(which zsh)" ]
then
	chsh -s $(which zsh) ${USER}
fi

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended 

git clone https://github.com/zsh-users/zsh-autosuggestions.git ${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

mv ${NHT_CONFIGURATIONS}/.zshrc ${HOME}/.zshrc
mv ${NHT_CONFIGURATIONS}/.zprofile ${HOME}/.zprofile
mv ${NHT_CONFIGURATIONS}/.hushlogin ${HOME}/.hushlogin

(grep -q "export PATH=\$PATH:${LOCAL_BIN}" ${HOME}/.profile) || {
	echo "export PATH=\$PATH:${LOCAL_BIN}" >> ${HOME}/.profile
}

source ${HOME}/.profile

echo -e " +++++++++ Session Manager (tmux)"

if [ ! -x "$(command -v tmux)" ]
then
	apt-get install -y -qq tmux
fi

mv ${NHT_CONFIGURATIONS}/.tmux.conf ${HOME}/.tmux.conf

TMUX_PLUGINS="${HOME}/.tmux/plugins"

if [ ! -d ${TMUX_PLUGINS} ]
then
	mkdir -p ${TMUX_PLUGINS}
fi

git clone https://github.com/tmux-plugins/tpm.git ${TMUX_PLUGINS}/tpm

if [ -f ${TMUX_PLUGINS}/tpm/bin/install_plugins ]
then
	chmod +x ${TMUX_PLUGINS}/tpm/bin/install_plugins
	${TMUX_PLUGINS}/tpm/bin/install_plugins
fi

echo -e " +++++ Browser"

echo -e " +++++++++ firefox"

if [ ! -x "$(command -v firefox)" ]
then
	apt-get install -y -qq firefox-esr ca-certificates libcanberra-gtk3-module
fi

mv -f ${NHT_CONFIGURATIONS}/.mozilla ${HOME}/.mozilla

echo -e " +++++ Remote Connection"

echo -e " +++++++++ ssh"

if [ ! -x "$(command -v ssh)" ]
then
	apt-get install -y -qq openssh-server
fi

sed -i 's/#X11UseLocalhost yes/X11UseLocalhost no/' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

echo -e " + Development"

echo -e " +++++ Text Editor"

echo -e " +++++++++ vim"

if [ ! -x "$(command -v vim)" ]
then
	apt-get install -y -qq vim
fi

VIM_DIR="${HOME}/.vim"
VIM_COLORS="${VIM_DIR}/colors"; mkdir -p ${VIM_COLORS}
VIM_BUNDLE="${VIM_DIR}/bundle"; mkdir -p ${VIM_BUNDLE}
VIM_AUTOLOAD="${VIM_DIR}/autoload"; mkdir -p ${VIM_AUTOLOAD}

curl -sL https://tpo.pe/pathogen.vim -o ${VIM_AUTOLOAD}/pathogen.vim
curl -sL https://raw.githubusercontent.com/joshdick/onedark.vim/master/autoload/onedark.vim -o ${VIM_AUTOLOAD}/onedark.vim
curl -sL https://raw.githubusercontent.com/joshdick/onedark.vim/master/colors/onedark.vim -o ${VIM_COLORS}/onedark.vim
mkdir -p ${VIM_AUTOLOAD}/airline/themes
curl -sL https://raw.githubusercontent.com/joshdick/onedark.vim/master/autoload/airline/themes/onedark.vim -o ${VIM_AUTOLOAD}/airline/themes/onedark.vim
git clone https://github.com/preservim/nerdtree.git ${VIM_BUNDLE}/nerdtree
git clone https://github.com/ryanoasis/vim-devicons.git ${VIM_BUNDLE}/vim-devicons
git clone https://github.com/vim-airline/vim-airline.git ${VIM_BUNDLE}/vim-airline
git clone https://github.com/airblade/vim-gitgutter.git ${VIM_BUNDLE}/vim-gitgutter
git clone https://github.com/Xuyuanp/nerdtree-git-plugin.git ${VIM_BUNDLE}/nerdtree-git-plugin
git clone https://github.com/tpope/vim-fugitive.git ${VIM_BUNDLE}/vim-fugitive

mv ${NHT_CONFIGURATIONS}/.vimrc ${HOME}/.vim/vimrc

echo -e " + language|frameworks|runtime"

echo -e " +++++ go"

if [ ! -x "$(command -v go)" ]
then
	if [ ! -f /tmp/go1.18.linux-amd64.tar.gz ]
	then
		curl -sL https://golang.org/dl/go1.18.linux-amd64.tar.gz -o /tmp/go1.18.linux-amd64.tar.gz
	fi
	if [ -f /tmp/go1.18.linux-amd64.tar.gz ]
	then
		tar -xzf /tmp/go1.18.linux-amd64.tar.gz -C /usr/local
		rm -rf /tmp/go1.18.linux-amd64.tar.gz
	fi
fi

(grep -q "export PATH=\$PATH:/usr/local/go/bin" ~/.profile) || {
	echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.profile
}
(grep -q "export PATH=\$PATH:\${HOME}/go/bin" ~/.profile) || {
	echo "export PATH=\$PATH:\${HOME}/go/bin" >> ~/.profile
}

source ${HOME}/.profile

echo -e " +++++ python3"

if [ ! -x "$(command -v python3)" ] || [ ! -x "$(command -v pip3)" ]
then
	apt-get install -y -qq python3 python3-dev python3-pip python3-venv
fi

echo -e " +++++ node, npm & yarn"

if [ ! -x "$(command -v node)" ] || [ ! -x "$(command -v pip3)" ]
then
	curl -fsSL https://deb.nodesource.com/setup_17.x | bash -
	apt-get install -y -qq  nodejs
fi
if [ -x "$(command -v npm)" ]
then
	npm install -g npm@latest

	if [ ! -x "$(command -v yarn)" ]
	then
		npm install -g yarn
	fi
fi

echo -e " + Tools"

# tools="${HOME}/tools"

# if [ ! -d ${tools} ]
# then
# 	mkdir -p ${tools}
# fi

echo -e "\n + bloodhound\n"

if [ ! -x "$(command -v bloodhound)" ]
then
	apt-get install -y -qq bloodhound
fi

if [ ! -x "$(command -v bloodhound-python)" ]
then
	pip3 install bloodhound
fi

echo -e "\n + certi.py\n"

git clone https://github.com/zer1t0/certi.git /tmp/certi
cd /tmp/certi
python3 setup.py install
cd -

echo -e "\n + certipy\n"

git clone https://github.com/ly4k/Certipy.git /tmp/Certipy
cd /tmp/Certipy
python3 setup.py install
cd -

echo -e "\n + crackmapexec\n"

# cme
curl -sL https://github.com/byt3bl33d3r/CrackMapExec/releases/download/v5.2.2/cme-ubuntu-latest.zip -o /tmp/cme-ubuntu-latest.zip
unzip /tmp/cme-ubuntu-latest.zip -d /usr/bin
# crackmapexec
ln -s /usr/bin/cme /usr/bin/crackmapexec
# cmedb
curl -sL https://github.com/byt3bl33d3r/CrackMapExec/releases/download/v5.2.2/cmedb-ubuntu-latest.zip -o /tmp/cmedb-ubuntu-latest.zip
unzip /tmp/cmedb-ubuntu-latest.zip -d /usr/bin

chmod +x /usr/bin/cme /usr/bin/cmedb

echo -e "\n + dnsutils\n"

apt-get install -y -qq dnsutils

echo -e "\n + enum4linux\n"

if [ ! -x "$(command -v enum4linux)" ]
then
	apt-get install -y -qq enum4linux
fi

echo -e "\n + evil-winrm\n"

if [ ! -x "$(command -v evil-winrm)" ]
then
	apt-get install -y -qq evil-winrm
fi

echo -e "\n + fping\n"

if [ ! -x "$(command -v fping)" ]
then
	apt-get install -y -qq fping
fi

echo -e "\n + grep\n"

if [ ! -x "$(command -v grep)" ]
then
	apt-get install -y -qq grep
fi

echo -e "\n + impacket\n"

git clone https://github.com/SecureAuthCorp/impacket.git /opt/impacket
pip3 install -r /opt/impacket/requirements.txt
cd /opt/impacket
python3 ./setup.py install
cd -

echo -e "\n + ldap-utils\n"

apt-get install -y -qq ldap-utils

# echo -e "\n + masscan\n"

# apt-get install -y -qq masscan

echo -e "\n + metasploit\n"

if [ ! -x "$(command -v msfconsole)" ]
then
	apt-get install -y -qq metasploit-framework
fi

echo -e "\n + mitm6\n"

pip install mitm6

# echo -e "\n + naabu\n"

# apt-get install -y -qq libpcap-dev
# go install github.com/projectdiscovery/naabu/cmd/naabu@latest

echo -e "\n + netcat\n"

if [ ! -x "$(command -v nc)" ]
then
	apt-get install -y -qq netcat-openbsd
fi

echo -e "\n + netdiscover\n"

if [ ! -x "$(command -v netdiscover)" ]
then
	apt-get install -y -qq netdiscover
fi

# echo -e "\n + nmap\n"

# apt-get install -y -qq nmap

echo -e "\n + nmap-utils \n"

curl -sL https://raw.githubusercontent.com/enenumxela/nmap-utils/main/merge-nmap-xml -o /usr/local/bin/merge-nmap-xml

curl -sL https://raw.githubusercontent.com/enenumxela/nmap-utils/main/parse-nmap-xml -o /usr/local/bin/parse-nmap-xml

chmod +x /usr/local/bin/merge-nmap-xml /usr/local/bin/parse-nmap-xml

echo -e "\n + ping\n"

apt-get install -y -qq iputils-ping

echo -e "\n + proxychains4\n"

if [ ! -x "$(command -v proxychains4)" ]
then
	apt-get install -y -qq proxychains4
fi

echo -e "\n + ps.sh\n"

curl -s https://raw.githubusercontent.com/enenumxela/ps.sh/main/install.sh | bash -

echo -e "\n + responder\n"

if [ ! -x "$(command -v responder)" ]
then
	apt-get install -y -qq responder
fi

echo -e "\n + searchsploit\n"

if [ ! -x "$(command -v searchsploit)" ]
then
	apt-get install -y -qq exploitdb
fi