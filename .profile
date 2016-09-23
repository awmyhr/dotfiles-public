#!/bin/bash
# My personalized .profile, based on tons of things I've found/learned
#
# 20160908 NOTE: May have broken compatibility w/non-bash/zsh shells
#

###############################################################################
### If this is not an interactive shell, exit here
[[ $- = *i* ]] || return
###############################################################################
### Set some configurations
export PD="$HOME/.profile.d"
# Prefered datstamp format. A good ISO date stamp is +%Y%m%d-%H%M
export DEFAULT_TIMESTAMP='+%Y%m%d-%H%M%S'
# Set this to perfered version control system current possible values: git svn 
export DEFAULT_VCS="git"
# Set this to false to ignore untracked files, which can speed up repo checks
export VCS_IGNORE_UNTRACKED_FILES="false"
# Set this to false to ignore submodule files, which can speed up repo checks
export VCS_IGNORE_SUBMODULES="true"
# File extensions to ignore when doing name completion
export FIGNORE='~':'.o':'.bak':'.tmp'
# Some history-related settings
export HISTSIZE=500
export HISTFILESIZE=5000
export SAVEHIST=${HISTFILESIZE}
export HISTCONTROL=ignoreboth
# This is specifically for 'hh' (installed via package 'hrst')
export HH_CONFIG=hicolor
# Set autojump completion for commands
export AUTOJUMP_AUTOCOMPLETE_CMDS='cp vim'
# Set .config directory for XDG
export XDG_CONFIG_HOME="$HOME/.config"
# Set this to perfered version control system
# current possible values: git svn 
export VCS="git"

###############################################################################
### Set up PATH

if [[ -r "${PD}/profile.paths" ]]; then
    while read line 
    do
        if [[ -d $line ]]; then
            PATH=$PATH':'$line
        fi
    done <"$PD/profile.paths"
fi
unset line

export PATH

###############################################################################
### Set up helper variables
UNAMES=$(uname -s)
UNAMER=$(uname -r)
PLATFORM=$(uname -p)
HOSTNAME=$(uname -n)
export UNAMES UNAMER PLATFORM HOSTNAME

# Set up the shell variables:
RSYNC_RSH=ssh
SYSTEM=$(hostname)

NVIM=$(which nvim 2>/dev/null)
VIM=$(which vim 2>/dev/null)
SUBL=$(which sublime_text 2>/dev/null || which subl 2>/dev/null)
if [[ -x $SUBL ]]; then
    EDITOR="$SUBL -w "
    VISUAL=$SUBL
    alias st="$SUBL"
    alias vi="$VIM"
elif [[ -x $NVIM ]]; then
    EDITOR=$NVIM
    VISUAL=$NVIM
    alias vi="$NVIM"
elif [[ -x $VIM ]]; then
	EDITOR=$VIM
	VISUAL=$VIM
	alias vi="$VIM"
else
	EDITOR=vi
	VISUAL=vi
fi

if [[ -x $(which less 2>/dev/null) ]]; then
    PAGER='less -FIMRSw -z-2'
    LESS='-FIMRSw -z-2'
elif [[ -x $(which more 2>/dev/null) ]]; then
    PAGER="more -s"
fi

export EDITOR VISUAL PAGER LESS RSYNC_RSH SYSTEM
###############################################################################
### MANPATH ###
if [[ -e "${PD}/profile.manpaths" ]]; then
    MANPATH=''
    while read line 
    do
        if [[ -d $line ]]; then
            PATH=$PATH':'$line
        fi
    done <"$PD/profile.manpaths"
fi

[[ -d $HOME'/man' ]] && MANPATH=$MANPATH':'$HOME'/man'

export MANPATH

