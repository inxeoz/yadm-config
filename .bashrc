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



# Detect Wayland/Niri vs Xorg/Startx

if [ "$XDG_CURRENT_DESKTOP" = "niri" ] || [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    # Niri session
    if [ -f ~/.bashrc_niri ]; then
        source ~/.bashrc_niri
    fi

elif [ "$XDG_SESSION_TYPE" = "x11" ]; then
    # Startx / Xorg session
    if [ -f ~/.bashrc_x ]; then
        source ~/.bashrc_x
    fi
fi

