#!/usr/bin/env bash

USER_LOCAL_BIN="${HOME}/.local/bin"

if [ ! -d ${USER_LOCAL_BIN} ]
then
	mkdir -p ${USER_LOCAL_BIN}
fi

CONFIGURATIONS="/tmp/configurations"

# {{ ssh

echo -e " + ssh"

apt-get install -y -qq openssh-server

sed -i 's/#X11UseLocalhost yes/X11UseLocalhost no/' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# }} ssh
# {{ System 

echo -e " + System"

# {{ Terminal

echo -e " +++++ Terminal"

# {{ zsh

echo -e " +++++++++ Shell (zsh)"

# install zsh
if [ ! -x "$(command -v zsh)" ]
then
	apt-get install -y -qq zsh
fi

# make zsh default shell
if [ "${SHELL}" != "$(which zsh)" ]
then
	chsh -s $(which zsh) ${USER}
fi

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended 

# zsh-autosuggestions
git clone "https://github.com/zsh-users/zsh-autosuggestions" "${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
# zsh-syntax-highlighting
git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"

# set up dotfiles
mv ${CONFIGURATIONS}/.zshrc ${HOME}/.zshrc
mv ${CONFIGURATIONS}/.zprofile ${HOME}/.zprofile
mv ${CONFIGURATIONS}/.hushlogin ${HOME}/.hushlogin

# }} zsh
# {{ tmux

echo -e " +++++++++ Session Management (tmux)"

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
git clone https://github.com/tpope/vim-fugitive.git ${VIM_BUNDLE}/vim-fugitive
git clone https://github.com/preservim/nerdtree.git ${VIM_BUNDLE}/nerdtree
git clone https://github.com/airblade/vim-gitgutter.git ${VIM_BUNDLE}/vim-gitgutter
git clone https://github.com/ryanoasis/vim-devicons.git ${VIM_BUNDLE}/vim-devicons
git clone https://github.com/vim-airline/vim-airline.git ${VIM_BUNDLE}/vim-airline
git clone https://github.com/Xuyuanp/nerdtree-git-plugin.git ${VIM_BUNDLE}/nerdtree-git-plugin

# mv ${CONFIGURATIONS}/.vimrc ${HOME}/.vim/vimrc

# }} vim

# }} Text Editor
# {{ Browser 

echo -e " +++++ Browser"

# {{ firefox

echo -e " +++++++++ firefox"

apt-get install -y -qq firefox-esr ca-certificates libcanberra-gtk3-module

mv -f ${CONFIGURATIONS}/.mozilla ${HOME}/.mozilla

# }} firefox

# }} Browser

# }} System
# {{ Tools

echo -e "\n + bloodhound\n"

apt-get install -y -qq bloodhound
pip3 install bloodhound

echo -e "\n + certipy\n"

git clone https://github.com/ly4k/Certipy.git /tmp/Certipy
cd /tmp/Certipy
python3 setup.py install
cd -

echo -e "\n + crackmapexec\n"

pipx install crackmapexec

echo -e "\n + dnsutils\n"

apt-get install -y -qq dnsutils

echo -e "\n + enum4linux\n"

apt-get install -y -qq enum4linux

echo -e "\n + evil-winrm\n"

apt-get install -y -qq evil-winrm

echo -e "\n + fping\n"

apt-get install -y -qq fping

echo -e "\n + grep\n"

apt-get install -y -qq grep

echo -e "\n + impacket\n"

git clone https://github.com/SecureAuthCorp/impacket.git /opt/impacket
pip3 install -r /opt/impacket/requirements.txt
cd /opt/impacket
python3 ./setup.py install
cd -

echo -e "\n + ldap-utils\n"

apt-get install -y -qq ldap-utils

echo -e "\n + masscan\n"

apt-get install -y -qq masscan

echo -e "\n + mitm6\n"

pip install mitm6

echo -e "\n + naabu\n"

apt-get install -y -qq libpcap-dev
go install github.com/projectdiscovery/naabu/cmd/naabu@latest

echo -e "\n + netdiscover\n"

apt-get install -y -qq netdiscover

echo -e "\n + nmap\n"

apt-get install -y -qq nmap

echo -e "\n + nmap-utils \n"

curl -sL https://raw.githubusercontent.com/enenumxela/nmap-utils/main/merge-nmap-xml -o /usr/local/bin/merge-nmap-xml

curl -sL https://raw.githubusercontent.com/enenumxela/nmap-utils/main/merge-nmap-xml -o /usr/local/bin/parse-nmap-xml

chmod +x /usr/local/bin/merge-nmap-xml /usr/local/bin/parse-nmap-xml

echo -e "\n + ping\n"

apt-get install -y -qq iputils-ping

echo -e "\n + ps.sh\n"

curl -s https://raw.githubusercontent.com/enenumxela/ps.sh/main/install.sh | bash -

echo -e "\n + responder\n"

apt-get install -y -qq responder

# }}