#
# Executes commands at login pre-zshrc.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

#
# Browser
#

if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

#
# Editors
#

export EDITOR='nano'
export VISUAL='nano'
export PAGER='less'

#
# Language
#

if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

#
# Paths
#

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the the list of directories that cd searches.
# cdpath=(
#   $cdpath
# )

# Set the list of directories that Zsh searches for programs.
path=(
  /usr/local/{bin,sbin,go/bin}
   "${HOME}/.rd/bin"          # Rancher Desktop
   "/opt/homebrew/bin"        # Homebrew (adjust if your path is different e.g. /usr/local/bin for older macOS or Linux)
   "${HOME}/.cargo/bin"       # Rust/Cargo
  $path
)

#
# Less
#

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

#
# Temporary Files
#

USER=`echo $USERNAME`
if [[ ! -d "$TMPDIR" ]]; then
  export TMPDIR="/tmp/$LOGNAME"
  mkdir -p -m 700 "$TMPDIR"
fi

TMPPREFIX="${TMPDIR%/}/zsh"
if [[ -e "${HOME}/Documents/workspace/go" ]]; then
  GOPATH=$GOPATH:"${HOME}/Documents/workspace/go"
  GOBIN=${GOBIN}:"${HOME}/Documents/workspace/go/bin"
elif [[ -e "$HOME/go" ]]; then
  GOPATH=${HOME}/go
  GOBIN=${HOME}/go/bin
fi
if [[ -e "${HOME}/Documents/workspace/class" ]]; then
  GOPATH=$GOPATH:"${HOME}/Documents/workspace/class"
  GOBIN=${GOBIN}:"${HOME}/Documents/workspace/class/bin"
fi

export PROFILING_MODE=0
export DOKUBE=0 # Set to 1 to enable Kubernetes tools/completions

if [[ -f ${HOME}/myinits/API ]]; then
  export HOMEBREW_GITHUB_API_TOKEN=$(< "${HOME}/myinits/API")
fi

