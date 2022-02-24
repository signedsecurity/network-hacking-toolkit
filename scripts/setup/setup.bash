#!/usr/bin/env bash

set -e

CONFIGURATIONS="/tmp/configurations"

# {{ ssh

echo -e " + ssh"

apt-get install -y -qq openssh-server

sed -i 's/#X11UseLocalhost yes/X11UseLocalhost no/' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# }} ssh
# {{ System 

echo -e " + Terminal"

# {{ Terminal

echo -e " +++++ Terminal"

# {{ bash

echo -e " +++++++++ SHELL (bash)"

mv ${CONFIGURATIONS}/.bashrc ${HOME}/.bashrc

# }} bash
# {{ tmux

echo -e " +++++++++ Multiplexer (tmux)"

if [ ! -x "$(command -v tmux)" ]
then
	apt-get install -y -qq tmux
fi

mv ${CONFIGURATIONS}/.tmux.conf ${HOME}/.tmux.conf

TMUX_PLUGINS="${HOME}/.tmux/plugins"

mkdir -p ${TMUX_PLUGINS}

git clone https://github.com/tmux-plugins/tpm.git ${TMUX_PLUGINS}/tpm

if [ -f ${TMUX_PLUGINS}/tpm/bin/install_plugins ]
then
	chmod +x ${TMUX_PLUGINS}/tpm/bin/install_plugins
	${TMUX_PLUGINS}/tpm/bin/install_plugins
fi

# }} tmux

# }} Terminal
# {{ Text Editor

echo -e " +++++ Text Editor"

# {{ vim

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

mv ${CONFIGURATIONS}/.vimrc ${HOME}/.vim/vimrc

# }} vim

# }} Text Editor



# {{ Wine 

# echo -e "Wine"

# enable i386 arch (required for 32bit windows)
# dpkg --add-architecture i386 && apt-get update

# Install wine
# apt-get install -y \
#         wine \
#         wine32 \
#         wine64 \
#         libwine \
#         libwine:i386 \
#         fonts-wine \
#         xvfb \
#         winbind

# Configure 32 bit wineprefix (avoid bugs they say - breaks 64 bit only programs...)
# WINEARCH=win32 WINEPREFIX=/root/.wine winecfg

# Install winetricks
# wget -O /usr/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
# chmod +x /usr/bin/winetricks
# xvfb-run -a winetricks --self-update

# Install dotnet framework 4.0
# xvfb-run -a winetricks -q dotnet40
# xvfb-run -a winetricks -q wmp10

# }} Wine
# {{ Advanced IP Scanner

# echo -e "Advanced IP Scanner"

# dir="/opt/Advanced_IP_Scanner"
# exe="Advanced_IP_Scanner_2.5.3850.exe"

# if [ ! -d ${dir} ]
# then
# 	mkdir -p ${dir}
# fi

# curl -sL "https://download.advanced-ip-scanner.com/download/files/${exe}" -o "${dir}/${exe}"

# cat << EOF > /usr/bin/advanced-ip-scanner
# #!/bin/sh
# wine ${dir}/${exe} \$@
# EOF

# chmod +x /usr/bin/advanced-ip-scanner

# }} Advanced IP Scanner
# {{ Angry IP Scanner

# echo -e "Angry IP Scanner"

# version="3.8.2"

# curl -sL "https://github.com/angryip/ipscan/releases/download/${version}/ipscan_${version}_amd64.deb" -o "/tmp/ipscan_${version}_amd64.deb"
# apt-get install -y -qq default-jdk
# apt-get install -y -qq /tmp/ipscan_${version}_amd64.deb

# }} Angry IP Scanner

# {{ nmap

echo -e " + nmap"

apt-get install -y -qq nmap

# }} nmap
# {{ naabu

echo -e " + naabu"

apt-get install -y -qq libpcap-dev
go install github.com/projectdiscovery/naabu/cmd/naabu@latest

# }} naabu
# {{ masscan

echo -e " + masscan"

apt-get install -y -qq masscan

# }} masscan
# {{ ps.sh

echo -e " + ps.sh"

apt-get install -y -qq libxml2-utils

file="/usr/local/bin/ps.sh"

curl -sL https://raw.githubusercontent.com/enenumxela/ps.sh/main/ps.sh -o ${file}

if [ -f ${file} ]
then
	chmod u+x ${file}
fi

# }} ps.sh
# {{ netdiscover

echo -e " + netdiscover"

apt-get install -y -qq netdiscover

# }} netdiscover
# {{ ping

echo -e " + ping"

apt-get install -y -qq iputils-ping

# }} ping
# {{ fping

echo -e " + fping"

apt-get install -y -qq fping

# }} fping
# {{ grep

echo -e " + grep"

apt-get install -y -qq grep

# }} grep
# {{ crackmapexec

python3 -m pip install pipx
pipx ensurepath
pipx install crackmapexec

# }} crackmapexec