###############################################################################
### color TERM settings
if [[ "$COLORTERM" == gnome-* && "$TERM" == xterm* ]] && /usr/bin/infocmp gnome-256color >/dev/null 2>&1; then
    if [[ -x /usr/bin/dircolors ]]; then
        if [[ -r "$HOME/.dirColors/dircolors.256dark" ]]; then
            eval $(dircolors -b "$HOME/.dirColors/dircolors.256dark")
        elif [[ -r "$HOME/.dirColors" ]]; then
            eval $(dircolors -b "$HOME/.dirColors")
        else
            eval $(dircolors -b)
        fi

        LS_OPTS="--color=auto" && export LS_OPTS
    fi
    c_bold=$(tput bold)
    c_norm=$(tput sgr0)
    c_undr=$(tput smul)
    c_hide=$(tput invis)
    c_blik=$(tput blink)
    c_revr=$(tput smso)
    if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
        c_BASE03=$(tput setaf 234)
        c_BASE02=$(tput setaf 235)
        c_BASE01=$(tput setaf 240)
        c_BASE00=$(tput setaf 241)
        c_BASE0=$(tput setaf 244)
        c_BASE1=$(tput setaf 245)
        c_BASE2=$(tput setaf 254)
        c_BASE3=$(tput setaf 230)
        c_blue=$(tput setaf 33)
        c_cyan=$(tput setaf 37)
        c_green=$(tput setaf 64)
        c_magenta=$(tput setaf 125)
        c_orange=$(tput setaf 166)
        c_purple=$(tput setaf 61)
        c_red=$(tput setaf 160)
        c_yellow=$(tput setaf 136)
    else
        c_BASE03=$(tput setaf 8)
        c_BASE02=$(tput setaf 0)
        c_BASE01=$(tput setaf 10)
        c_BASE00=$(tput setaf 11)
        c_BASE0=$(tput setaf 12)
        c_BASE1=$(tput setaf 14)
        c_BASE2=$(tput setaf 7)
        c_BASE3=$(tput setaf 15)
        c_blue=$(tput setaf 4)
        c_cyan=$(tput setaf 6)
        c_green=$(tput setaf 2)
        c_magenta=$(tput setaf 5)
        c_orange=$(tput setaf 9)
        c_purple=$(tput setaf 13)
        c_red=$(tput setaf 1)
        c_yellow=$(tput setaf 3)
    fi
elif [[ "$TERM" == linux ]]; then
    c_bold=$(tput bold)
    c_norm=$(tput sgr0)
    c_undr=$(tput smul)
    c_hide=$(tput invis)
    c_blik=$(tput blink)
    c_revr=$(tput smso)
    c_BASE03=$(tput setaf 8)
    c_BASE02=$(tput setaf 0)
    c_BASE01=$(tput setaf 10)
    c_BASE00=$(tput setaf 11)
    c_BASE0=$(tput setaf 12)
    c_BASE1=$(tput setaf 14)
    c_BASE2=$(tput setaf 7)
    c_BASE3=$(tput setaf 15)
    c_orange=$(tput setaf 9)
    c_magenta=$(tput setaf 5)
    c_yellow=$(tput setaf 3)
    c_red=$(tput setaf 1)
    c_purple=$(tput setaf 13)
    c_blue=$(tput setaf 4)
    c_cyan=$(tput setaf 6)
    c_green=$(tput setaf 2)
else
    tset -Q -e "${ERASE:-\^h}" "$TERM"
    [[ $UNAMES = "SCO_SV" ]] && TERM=xterm
    [[ -x $(which tset) ]] && eval `tset -s -Q`
    # ANSI escapes for 8 color
    c_norm='\e[0m'
    c_bold='\e[1m'
    c_undr='\e[4m'
    c_blik='\e[5m'
    c_revr='\e[7m'
    c_hide='\e[8m'
    c_BASE03='\e[30m'
    c_BASE02='\e[34m'
    c_BASE01='\e[37m'
    c_BASE00='\e[37m'
    c_BASE0='\e[36m'
    c_BASE1='\e[34m'
    c_BASE2='\e[37m'
    c_BASE3='\e[37m'
    c_blue='\e[34m'
    c_cyan='\e[36m'
    c_green='\e[32m'
    c_magenta='\e[35m'
    c_purple='\e[35m'
    c_orange='\e[33m'
    c_red='\e[31m'
    c_yellow='\e[33m'
fi

c_white="${c_BASE3}"
c_black="${c_BASE03}"

#export all the colors
export c_BASE03 c_BASE02  c_BASE01 c_BASE00
export c_BASE0  c_BASE1   c_BASE2  c_BASE3
export c_orange c_magenta c_yellow c_red
export c_purple c_blue    c_cyan   c_green
export c_white  c_black   c_bold   c_norm
export c_undr   c_hide    c_blik   c_revr

# Combos for various alert based on kernel alert levels
export c_EMERG="${c_bold}${c_magenta}"
export c_ALERT="${c_bold}${c_red}"
export c_CRIT="${c_red}"
export c_ERR="${c_bold}${c_yellow}"
export c_WARNING="${c_yellow}"
export c_NOTICE="${c_white}"
export c_INFO="${c_green}"
export c_DEBUG="${c_blue}"

