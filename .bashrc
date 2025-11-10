# ~/.bashrc -- optimized loader

# Return early if non-interactive
[[ $- != *i* ]] && return

# Load core fast configuration
if [ -f "$HOME/.bashrc-core" ]; then
  source "$HOME/.bashrc-core"
fi

# Load optional extras (if present)
if [ -f "$HOME/.bashrc-extra" ]; then
  source "$HOME/.bashrc-extra"
fi




# Load optional export (if present)
if [ -f "$HOME/.bashrc-export" ]; then
  source "$HOME/.bashrc-export"
fi
