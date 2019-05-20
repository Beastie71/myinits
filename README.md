My Init files
==============================

These are meant to be used with zsh Prezto.  In order to make updating prezto easier, I moved my inits into a separate folder,
created sym links to the startup files, and in order to have my customized prompt, add the functions area to fpath.

Installation
------------

  1. Link files:

     ```ln -s <gitrepodir>/zlogin ~/.zlogin
     ln -s <gitrepodir>/zlogout ~/.zlogout
     ln -s <gitrepodir>/zshrc ~/.zshrc
     ln -s <gitrepodir>/zpreztorc ~/.zpreztorc
     ln -s <gitrepodir>/zprofile ~/.zprofile
     ln -s <gitrepodir>/zshenv ~/.zshenv
     ```

  2. Modify the zshrc to add new functions dir to path (note could not get the right path off the .zshrc due to sym link so had to put in the repo):

     ```  if [[ -s "${ZDOTDIR:-$HOME}/myinits/functions" ]]; then
      fpath=(${ZDOTDIR:-$HOME}/myinits/functions $fpath)
    fi
     ```
