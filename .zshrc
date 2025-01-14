# Forest Katsch's zshrc
# Last updated 2024-06-22

PLATFORM="unknown"

if [ $(uname) = "Linux" ]; then
    PLATFORM="linux"
elif [ $(uname) = "FreeBSD" ]; then
    PLATFORM="bsd"
fi

# Convenient function to mkdir and cd into a given directory
function take() {
    mkdir -p "$1" && cd "$1"
}

# btw i use emacs
export EDITOR=$(which emacs)

# Use colors with LS.
if [ "$PLATFORM" = "linux" ]; then
    alias ls='ls --color=auto'
elif [ "$PLATFORM" = "bsd" ]; then
    alias ls='ls -G'
fi

# Preferred setup is to `ln -s $(which emacs) /usr/local/bin/em` so it works with root too.
# But this is a nice fallback, and still works after doing the above.
alias em='emacs'

# user @ host ~ $
# red    green gray normal
PROMPT=$'%F{red}%n%f @ %F{green}%m%f %{\e[38;5;241m%}%~ %f# '

# Change the username color to blue if you aren't root.
if [ "$EUID" -ne 0 ]; then
    PROMPT=$'%F{blue}%n%f @ %F{green}%m%f %{\e[38;5;241m%}%~ %f$ '
fi

# sToRaGe iS cHeAp
HISTFILE=~/.histfile
export HISTSIZE=1000000000
export SAVEHIST=$HISTSIZE

# Honestly I forget what this does. But I didn't add it for no reason, so it stays.
setopt EXTENDED_HISTORY

# Ignore duplicates. Makes it easier to skip past `ls` and `cd`.
setopt HIST_IGNORE_ALL_DUPS

# NO F*CKING BEEPING IN MY HOUSE.
unsetopt beep
bindkey -e

# Uh, this seems to work for me. YMMV. Feel free to replace with a stub function.
func set_title() {
    echo -ne "\e]1;${1}\a"
}

# emacs /Users/forest/.ssh/config
preexec() {
    set_title "$1 `dirs`"
}

# /Users/forest/.ssh/config
precmd() {
    set_title "`dirs`"
}

alias dotfiles='/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'

alias open="xdg-open"

export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket
