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

# -- Environment Variables & PATH --
export PROFILING_MODE=0
export DOKUBE=0 # Set to 1 to enable Kubernetes tools/completions

typeset -U path # Use Zsh's array for PATH, prevents duplicates
path=(
  "${HOME}/.rd/bin"          # Rancher Desktop
  "/opt/homebrew/bin"        # Homebrew (adjust if your path is different e.g. /usr/local/bin for older macOS or Linux)
  "${HOME}/.cargo/bin"       # Rust/Cargo
  $path                      # Original system PATH
)

if [[ -f ${HOME}/myinits/API ]]; then
  export HOMEBREW_GITHUB_API_TOKEN=$(< "${HOME}/myinits/API")
fi

export YSU_MODE=ALL # Assuming this is for Yet Another Shell Utility or similar

# -- Shell Prompt (PS1) --
autoload -U colors && colors

TIME="%{$bg[black]$fg[white]%}%*%{$reset_color%}"
USERINFO="%{$fg[yellow]%}${USERNAME}@${HOST}%{$reset_color%}"
ERRORINFO="%{$bg[black]$fg[red]%}!!%?!!%{$reset_color%}"
SPROMPT='zsh: correct %F{1}%R%f to %F{2}%r%f [nyae]? '

PS1='${USERINFO} %B%F{4}$(prompt-pwd)%b%(!. %B%F{1}#%b.)${_prompt_sorin_vimode:-%{$reset_color%}}%f ' ## OPTIMIZED: Added default for vimode prompt part
RPS1='${VIRTUAL_ENV:+"%F{3}(${VIRTUAL_ENV:t})"}%(?:: ${ERRORINFO} )${VIM:+" %B%F{6}V%b"}${(e)git_info[status]}%f ${duration_info}${TIME}'

# -- Aliases & Functions --

## OPTIMIZED: Lazy-loading function for `ls` to improve startup time.
## This function sets up ls colors and aliases the first time ls is called.
#_setup_ls_aliases() {
#  unfunction _setup_ls_aliases # Remove this loader after first run
#
#  local ls_cmd
#  # Determine if GNU ls is available
#  if command /bin/ls --help 2>&1 | grep -q 'GNU coreutils'; then
#    ls_cmd="/bin/ls"
#    # Setup GNU dircolors
#    if [[ -s "$HOME/.dir_colors" ]]; then
#      eval "$(dircolors --sh "$HOME/.dir_colors")"
#    else
#      eval "$(dircolors --sh)"
#    fi
#    alias ls="${ls_cmd} --color=auto -F"
#    # export JOEBLOW="gnu ls at /bin/ls" # Uncomment if you need this env var
#  elif command /usr/local/bin/gls --help 2>&1 | grep -q 'GNU coreutils'; then
#    ls_cmd="/usr/local/bin/gls"
#    # Setup GNU dircolors (using gdircolors if available, otherwise dircolors)
#    local dircolors_cmd
#    command -v gdircolors >/dev/null && dircolors_cmd="gdircolors" || dircolors_cmd="dircolors"
#    if [[ -s "$HOME/.dir_colors" ]]; then
#      eval "$(${dircolors_cmd} --sh "$HOME/.dir_colors")"
#    else
#      eval "$(${dircolors_cmd} --sh)"
#    fi
#    alias ls="${ls_cmd} --color=auto -F"
#    # export JOEBLOW="using /usr/local/bin/gls" # Uncomment if you need this env var
#  else
#    # BSD Core Utilities (default for macOS if GNU ls not installed)
#    ls_cmd="/bin/ls" # or whatever your system's default ls is
#    export LSCOLORS='bxfxcxdxbxGxDxabagacad' # Your preferred BSD LSCOLORS
#    # For completion system consistency with BSD ls -G
#    export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'
#    alias ls="${ls_cmd} -G -F" # -G for color on BSD, -F for indicators
#    # export JOEBLOW="bsd ls" # Uncomment if you need this env var
#  fi
#
#  alias lsd="${aliases[ls]:-ls} --group-directories-first" # Works if ls is GNU ls or compatible
#
#  # Call the intended ls command now that aliases are set up
#  $ls_cmd "$@"
#}
#alias ls='_setup_ls_aliases' # The first call to 'ls' will run the setup
#alias lsd='_setup_ls_aliases --group-directories-first'  # First lsd also triggers setup
alias lsd='ls --group-directories-first'  # First lsd also triggers setup

# Standard Aliases
alias k="kubectl"
alias dv="dirs -v"
alias zz="z -c" # zoxide/z.sh: matches directories only under $PWD
alias zi="z -I" # zoxide/z.sh: use fzf to select in multiple matches
alias rsynccp="rsync --archive --modify-window=2 --progress --verbose --itemize-changes --stats --human-readable"

