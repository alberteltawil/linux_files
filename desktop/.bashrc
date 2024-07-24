# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# ========================================================================
# CUSTOM FUNCTIONS
# ========================================================================

export EDITOR=mousepad

function custom_split_url() {
    printf "\n"
    printf "Splitting URL into query string param=value and URL decoding all values. Here are the results:"
    printf "\n\n"

    # Function to URL decode a string
    urldecode() {
        local url_encoded="${1//+/ }"
        printf '%b' "${url_encoded//%/\\x}"
    }

    # Function to add color to parameter names and subparameter names
    add_color() {
        local color_param="\033[0;33m"      # Yellow color for parameter names
        local color_subparam="\033[0;36m"   # Blue color for subparameter names
        local reset="\033[0m"               # Reset color

        if [[ $2 == "subparam" ]]; then
            printf "${color_subparam}%s${reset}" "$1"
        else
            printf "${color_param}%s${reset}" "$1"
        fi
    }

    # Input URL
    input_url="$1"

    # Extract parameters after "?" and decode them
    params=$(awk -F'[?&]' '{for(i=2;i<=NF;i++) {split($i, a, "="); printf("%s=%s\n", a[1], a[2])}}' <<< "$input_url")

    # Decode each parameter and print in a table format
    while read -r line; do
        param_name=$(cut -d'=' -f1 <<< "$line")
        param_value=$(cut -d'=' -f2- <<< "$line")
        
        # Split parameter value by commas and then decode individual values
        IFS=',' read -r -a values <<< "$(urldecode "$param_value")"
        for value in "${values[@]}"; do
            decoded_value=$(urldecode "$value")
            
            # Split subvalues by '&' sign and output each on a new line
            IFS='&' read -r -a subvalues <<< "$decoded_value"
            for subvalue in "${subvalues[@]}"; do
                IFS='=' read -r subparam_name subparam_value <<< "$subvalue"
                if [[ $subvalue == *"="* ]]; then
                    printf "%-35s %-35s\n" "$(add_color "$param_name" "param")" "$(add_color "$subparam_name" "subparam")=$subparam_value"
                else
                    printf "%-35s %-35s\n" "$(add_color "$param_name" "param")" "$subvalue"
                fi
            done
        done
    done <<< "$params"

    printf "\n"
}
