# ~/.bashrc  -- optimized for speed
# return early if non-interactive
[[ $- != *i* ]] && return

#######################################
# Minimal / fast helpers & PATH
#######################################



mark() { mkdir -p ~/.marks; ln -snf "$(pwd)" ~/.marks/"$1"; }
goto() { cd -P "$(readlink ~/.marks/"$1")" || echo "No mark: $1"; }



# Safe prepend-path: only add if missing
prepend_path() {
  case ":$PATH:" in
    *":$1:"*) ;;            # already present
    *) PATH="$1:$PATH" ;;
  esac
}


prepend_path "$HOME/.local/bin"
prepend_path "$HOME/.cargo/bin"
prepend_path "$HOME/.npm-global/bin"
prepend_path "$HOME/.nvm"                 # keep variable, but lazy load nvm
prepend_path "$HOME/.bun/bin"
prepend_path "$HOME/.local/share/gem/ruby/3.4.0/bin"

# DENO
: "${DENO_INSTALL:=$HOME/.deno}"
prepend_path "$DENO_INSTALL/bin"

export PATH
export DENO_INSTALL
export NVM_DIR="$HOME/.nvm"

export LS_COLORS="di=37:*di=*/"
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

#######################################
# Aliases (simple, no subshells)
#######################################
alias '..'='cd ..'
alias ls='ls --color=auto --classify'
alias grep='grep --color=auto'
alias cdc='cd ~/coding'
alias cdd='cd ~/Downloads'
alias cdt='cd ~/Temp'
alias c='clear'
alias ui='xprop | grep WM_CLASS'
alias bat="bat --paging=never --style=plain --theme='OneHalfDark'"
alias top10='ps aux --sort=-%mem | head -n 10'
alias myip='curl ifconfig.me'
alias cls='clear; ls'
alias reload='source ~/.bashrc'
alias update='sudo pacman -Syuu'
alias fuck='sudo $(history -p !!)' 

alias vf='vim $(fzf)'
alias cf='code $(fzf)'
alias zf='zed $(fzf)'
alias hf='helix $(fzf)'

alias gitd='git diff -- "$(git status --porcelain | fzf | cut -c4-)"' 
alias gitds='git diff --staged "$(git status --porcelain | fzf | cut -c4-)"' 
#alias btop="btop --utf-force"  # uncomment if used

alias meminfo='free -h'
alias cpuinfo='lscpu'
alias diskusage='df -h'
alias processes='ps aux --sort=-%cpu | head -20'
alias netstat='ss -tuln'
alias temps='sensors 2>/dev/null || echo "Install lm-sensors for temperature monitoring"'
alias syslog='journalctl -f'
alias startx0='startx /usr/bin/i3 -- :0'
alias startx1='startx /usr/bin/i3 -- :1'
alias startx2='startx /usr/bin/i3 -- :2'
alias startx3='startx /usr/bin/i3 -- :3'
#######################################
# Functions (lightweight)
# Safe wrappers for VS Code / Zed
code_safe() {
  if [[ "$1" == "/" || "$1" == "/root" ]]; then
    echo "❌ Refusing to open $1 in VS Code."
  else
     command code "$@"
  fi
}
alias code=code_safe

zed_safe() {
  if [[ "$1" == "/" || "$1" == "/root" ]]; then
    echo "❌ Refusing to open $1 in Zed."
  else
    command zed "$@"
  fi
}
alias zed=zed_safe

#######################################
# Prompt: avoid subshells, use escapes
# \u = user, \h = host, \w = cwd, \@ = 12-hour time w/ am/pm
#######################################
PS1=$'\n[\u@manjaro-i3 | \[\e[33m\]\w\[\e[0m\] | \@]\$ '

#######################################
# Lazy-load heavy things (nvm, bash_completion)
#######################################

# Lazy nvm: only source nvm when user runs "nvm" or "node" or "npm"
__load_nvm() {
  # only source if script exists
  if [ -s "$NVM_DIR/nvm.sh" ]; then
    # shellcheck source=/dev/null
    . "$NVM_DIR/nvm.sh"
    unset -f __load_nvm __nvm_proxy
  fi
}
# proxy function that triggers load on first use
__nvm_proxy() {
  unset -f nvm node npm npx
  __load_nvm
  # after loading, call the requested command
  if command -v nvm >/dev/null 2>&1 && [ "$1" = "nvm" ]; then
    nvm "${@:2}"
  else
    # delegate to node/npm/npx if requested
    command "$@"
  fi
}
# define lightweight proxies
nvm() { __nvm_proxy nvm "$@"; }
node() { __nvm_proxy node "$@"; }
npm() { __nvm_proxy npm "$@"; }
npx() { __nvm_proxy npx "$@"; }


extract() {
  case "$1" in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz)  tar xzf "$1" ;;
    *.bz2)     bunzip2 "$1" ;;
    *.rar)     unrar x "$1" ;;
    *.gz)      gunzip "$1" ;;
    *.tar)     tar xf "$1" ;;
    *.tbz2)    tar xjf "$1" ;;
    *.tgz)     tar xzf "$1" ;;
    *.zip)     unzip "$1" ;;
    *.Z)       uncompress "$1" ;;
    *.7z)      7z x "$1" ;;
    *)         echo "'$1' cannot be extracted" ;;
  esac
}



# End of fast ~/.bashrc