# Global Aliases
alias -g C='| wc -l'
alias -g EG='|& egrep'
alias -g EL='|& less'
alias -g ETL='|& tail -20'
alias -g ET='|& tail'
alias -g G='| egrep' # Use G for grep if not already used by ls -G in BSD alias
alias -g NS='| sort -n'
alias -g NUL="> /dev/null 2>&1"
alias -g S='| sort'
alias -g TL='| tail -20'
alias -g T='| tail'
alias -g TF='| tail -f'
alias -g US='| sort -u'
alias -g X='| xargs'
alias -g LL="2>&1 | less"


# -- Tool Initializations & Sourced Files --

# Atuin Shell History
if (( $+commands[atuin] )); then
  export ATUIN_SESSION=$(atuin uuid)
  # export ATUIN_HISTORY="atuin history list" # This variable is not typically needed by Atuin itself
  _atuin_preexec(){
    local id; id=$(atuin history start -- "$1")
    export ATUIN_HISTORY_ID="$id"
  }
  _atuin_precmd(){
    local EXIT="$?"
    [[ -z "${ATUIN_HISTORY_ID}" ]] && return
    (RUST_LOG=error atuin history end --exit $EXIT -- $ATUIN_HISTORY_ID &) > /dev/null 2>&1 &! # Ensure fully detached
  }
  _atuin_search(){
    emulate -L zsh
    zle -I # Invalidate buffer
    echoti rmkx # Switch to cursor mode (terminfo)
    # Swap stderr and stdout for TUI interaction
    output=$(RUST_LOG=error atuin search --interactive --filter-mode host -- $BUFFER 3>&1 1>&2 2>&3)
    echoti smkx # Switch back to application mode (terminfo)
    if [[ -n $output ]] ; then
      LBUFFER=$output
      RBUFFER=""
    fi
    zle reset-prompt
    zle -R # Redisplay
  }

  autoload -U add-zsh-hook
  add-zsh-hook preexec _atuin_preexec
  add-zsh-hook precmd _atuin_precmd
  zle -N _atuin_search_widget _atuin_search

  if [[ -z $ATUIN_NOBIND ]]; then
    bindkey '^r' _atuin_search_widget
    # Arrow key bindings for search can be tricky due to terminal modes.
    # Check your terminal and Atuin docs if these don't work as expected.
    # bindkey "${terminfo[kcuu1]}" _atuin_search_widget # Up arrow (if terminfo available)
    # bindkey '^[OA' _atuin_search_widget # Common alternative for up arrow
  fi
fi

# Kubernetes Completion (sourced conditionally)
## OPTIMIZED: Consider using Zim's `kubernetes` module if available for simpler management.
if [[ $DOKUBE -ne 0 && -e ${HOME}/myinits/kubectl_completion ]]; then
  # Ensure bashcompinit is loaded before sourcing kubectl completions
  # Zim might handle this if one of its modules needs it.
  # If not, uncomment the next line:
  # autoload -U +X bashcompinit && bashcompinit
  source ${HOME}/myinits/kubectl_completion
fi

# Duration Info Hook Setup (from Zim, requires add-zsh-hook)
autoload -U add-zsh-hook # Ensure add-zsh-hook is loaded
if (( ${+functions[duration-info-preexec]} && ${+functions[duration-info-precmd]} )); then
  add-zsh-hook preexec duration-info-preexec
  add-zsh-hook precmd duration-info-precmd
fi

# -- Keybindings (Post-init module configuration) --
# zsh-history-substring-search (if loaded by Zim)
#if (( ${+functions[history-substring-search-up]} )); then # Check if function exists
#  bindkey '^[[A' history-substring-search-up # Or ${terminfo[kcuu1]} if preferred and loaded
#  bindkey '^[[B' history-substring-search-down # Or ${terminfo[kcud1]}
#  # zmodload -F zsh/terminfo +p:terminfo # Already done by Zim or can be added if needed
#  # if [[ -n ${terminfo[kcuu1]} && -n ${terminfo[kcud1]} ]]; then
#  #   bindkey ${terminfo[kcuu1]} history-substring-search-up
#  #   bindkey ${terminfo[kcud1]} history-substring-search-down
#  # fi
#  bindkey '^P' history-substring-search-up
#  bindkey '^N' history-substring-search-down
#  bindkey -M vicmd 'k' history-substring-search-up
#  bindkey -M vicmd 'j' history-substring-search-down
#fi

# -- Finalization & Profiling --
## OPTIMIZED: Moved zprof loading and call to the very end.
if [ $PROFILING_MODE -ne 0 ]; then
  zmodload zsh/zprof
  zprof
fi

## OPTIMIZED: Removed tmux symlink logic. Do this once manually.
# Example:
# if [[ -e ${HOME}/.tmux/plugins/tpm/tpm ]]; then
#   ln -sf ${HOME}/myinits/tmux.conf.with.plugins ${HOME}/.tmux.conf
# else
#   ln -sf ${HOME}/myinits/tmux.conf ${HOME}/.tmux.conf
# fi
# Run the above ln -sf command ONCE manually in your terminal.
