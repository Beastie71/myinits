# Start configuration added by Zim install {{{
#
# User configuration sourced by interactive shells
#

# -----------------
# Zsh configuration
# -----------------

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -e

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# -----------------
# Zim configuration
# -----------------

# Use degit instead of git as the default tool to install and update modules.
zstyle ':zim:zmodule' use 'degit'

# --------------------
# Module configuration (pre-init)
# --------------------
# These zstyles configure Zim modules and MUST come BEFORE init.zsh is sourced.

# completion
zstyle ':zim:completion' dumpfile "${ZDOTDIR:-${HOME}}/.zcompdump-${ZSH_VERSION}"

# termtitle
#zstyle ':zim:termtitle' format '%1~'

# zsh-autosuggestions
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

# zsh-syntax-highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# duration-info
# Hook setup is moved to post-init section
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
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
source ${ZIM_HOME}/init.zsh

# }}} End configuration added by Zim install
# -----------------------------------------------------------------------------
# -------------------------- USER CONFIGURATION -------------------------------
# -----------------------------------------------------------------------------

# -- Environment Variables & PATH --

## OPTIMIZED: Central control flags for profiling and Kubernetes tools.
export PROFILING_MODE=0
export DOKUBE=0

## OPTIMIZED: Use Zsh's built-in `path` array for cleaner management.
## This prevents duplicate entries and is easier to read.
typeset -U path
path=(
  ${HOME}/.rd/bin          # Rancher Desktop
  /opt/homebrew/bin        # Homebrew
  ${HOME}/.cargo/bin       # Rust/Cargo
  $path                    # The original system PATH
)

# Load Homebrew API token if the file exists.
## OPTIMIZED: Use Zsh's built-in redirection instead of spawning `cat`.
if [[ -f ${HOME}/myinits/API ]]; then
  export HOMEBREW_GITHUB_API_TOKEN=$(< ${HOME}/myinits/API)
fi

export YSU_MODE=ALL

# -- Shell Prompt (PS1) --

autoload -U colors && colors

TIME="%{$bg[black]$fg[white]%}%*%{$reset_color%}"
USERINFO="%{$fg[yellow]%}${USERNAME}@${HOST}%{$reset_color%}"
ERRORINFO="%{$bg[black]$fg[red]%}!!%?!!%{$reset_color%}"
SPROMPT='zsh: correct %F{1}%R%f to %F{2}%r%f [nyae]? '

PS1='${USERINFO} %B%F{4}$(prompt-pwd)%b%(!. %B%F{1}#%b.)$(_prompt_sorin_vimode)%f '
RPS1='${VIRTUAL_ENV:+"%F{3}(${VIRTUAL_ENV:t})"}%(?:: ${ERRORINFO} )${VIM:+" %B%F{6}V%b"}${(e)git_info[status]}%f ${duration_info}${TIME}'


# -- Aliases, Functions, and Sourced Files --

## OPTIMIZED: Group all sourced files together.
if [[ -e ${HOME}/myinits/aliases.zsh ]]; then
  source ${HOME}/myinits/aliases.zsh
fi

if [[ -e ${HOME}/myinits/kubectl_completion && $DOKUBE -ne 0 ]]; then
  source ${HOME}/myinits/kubectl_completion
fi


# -- Tool Initializations --

# Atuin Shell History
if (( $+commands[atuin] )); then
  export ATUIN_SESSION=$(atuin uuid)
  export ATUIN_HISTORY="atuin history list"

  _atuin_preexec(){
    local id; id=$(atuin history start -- "$1")
    export ATUIN_HISTORY_ID="$id"
  }
  _atuin_precmd(){
    local EXIT="$?"
    [[ -z "${ATUIN_HISTORY_ID}" ]] && return
    # Run in background to not block the prompt
    (RUST_LOG=error atuin history end --exit $EXIT -- $ATUIN_HISTORY_ID &) > /dev/null 2>&1
  }
  _atuin_search(){
    emulate -L zsh
    zle -I
    # Switch terminal modes for the TUI
    echoti rmkx
    output=$(RUST_LOG=error atuin search -i -- $BUFFER 3>&1 1>&2 2>&3)
    echoti smkx
    if [[ -n $output ]] ; then
      RBUFFER=""
      LBUFFER=$output
    fi
    zle reset-prompt
  }

  autoload -U add-zsh-hook
  add-zsh-hook preexec _atuin_preexec
  add-zsh-hook precmd _atuin_precmd

  zle -N _atuin_search_widget _atuin_search

  if [[ -z $ATUIN_NOBIND ]]; then
    bindkey '^r' _atuin_search_widget
    # These depend on terminal mode
    bindkey '^[[A' _atuin_search_widget # Up arrow
    bindkey '^[OA' _atuin_search_widget # Up arrow in different mode
  fi
fi

# Duration Info (from Zim)
autoload -U add-zsh-hook
if (( ${+functions[duration-info-preexec]} && ${+functions[duration-info-precmd]} )); then
  add-zsh-hook preexec duration-info-preexec
  add-zsh-hook precmd duration-info-precmd
fi


# -- Keybindings --

# zsh-history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
zmodload -F zsh/terminfo +p:terminfo
if [[ -n ${terminfo[kcuu1]} && -n ${terminfo[kcud1]} ]]; then
  bindkey ${terminfo[kcuu1]} history-substring-search-up
  bindkey ${terminfo[kcud1]} history-substring-search-down
fi
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# -- Finalization --

## OPTIMIZED: This profiling call should be the very last thing in the file.
if [ $PROFILING_MODE -ne 0 ]; then
  zmodload zsh/zprof
  zprof
fi