###############################################################################
### load general aliases
[[ -r "${PD}/alias.general" ]] && source "${PD}/alias.general"
#   load default VCS aliases
[[ -r "${PD}/alias.${DEFAULT_VCS}" && -x $(which $DEFAULT_VCS 2>/dev/null) ]] && source "${PD}/alias.${DEFAULT_VCS}"
#   load platform aliases
[[ -r "${PD}/alias.${UNAMES}" ]] && source "${PD}/alias.${UNAMES}"

###############################################################################
### platform-specific stuff goes in these files.
[[ -r "${PD}/profile.${UNAMES}" ]] && source "${PD}/profile.${UNAMES}"

#This will most likely only execute on Mac OS X systems w/Fink
#  but it's here like this in case I emulate the system elsewhere
[[ -x /sw/bin/init.sh ]] && source /sw/bin/init.sh

###############################################################################
### Load functions
[[ -r "${PD}/functions" ]] && source "${PD}/functions"

###############################################################################
### Set up the shell environment
umask 022
trap "echo 'logout'" 0
# removed '-o nounset' as it caused problems w/bash autocomplete
set -o noclobber -o vi -o notify

###############################################################################
### Shell dependent settings
case "$SHELL" in
    *zsh* )
        SHELLSTRING="$SHELL ($ZSH_VERSION)"
        ;;

    *bash* )
        SHELLSTRING="$SHELL ($BASH_VERSION)"
        ;;

    *ksh* )
        SHELLSTRING="$SHELL ($KSH_VERSION)"
        export PS1='$c_bold$USER@$HOSTNAME ($UNAMES): $c_norm $PWD
! $ '
        ;;
    *csh )
        # Set a simple prompt
        SHELLSTRING="$shell"
        export PS1='$USER@$HOSTNAME $ '
        ;;
    *sh )
        # Set a simple prompt
        SHELLSTRING="$SHELL"
        export PS1='$USER@$HOSTNAME $ '
        ;;
    * )
        # Sorry, unknown shell??
        SHELLSTRING="UNKNOWN"

        export PS1='$ '
        ;;
esac

###############################################################################
# FWIW:
# tcsh   - $version  - set to tcsh version number (also: set prompt='%n@%m %~ ')
# bash   - $BASH     - set to bash path
# [t]csh - $shell    - set to 'csh' or 'tcsh'
# zsh    - $ZSH_NAME - set to 'zsh'
# ksh has $PS3 & $PS4 set (normal Bourne shell (sh) only has $PS1 & $PS2 set).
#   This generally seems like the hardest to distinguish - the ONLY difference
#   in entire set of envionmental variables between sh and ksh installed on
#   Solaris: $ERRNO, $FCEDIT, $LINENO, $PPID, $PS3, $PS4, $RANDOM, $SECONDS, $TMOUT
###############################################################################

type whereis >/dev/null 2>&1 || {
	alias whereis='type -all'
}

###############################################################################
### Display some useful information
echo -e "${c_white}You're logged into ${c_bold}$SYSTEM${c_norm}${c_white} in a(n) ${c_bold}$TERM${c_norm}${c_white} terminal with:${c_norm}
    ${c_white}${c_bold}System:${c_norm} ${c_purple}${UNAMES} (${UNAMER})${c_norm}
    ${c_white}${c_bold}Shell:${c_norm}  ${c_purple}${SHELLSTRING}${c_norm}
    ${c_white}${c_bold}Pager:${c_norm}  ${c_purple}${PAGER}${c_norm}
    ${c_white}${c_bold}Editor:${c_norm} ${c_purple}${EDITOR}${c_norm}
    ${c_white}${c_bold}VCS:${c_norm}    ${c_purple}${DEFAULT_VCS}${c_norm}"

# Print the Discordian date.
if [[ -x $(which ddate 2>/dev/null) ]]; then
    echo -e "${c_cyan}$(ddate +'Today is %{%A, the %e of %B%}, %Y YOLD. %N%nCelebrate %H')${c_norm}"
fi

# Print a random, hopefully interesting, adage.
if [[ -x $(which fortune 2>/dev/null) ]]; then
    echo -e "${c_purple}$(fortune -s)${c_norm}"
fi

