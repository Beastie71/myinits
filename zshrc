# Start configuration added by Zim install {{{
#
# User configuration sourced by interactive shells
#

# -----------------
# Zsh configuration
# -----------------

#
# History
#

# Remove older command from the history if a duplicate is to be added.
#
OKMARK="✔"
HOURGLASS=""

setopt HIST_IGNORE_ALL_DUPS

#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -e

# Prompt for spelling correction of commands.
#setopt CORRECT

# Customize spelling correction prompt.
#SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# -----------------
# Zim configuration
# -----------------

# Use degit instead of git as the default tool to install and update modules.
zstyle ':zim:zmodule' use 'degit'

# --------------------
# Module configuration
# --------------------

#
# completion
#

# Set a custom path for the completion dump file.
# If none is provided, the default ${ZDOTDIR:-${HOME}}/.zcompdump is used.
zstyle ':zim:completion' dumpfile "${ZDOTDIR:-${HOME}}/.zcompdump-${ZSH_VERSION}"

#
# git
#

# Set a custom prefix for the generated aliases. The default prefix is 'G'.
#zstyle ':zim:git' aliases-prefix 'g'

#
# input
#

# Append `../` to your input for each `.` you type after an initial `..`
#zstyle ':zim:input' double-dot-expand yes

#
# termtitle
#

# Set a custom terminal title format using prompt expansion escape sequences.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
# If none is provided, the default '%n@%m: %~' is used.
#zstyle ':zim:termtitle' format '%1~'

#
# zsh-autosuggestions
#

# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

#
# zsh-syntax-highlighting
#

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# ------------------
# Initialize modules
# ------------------

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  # Download zimfw script if missing.
  if (( ${+commands[curl]} )); then
    curl -kfsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  # Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

#
# zsh-history-substring-search
#

# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Bind up and down keys
zmodload -F zsh/terminfo +p:terminfo
if [[ -n ${terminfo[kcuu1]} && -n ${terminfo[kcud1]} ]]; then
  bindkey ${terminfo[kcuu1]} history-substring-search-up
  bindkey ${terminfo[kcud1]} history-substring-search-down
fi

bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
# }}} End configuration added by Zim install

autoload -Uz compinit; compinit; _comp_options+=(globdots);
autoload -U colors && colors

if (( ${+functions[duration-info-preexec]} && \
	    ${+functions[duration-info-precmd]} )); then
  #zstyle ':zim:duration-info' format ' %B%F{yellow}'${HOURGLASS}'%d%f%b'
  zstyle ':zim:duration-info' format "%{$bg[blue]$fg[white]%}"'%B'${HOURGLASS}'%d %f%b'
    add-zsh-hook preexec duration-info-preexec
      add-zsh-hook precmd duration-info-precmd
fi
export YSU_MODE=ALL
export PATH=${PATH}:${HOME}/.cargo/bin

TIME="%{$bg[black]$fg[white]%}%*%{$reset_color%}"
USERINFO="%{$fg[yellow]%}${USERNAME}@${HOST}%{$reset_color%}"
ERRORINFO="%{$bg[black]$fg[red]%}!!%?!!%{$reset_color%}"
#
#PS1='${SSH_TTY:+"%F{9}%n%F{7}@%F{3}%m "}%B%F{4}$(prompt-pwd)%b%(!. %B%F{1}#%b.)$(_prompt_sorin_vimode)%f '
RPS1='${VIRTUAL_ENV:+"%F{3}(${VIRTUAL_ENV:t})"}%(?:: ${ERRORINFO} )${VIM:+" %B%F{6}V%b"}${(e)git_info[status]}%f ${duration_info}${TIME}'
SPROMPT='zsh: correct %F{1}%R%f to %F{2}%r%f [nyae]? '

PS1='${USERINFO} %B%F{4}$(prompt-pwd)%b%(!. %B%F{1}#%b.)$(_prompt_sorin_vimode)%f '
#PS1='${USERNAME}@${HOST}%{$reset_color%} %B%F{4}$(prompt-pwd)%b%(!. %B%F{1}#%b.)$(_prompt_sorin_vimode)%f '
#PS1="%F{2}${USERNAME}@%F{1}${HOST}:%B%F{4}$(prompt-pwd)%b%(!. %B%F{1}#%b.)$(_prompt_sorin_vimode)%f "
#RPS1="| ${duration_info}%f"
#

# shellcheck disable=SC2034,SC2153,SC2086,SC2155

# Above line is because shellcheck doesn't support zsh, per
# https://github.com/koalaman/shellcheck/wiki/SC1071, and the ignore: param in
# ludeeus/action-shellcheck only supports _directories_, not _files_. So
# instead, we manually add any error the shellcheck step finds in the file to
# the above line ...

# Source this in your ~/.zshrc
autoload -U add-zsh-hook

if [ -f ${HOME}/myinits/API ]; then 
	export HOMEBREW_GITHUB_API_TOKEN=`cat ${HOME}/myinits/API`
fi 

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


		(RUST_LOG=error atuin history end --exit $EXIT -- $ATUIN_HISTORY_ID &) > /dev/null 2>&1
	}

	_atuin_search(){
		emulate -L zsh
		zle -I

		# Switch to cursor mode, then back to application
		echoti rmkx
		# swap stderr and stdout, so that the tui stuff works
		# TODO: not this
		output=$(RUST_LOG=error atuin search -i -- $BUFFER 3>&1 1>&2 2>&3)
		echoti smkx

		if [[ -n $output ]] ; then
			RBUFFER=""
			LBUFFER=$output
		fi

		zle reset-prompt
	}

	add-zsh-hook preexec _atuin_preexec
	add-zsh-hook precmd _atuin_precmd

	zle -N _atuin_search_widget _atuin_search

	if [[ -z $ATUIN_NOBIND ]]; then
		bindkey '^r' _atuin_search_widget

		# depends on terminal mode
		bindkey '^[[A' _atuin_search_widget
		bindkey '^[OA' _atuin_search_widget
	fi
fi

if [[ -e ${HOME}/myinits/aliases.zsh ]]; then

    source ${HOME}/myinits/aliases.zsh
fi




### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="${HOME}/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
