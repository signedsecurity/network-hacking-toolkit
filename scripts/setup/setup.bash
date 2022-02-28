#!/usr/bin/env bash

# set -e

CONFIGURATIONS="/tmp/configurations"

USER_LOCAL_BIN="${HOME}/.local/bin"

if [ ! -d ${USER_LOCAL_BIN} ]
then
	mkdir -p ${USER_LOCAL_BIN}
fi

# {{ ssh

echo -e "\n + ssh\n"

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


# {{ nmap

echo -e "\n + nmap\n"

apt-get install -y -qq nmap

# }} nmap
# {{ naabu

echo -e "\n + naabu\n"

apt-get install -y -qq libpcap-dev
go install github.com/projectdiscovery/naabu/cmd/naabu@latest

# }} naabu
# {{ masscan

echo -e "\n + masscan\n"

apt-get install -y -qq masscan

# }} masscan
# {{ ps.sh

echo -e "\n + ps.sh\n"

curl -s https://raw.githubusercontent.com/enenumxela/ps.sh/main/install.sh | bash -

# }} ps.sh
# {{ netdiscover

echo -e "\n + netdiscover\n"

apt-get install -y -qq netdiscover

# }} netdiscover
# {{ ping

echo -e "\n + ping\n"

apt-get install -y -qq iputils-ping

# }} ping
# {{ fping

echo -e "\n + fping\n"

apt-get install -y -qq fping

# }} fping
# {{ grep

echo -e "\n + grep\n"

apt-get install -y -qq grep

# }} grep
# {{ crackmapexec

echo -e "\n + crackmapexec\n"

pipx install crackmapexec

# }} crackmapexec
# {{ evil-winrm

echo -e "\n + evil-winrm\n"

apt-get install -y -qq evil-winrm

# }} evil-winrm
# {{ responder

echo -e "\n + responder\n"

apt-get install -y -qq responder

# }} responder