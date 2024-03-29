
report="${HOME}/tmp/report"
/bin/ls --help > /dev/null 2>&1
if [[ $? -eq 0 ]] ;  then
  export JOEBLOW="gnu ls at /bin/ls"
  if zstyle -t ':prezto:module:utility:ls' color; then
    [[ -s "$HOME/.dir_colors" ]] && eval "$(dircolors --sh "$HOME/.dir_colors")" || eval "$(dircolors --sh)"
    alias ls="${aliases[ls]:-ls} --color=auto"
  else
    alias ls="${aliases[ls]:-ls} -F"
  fi
elif [[ -x /usr/local/bin/gls ]]; then
  export JOEBLOW="usign /usr/local/bin/gls"
  alias ls='/usr/local/bin/gls'
  if zstyle -t ':prezto:module:utility:ls' color; then
    [[ -s "$HOME/.dir_colors" ]] && eval "$(gdircolors --sh "$HOME/.dir_colors")" || eval "$(gdircolors --sh)"
    alias ls="${aliases[ls]:-ls} --color=auto"
  else
    alias ls="${aliases[ls]:-ls} -F"
  fi
else
  # BSD Core Utilities
  if zstyle -t ':prezto:module:utility:ls' color; then
    export JOEBLOW="joejoe"
    # Define colors for BSD ls.
    #export LSCOLORS='exfxcxdxbxGxDxabagacad'
    export LSCOLORS='bxfxcxdxbxGxDxabagacad'

    # Define colors for the completion system.
    export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'

    alias ls="${aliases[ls]:-ls} -G"
  else
    alias ls="${aliases[ls]:-ls} -F"
  fi
fi

if [[ ! ${aliases[ls]} = *"--color=auto"* ]]; then 
    alias ls="${aliases[ls]:-ls} --color=auto"
fi
if [[ ! ${aliases[ls]} = *" -F"* ]]; then 
    alias ls="${aliases[ls]:-ls} -F"
fi
alias lsd="${aliases[ls]:-ls} --group-directories-first"
alias k="kubectl"
alias dv="dirs -v"
alias zz="z -c" # matches directories only under $PWD
alias zi="z -I"  # use fzf to select in multiple matches
alias -g C='| wc -l'
alias -g EG='|& egrep'
alias -g EL='|& less'
alias -g ETL='|& tail -20'
alias -g ET='|& tail'
alias -g G='| egrep'
alias -g NS='| sort -n'
alias -g NUL="> /dev/null 2>&1"
alias -g S='| sort'
alias -g TL='| tail -20'
alias -g T='| tail'
alias -g TF='| tail -f'
alias -g US='| sort -u'
alias -g X='| xargs'
alias -g LL="2>&1 | less"
