#!/bin/bash

cd ${HOME}
date=`date +"%Y-%m-%d-%H%M"`

do_all=1
do_inits=0

while getopts "ai" opt
do
    case $opt in
    (i) do_all=0 ; do_inits=1 ;;
    (a) do_all=1 ;;
    (*) printf "Illegal option '-%s'\n" "$opt" && exit 1 ;;
    esac
done

if [[ $do_all -eq 1 ]]; then
    if [[ ! -d ${HOME}/myinits ]]; then 
        echo "Cloning my init files."
        git clone https://github.com/Beastie71/myinits.git
        if [[ ! $? -eq 0 ]]; then
            echo "Git clone of myinits failed.  We need these, so try this manually:  git clone https://github.com/Beastie71/myinits.git"
            exit 1
        fi
    fi
    haszsh=`zsh --version`
    if [[ ${haszsh} =~ "*zsh*" ]]; then
        echo "You must install zsh first."
        exit 1
    fi
    if [[ ! -x ${HOME}/.cargo/bin/atuin ]]; then
        if [[ ${OSTYPE} =~ "*darwin*" ]]; then
            echo "MacOS"
            cargoout=`cargo -V`
            if [[ ! ${cargoout} =~ "cargo" ]]; then
                installatuin=true
            else
                brew=`which brew`
                if [[ ! -x ${brew} ]]; then
                    echo "You must have HomeBrew installed first."
                    exit 1
                else
                    ${brew} install -q rustup 
                    if [[ $? -eq 0 ]]; then 
                        installatuin=true
                    else
                        echo "Something went wrong on installing cargo."
                        exit 1
                    fi
                fi
            fi
        elif [[ ${OSTYPE} =~ "*linux*" ]]; then
            echo "Linux"
            cargoout=`cargo -V`
            if [[ ! ${cargoout} =~ "cargo" ]]; then
                installatuin=true
            else
                name=`egrep "^NAME" /etc/os-release`
                if [[ ! ${name,,} =~ "*suse*" ]]; then
                    sudo zypper install -y -l cargo
                    if [[ $? -eq 0 ]]; then
                        installatuin=true
                    else
                        echo "Something went wrong installing cargo.  Please try yourself."
                        exit 1
                    fi
                elif [[ ! ${name,,} =~ "*ubuntu*" ]]; then
                    sudo apt-get --assume-yes install cargo
                    if [[ $? -eq 0 ]]; then 
                        installatuin=1
                    else
                        echo "Something went wrong installing cargo.  Please try yourself."
                        exit 1
                    fi
                else
                    echo "Unknown version of Linux."
                fi
            fi
        fi
        if [[] ! -d ${HOME}/.zim ]]; then
            echo "Installing zim."
        if [ -a ${HOME}/.zshrc ]; then
            mv ${HOME}/.zshrc ${HOME}/.zshrc.prezim-${date}
        fi
        curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
        if [[ ! $? -eq 0 ]]; then
            echo "Error installing zim please try yourself: curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh"
            exit 1
        fi
    fi

    fi

    if [[ -n installatuin ]]; then
        echo "Installing atuin for search."
        bash <(curl https://raw.githubusercontent.com/ellie/atuin/main/install.sh)
        if [[ ! $? -eq 0 ]]; then
            echo "Error installing atuin, please try yourself:  bash <(curl https://raw.githubusercontent.com/ellie/atuin/main/install.sh) "
            exit 1
        fi
    fi

elif [[ $do_inits -eq 1 ]]; then 

    if [[ ! -d ${HOME}/myinits ]]; then 
        echo "Cloning my init files."
        git clone https://github.com/Beastie71/myinits.git
        if [[ ! $? -eq 0 ]]; then
            echo "Git clone of myinits failed.  We need these, so try this manually:  git clone https://github.com/Beastie71/myinits.git"
            exit 1
        fi
    fi
    haszsh=`zsh --version`
    if [[ ${haszsh} =~ "*zsh*" ]]; then
        echo "You must install zsh first."
        exit 1
    fi

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
fi

if [[ $do_all -eq 1 ]]; then
    echo "Running zimfw."
    chmod u+x ${HOME}/.zim/zimfw.zsh
    zsh -c ${HOME}/.zim/zimfw.zsh install
    if [[ ! $? -eq 0 ]]; then
        echo "Error running zimfw, please try yourself:  ${HOME}/.zim/zimfw.zsh install"
        exit 1
    fi
fi

echo "Done."
