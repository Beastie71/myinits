#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source zinit & Prezto.
#

[[ -s "${ZDOTDIR:-$HOME}/.zinit/bin/zinit.zsh" ]] && source ~/.zinit/bin/zinit.zsh

if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  [[ -d "${ZDOTDIR:-$HOME}/myinits/functions" ]] && fpath=(${ZDOTDIR:-$HOME}/myinits/functions $fpath)
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
  bindkey "^j" autosuggest-accept
fi

# Customize to your needs...

USER=`echo $USERNAME`
THEME=`prompt -c | grep -v Curr | sed 's/ //g'`
[[ -e "${HOME}/.iterm2_shell_integration.zsh" ]] && source "${HOME}/.iterm2_shell_integration.zsh"

[[ "$THEME" == "powerlevel10k" ]] && source ${HOME}/myinits/p10k.zsh

PATH="/Users/${USER}/perl5/bin${PATH:+:${PATH}}:/usr/local/bin:${GOPATH}/bin"; export PATH;
PERL5LIB="/Users/${USER}/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/${USER}/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/${USER}/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/${USER}/perl5"; export PERL_MM_OPT;

if grep zinit <<< $FPATH &> /dev/null
then
  [[ -d ~/.zinit/plugins/zsh-interactive-cd ]] && zinit load zsh-interactive-cd 
  [[ -d ~/.zinit/plugins/fzf ]] && zinit load fzf

  # [[ -d ~/.zinit/plugins//fzf-z ]] && zinit load fzf-z
  # [[ -d ~/.zinit/plugins/z ]] && zinit load z
  
#  zinit load zsh-autosuggestions
  bindkey "ç" fzf-cd-widget
  cellarfzf="/usr/local/Cellar/fzf"

  if [[ -d ${cellarfzf} ]]; then
      dirfzf=`ls -Ft ${cellarfzf} | egrep "/$" | head -1`
      [[ /usr/local/Cellar/fzf/${dirfzf}shell/key-bindings.zsh ]] && source /usr/local/Cellar/fzf/${dirfzf}shell/key-bindings.zsh
  fi
  [[ -e /etc/zsh_completion.d/fzf-key-bindings ]] && source /etc/zsh_completion.d/fzf-key-bindings

  export FZF_COMPLETION_TRIGGER='**'
  export FZF_DEFAULT_OPTS="
 --layout=reverse
 --info=inline
 --height=40%
 --multi
 --color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'
 --prompt='∼ --marker='✓'
 "
  if [[ -e /usr/local/bin/fd || -e /usr/bin/fd ]]; then
    export FZF_DEFAULT_COMMAND="fd --hidden --follow --exclude '.git'"
  fi
  # CTRL-T's command
  #export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  # ALT-C's command
  export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"
  export _ZL_HYPHEN=1
  # Ctrl-R command preview ? toggles
  export FZF_CTRL_R_OPTS="--preview --sort 'echo {}' --preview-window down:3%:wrap "
  export FZF_CTRL_R_OPTS="--tac --tiebreak=index --info=inline"
  if [[ -e ~/.zinit/plugins/zsh-histdb/sqlite-history.zsh ]]; then
    source ~/.zinit/plugins/zsh-histdb/sqlite-history.zsh
    autoload -Uz add-zsh-hook
    #add-zsh-hook precmd histdb-update-outcome
    source ~/.zinit/plugins/zsh-histdb/histdb-interactive.zsh
#    bindkey '^r' _histdb-isearch
    bindkey -M histdb-isearch '^[e' _histdb-isearch-toggle-errors
  fi

  [[ -e "${HOME}/myinits/kubectl_completion" ]] && source "${HOME}/myinits/kubectl_completion"

fi

zshaddhistory() { whence ${${(z)1}[1]} >| /dev/null || return 1 }

# find-in-file - usage: fif <SEARCH_TERM>
fif() {
  if [ ! "$#" -gt 0 ]; then
    echo "Need a string to search for!";
    return 1;
  fi
  if [[ -e /usr/local/bin/rg || -e /usr/bin/rg ]]; then
    rg --files-with-matches --no-messages "$1" | fzf $FZF_PREVIEW_WINDOW --preview "rg --ignore-case --pretty --context 10 '$1' {}"
  else
    grep --ignore-case -l $1 | fzf $FZF_PREVIEW_WINDOW 
  fi
}

