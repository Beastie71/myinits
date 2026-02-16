#
# Defines environment variables.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Ensure that a non-login, non-interactive shell has a defined environment.
#

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
if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi
