# Start configuration added by Zim install {{{
#
# User configuration sourced by interactive shells
#

# -----------------
# Zsh configuration
# -----------------
setopt HIST_IGNORE_ALL_DUPS
bindkey -e
WORDCHARS=${WORDCHARS//[\/]} # Remove path separator

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -----------------
# Zim configuration
# -----------------
zstyle ':zim:zmodule' use 'degit'

# --------------------
# Module configuration (pre-init)
# --------------------
zstyle ':zim:completion' dumpfile "${ZDOTDIR:-${HOME}}/.zcompdump-${ZSH_VERSION}"
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

OKMARK="✔"
HOURGLASS=""
zstyle ':zim:duration-info' format "%{$bg[blue]$fg[white]%}"'%B'${HOURGLASS}'%d %f%b'

# ------------------
# Initialize modules
# ------------------
ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -kfsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
# Check if .zimrc exists and is the source of truth for module list
if [[ -f "${ZDOTDIR:-${HOME}}/.zimrc" && (! -e ${ZIM_HOME}/init.zsh || ${ZIM_HOME}/init.zsh -ot ${ZDOTDIR:-${HOME}}/.zimrc) ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
source ${ZIM_HOME}/init.zsh

# }}} End configuration added by Zim install
# -----------------------------------------------------------------------------
# -------------------------- USER CONFIGURATION -------------------------------
# -----------------------------------------------------------------------------

# -- Shell Prompt (PS1) --
autoload -U colors && colors

TIME="%{$bg[black]$fg[white]%}%*%{$reset_color%}"
USERINFO="%{$fg[yellow]%}${USERNAME}@${HOST}%{$reset_color%}"
ERRORINFO="%{$bg[black]$fg[red]%}!!%?!!%{$reset_color%}"
SPROMPT='zsh: correct %F{1}%R%f to %F{2}%r%f [nyae]? '

PS1='${USERINFO} %B%F{4}$(prompt-pwd)%b%(!. %B%F{1}#%b.)${_prompt_sorin_vimode:-%{$reset_color%}}%f >' ## OPTIMIZED: Added default for vimode prompt part
RPS1='${VIRTUAL_ENV:+"%F{3}(${VIRTUAL_ENV:t})"}%(?:: ${ERRORINFO} )${VIM:+" %B%F{6}V%b"}${(e)git_info[status]}%f ${duration_info}${TIME}'

alias lsd='ls --group-directories-first'  # First lsd also triggers setup

# -- Tool Initializations & Sourced Files --

# Atuin Shell History
source ${HOME}/myinits/zsh_atuin

# Kubernetes Completion (sourced conditionally)
## OPTIMIZED: Consider using Zim's `kubernetes` module if available for simpler management.
if [[ $DOKUBE -ne 0 && -e ${HOME}/myinits/kubectl_completion ]]; then
  # Ensure bashcompinit is loaded before sourcing kubectl completions
  # Zim might handle this if one of its modules needs it.
  # If not, uncomment the next line:
  # autoload -U +X bashcompinit && bashcompinit
  kubectl() {
     unfunction kubectl
     source ${HOME}/myinits/kubectl_completion
     command kubectl "$@"
  }

fi

# Duration Info Hook Setup (from Zim, requires add-zsh-hook)
autoload -U add-zsh-hook # Ensure add-zsh-hook is loaded
if (( ${+functions[duration-info-preexec]} && ${+functions[duration-info-precmd]} )); then
  add-zsh-hook preexec duration-info-preexec
  add-zsh-hook precmd duration-info-precmd
fi

# -- Finalization & Profiling --
## OPTIMIZED: Moved zprof loading and call to the very end.
if [ $PROFILING_MODE -ne 0 ]; then
  zmodload zsh/zprof
  zprof
fi

if [[ -e ${HOME}/myinits/aliases.zsh ]]; then
    source ${HOME}/myinits/aliases.zsh
fi

# Source NPCSH configuration
if [ -f ~/.npcshrc ]; then
    . ~/.npcshrc
fi
