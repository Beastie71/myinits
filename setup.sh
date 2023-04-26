#!/bin/bash

cd ${HOME}
date=`date +"%Y-%m-%d-%H%M"`

if [ ! -d ${HOME}/myinits ]; then 
    echo "Cloning my init files."
    git clone https://github.com/Beastie71/myinits.git
fi
#git clone --recursive https://github.com/sorin-ionescu/prezto.git
#ln -s prezto .zprezto
if [ ! -x ${HOME}/.cargo/bin/atuin ]; then
    echo "Installing atuin for search."
    bash <(curl https://raw.githubusercontent.com/ellie/atuin/main/install.sh)
fi

if [ ! -d ${HOME}/.zim ]; then
    echo "Installing zim."
    if [ -a ${HOME}/.zshrc ]; then
        mv ${HOME}/.zshrc ${HOME}/.zshrc.prezim-${date}
    curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
fi

# if [ ! -d ${HOME}/.zim/modules/sorin ]; then
#     echo "Installing sorin."
#     git clone https://github.com/zimfw/sorin.git ${HOME}/.zim/modules/sorin
# fi

# if [ ! -d ${HOME}/.zim/modules/prompt-pwd ]; then
#     echo "Installing sorin."
#     git clone https://github.com/zimfw/sorin.git ${HOME}/.zim/modules/sorin
# fi


# if [ ! -d ${HOME}/.zinit ]; then
#     echo "Setting up zinit."
#     mkdir -p ${HOME}/.zinit/bin
#     git clone https://github.com/zdharma/zinit.git ${HOME}/.zinit/bin
#     ${HOME}/.zinit/bin/zinit pack for fzf
# fi

echo "Setting up links to startup files."
if [ -f ${HOME}/.zlogin ]; then
    mv ${HOME}/.zlogin ${HOME}/.zlogin-${date}
elif [ -h ${HOME}/.zlogin ]; then
    rm -f ${HOME}/.zlogin
fi
ln -s ${HOME}/myinits/zlogin ${HOME}/.zlogin
if [ -f ${HOME}/.zlogout ]; then
    mv ${HOME}/.zlogout ${HOME}/.zlogout-${date}
elif [ -h ${HOME}/.zlogout ]; then
    rm -f ${HOME}/.zlogout
fi
ln -s ${HOME}/myinits/zlogout ${HOME}/.zlogout
if [ -f ${HOME}/.zprofile ]; then
    mv ${HOME}/.zprofile ${HOME}/.zprofile-${date}
elif [ -h ${HOME}/.zprofile ]; then
    rm -f ${HOME}/.zprofile
fi
ln -s ${HOME}/myinits/zprofile ${HOME}/.zprofile
if [ -f ${HOME}/.zshenv ]; then
    mv ${HOME}/.zshenv ${HOME}/.zshenv-${date}
elif [ -h ${HOME}/.zshenv ]; then
    rm -f ${HOME}/.zshenv
fi
ln -s ${HOME}/myinits/zshenv ${HOME}/.zshenv
if [ -f ${HOME}/.zshrc ]; then
    mv ${HOME}/.zshrc ${HOME}/.zshrc-${date}
elif [ -h ${HOME}/.zshrc ]; then
    rm -f ${HOME}/.zshrc
fi
ln -s ${HOME}/myinits/zshrc ${HOME}/.zshrc
if [ -f ${HOME}/.zimrc ]; then
    mv ${HOME}/.zimrc ${HOME}/.zimrc-${date}
elif [ -h ${HOME}/.zimrc ]; then 
    rm -f ${HOME}/.zlogin
fi
ln -s ${HOME}/myinits/zimrc ${HOME}/.zimrc

if [ -f ${HOME}/.vimrc ]; then
    mv ${HOME}/.vimrc ${HOME}/.vimrc-${date}
elif [ -h ${HOME}/.vimrc ]; then
    rm -f ${HOME}/.vimrc
fi
ln -s ${HOME}/myinits/vimrc ${HOME}/.vimrc

echo "Running zimfw."
${HOME}/.zim/zimfw.zsh install
