#!/bin/bash

cd ${HOME}
git clone https://github.com/Beastie71/myinits.git
git clone --recursive https://github.com/sorin-ionescu/prezto.git
ln -s prezto .zprezto
mkdir -p ${HOME}/.zinit
git clone https://github.com/zdharma/zinit.git ~/.zinit/bin
${HOME}/.zinit/bin/zinit pack for fzf

ln -s ${HOME}/myinits/zlogin ${HOME}/.zlogin
ln -s ${HOME}/myinits/zlogout ${HOME}/.zlogout
ln -s ${HOME}/myinits/zpreztorc ${HOME}/.zpreztorc
ln -s ${HOME}/myinits/zprofile ${HOME}/.zprofile
ln -s ${HOME}/myinits/zshenv ${HOME}/.zshenv
ln -s ${HOME}/myinits/zshrc ${HOME}/.zshrc
ln -s ${HOME}/myinits/vimrc ${HOME}/.vimrc