fzf-history-widget () {

if grep zinit <<< $FPATH &> /dev/null
then
	local selected num
	setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
	#selected=($(fc -rl 1 | perl -ne 'print if !$seen{($_ =~ s/^\s*[0-9]+\s+//r)}++' | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=end --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" $(__fzfcmd)))
  selected=($(fc -l 1 | perl -ne 'print if !$seen{($_ =~ s/^\s*[0-9]+\s+//r)}++' | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" $(__fzfcmd)))
  #selected=_myhistdb_isearch_query
  #selected=( $(echo ${selected} | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" $(__fzfcmd)))
  local ret=$?
	if [ -n "$selected" ]
	then
		num=$selected[1]
		if [ -n "$num" ]
		then
			zle vi-fetch-history -n $num
		fi
	fi
	zle reset-prompt
	return $ret
fi

}

_histdb-mysearch () {

  local old_buffer=${BUFFER}
  local old_cursor=${CURSOR}
	local selected num commandid
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null

  local new_query="$BUFFER $HISTDB_ISEARCH_THIS_HOST $HISTDB_ISEARCH_THIS_DIR"
  if [[ $new_query == $HISTDB_ISEARCH_LAST_QUERY ]] && [[ $HISTDB_ISEARCH_N == $HISTDB_ISEARCH_LAST_N ]]; then
      return
  elif [[ $new_query != $HISTDB_ISEARCH_LAST_QUERY ]]; then
      HISTDB_ISEARCH_N=0
  fi

  HISTDB_ISEARCH_LAST_QUERY=$new_query
  HISTDB_ISEARCH_LAST_N=HISTDB_ISEARCH_N


  local maxmin="min"
  local ascdesc="asc"

  if [[ $HISTDB_ISEARCH_THIS_DIR == 1 ]]; then
      local where_dir="and places.dir like '$(sql_escape $PWD)%'"
  else
      local where_dir=""
  fi

  if [[ $HISTDB_ISEARCH_THIS_HOST == 1 ]]; then
      local where_host="and places.host = '$(sql_escape $HOST)'"
  else
      local where_host=""
  fi

  if [[ $HISTDB_ISEARCH_THIS_HOST == 1 ]]; then
      local where_host="and places.host = '$(sql_escape $HOST)'"
  else
      local where_host=""
  fi

  #if [[ -v $HISTDB_ISEARCH_INCLUDE_ERRORS ]]; then
  #    local where_error=""
  #else
  #    local where_error="and history.exit_status = 0"
  #fi
  local where_error=""

  local query="select 
commands.argv,
commands.id,
places.dir,
places.host,
datetime(max(history.start_time), 'unixepoch', 'localtime')
from history left join commands
on history.command_id = commands.rowid
left join places
on history.place_id = places.rowid
where commands.argv glob '*$(sql_escape ${BUFFER})*'
${where_host}
${where_dir}
${where_error}
group by commands.argv, places.dir, places.host
order by ${maxmin}(history.start_time) ${ascdesc}"
  local result=$(_histdb_query -separator $'::' "$query")
  selected=($( echo ${result} | awk -F:: '{print $2" "$1}' | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" $(__fzfcmd)))
  local ret=$?
	if [ -n "$selected" ]
	then
		num=${selected[1]}
		if [ -n "$num" ]
		then
      local query="select argv from commands where id=${num}"
      BUFFER=$(_histdb_query -separator $'\n' "$query")
      zle vi-end-of-line
		fi
	fi
	zle reset-prompt
	return $ret
  
}

zle -N _histdb-mysearch _histdb-mysearch

_histdb-isearch-toggle-errors () {
    if [[ $HISTDB_ISEARCH_INCLUDE_ERRORS == 1 ]]; then
        HISTDB_ISEARCH_INCLUDE_ERRORS=0
    else
        HISTDB_ISEARCH_INCLUDE_ERRORS=1
    fi
}
