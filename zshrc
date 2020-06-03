#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source zinit & Prezto.
#

if [[ -s "${ZDOTDIR:-$HOME}/.zinit/bin/zinit.zsh" ]]; then
  source ~/.zinit/bin/zinit.zsh
fi

if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  if [[ -e "${ZDOTDIR:-$HOME}/myinits/functions" ]]; then
    fpath=(${ZDOTDIR:-$HOME}/myinits/functions $fpath)
  fi
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

USER=`echo $USERNAME`
THEME=`prompt -c | grep -v Curr | sed 's/ //g'`
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

if [[ "$THEME" == "powerlevel10k" ]]; then
	source ${HOME}/myinits/p10k.zsh
fi

PATH="/Users/${USER}/perl5/bin${PATH:+:${PATH}}:/usr/local/bin:${GOPATH}/bin"; export PATH;
PERL5LIB="/Users/${USER}/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/${USER}/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/${USER}/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/${USER}/perl5"; export PERL_MM_OPT;

if grep zinit <<< $FPATH &> /dev/null
then
  zinit load zsh-interactive-cd 
  zinit load fzf
  zinit load fzf-z
  zinit load z
#  zinit load zsh-autosuggestions
  bindkey "ç" fzf-cd-widget
  bindkey "^j" autosuggest-accept
  if [[ -e /usr/local/Cellar/fzf/0.21.1/shell/key-bindings.zsh ]]; then
    source /usr/local/Cellar/fzf/0.21.1/shell/key-bindings.zsh
  fi
  export FZF_COMPLETION_TRIGGER='**'
  export FZF_DEFAULT_OPTS="
--layout=reverse
--info=inline
--height=40%
--multi
--preview-window=:hidden
--color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'
--prompt='∼ --marker='✓'
"
#--preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
#--bind '?:toggle-preview'
#--bind 'ctrl-a:select-all'
#--bind 'ctrl-y:execute-silent(echo {+} | pbcopy)'
#--bind 'ctrl-e:execute(echo {+} | xargs -o vim)'
#--bind 'ctrl-v:execute(code {+})'
#"
  if [[ -e /usr/local/bin/fd ]]; then
    export FZF_DEFAULT_COMMAND="fd --hidden --follow --exclude '.git'"
  fi
  # CTRL-T's command
  #export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  # ALT-C's command
  export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"
  export _ZL_HYPHEN=1
  # Ctrl-R command preview ? toggles
  export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
fi

# find-in-file - usage: fif <SEARCH_TERM>
fif() {
  if [ ! "$#" -gt 0 ]; then
    echo "Need a string to search for!";
    return 1;
  fi
  if [[ -e /usr/local/bin/rg ]]; then
    rg --files-with-matches --no-messages "$1" | fzf $FZF_PREVIEW_WINDOW --preview "rg --ignore-case --pretty --context 10 '$1' {}"
  else
    grep --ignore-case | fzf $FZF_PREVIEW_WINDOW 
  fi
}
