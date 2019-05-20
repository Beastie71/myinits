#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  if [[ -e "${ZDOTDIR:-$HOME}/myinits/functions" ]]; then
    fpath=(${ZDOTDIR:-$HOME}/myinits/functions $fpath)
  fi
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

USER=`echo $USERNAME`
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

PATH="/Users/${USER}/perl5/bin${PATH:+:${PATH}}:/usr/local/bin"; export PATH;
PERL5LIB="/Users/${USER}/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/${USER}/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/${USER}/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/${USER}/perl5"; export PERL_MM_OPT;
