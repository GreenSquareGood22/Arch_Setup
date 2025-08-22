#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# ============================================================================
# HISTORY CONFIGURATION
# ============================================================================

# Don't put duplicate lines or lines starting with space in the history
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it
shopt -s histappend

# Set history length
HISTSIZE=10000
HISTFILESIZE=20000

# Add timestamp to history
HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "

# ============================================================================
# SHELL OPTIONS
# ============================================================================

# Check the window size after each command and update LINES and COLUMNS
shopt -s checkwinsize

# Enable recursive globbing with **
shopt -s globstar

# Correct minor errors in directory names during cd
shopt -s cdspell

# Autocorrect typos in path names during completion
shopt -s dirspell

# Case-insensitive pathname expansion
shopt -s nocaseglob

# ============================================================================
# PROMPT CONFIGURATION
# ============================================================================

# Set a colorful prompt with git branch info
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Color definitions
RED='\[\033[0;31m\]'
GREEN='\[\033[0;32m\]'
YELLOW='\[\033[1;33m\]'
BLUE='\[\033[0;34m\]'
PURPLE='\[\033[0;35m\]'
CYAN='\[\033[0;36m\]'
WHITE='\[\033[1;37m\]'
NC='\[\033[0m\]' # No Color

# Set prompt
if [ "$EUID" -eq 0 ]; then
    # Root prompt (red)
    PS1="${RED}\u@\h${NC}:${BLUE}\w${NC}${YELLOW}\$(parse_git_branch)${NC}# "
else
    # Regular user prompt (green)
    PS1="${GREEN}\u@\h${NC}:${BLUE}\w${NC}${YELLOW}\$(parse_git_branch)${NC}$ "
fi

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================

# Set default editor
export EDITOR=vim
export VISUAL=vim

# Set default pager
export PAGER=less

# Less options
export LESS='-R -i -M -S -x4'

# Colored man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# ============================================================================
# PATH CONFIGURATION
# ============================================================================

# Add local bin directories to PATH if they exist
for dir in "$HOME/.local/bin" "$HOME/bin"; do
    if [ -d "$dir" ] && [[ ":$PATH:" != *":$dir:"* ]]; then
        PATH="$dir:$PATH"
    fi
done

# ============================================================================
# ALIASES
# ============================================================================

# Enable color support for ls and grep
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lt='ls -alFtr'  # Sort by time, newest last
alias lh='ls -alFh'   # Human readable sizes

# Navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# Safety aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'

# Utility aliases
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias mkdir='mkdir -pv'
alias wget='wget -c'
alias curl='curl -L'
alias ping='ping -c 5'
alias ports='netstat -tulanp'

# Process management
alias ps='ps auxf'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias myps='ps -f -u $USER'

# Git aliases (if git is installed)
if command -v git &> /dev/null; then
    alias gs='git status'
    alias ga='git add'
    alias gc='git commit'
    alias gp='git push'
    alias gl='git log --oneline'
    alias gd='git diff'
    alias gb='git branch'
    alias gco='git checkout'
fi

# System information
alias sysinfo='uname -a && lsb_release -a 2>/dev/null'
alias meminfo='free -h && echo && cat /proc/meminfo | head -5'
alias cpuinfo='lscpu'

# ============================================================================
# FUNCTIONS
# ============================================================================

# Extract various archive formats
extract() {
    if [ -f "$1" ]; then
        case $1 in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Find files by name
ff() {
    find . -type f -name "*$1*" 2>/dev/null
}

# Find directories by name
fd() {
    find . -type d -name "*$1*" 2>/dev/null
}

# Quick backup function
backup() {
    cp "$1"{,.bak}
}

# ============================================================================
# COMPLETION ENHANCEMENTS
# ============================================================================

# Enable programmable completion features
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# ============================================================================
# SECURITY AND PERFORMANCE
# ============================================================================

# Set umask for better default permissions
umask 022

# Limit core dump size
ulimit -c 0

# Set maximum number of open file descriptors
ulimit -n 4096

# ============================================================================
# FINAL SETUP
# ============================================================================

# Welcome message (comment out if not desired)
echo "Welcome back, $USER! Today is $(date '+%A, %B %d, %Y at %I:%M %p')"
