#!/usr/bin/sh
#===============================================================================
#
#         FILE: .profile
#
#        USAGE: (automagically loaded by shell)
#
#  DESCRIPTION: My personalized shell profile, based on tons of things I've
#               found/learned over the years.
#
#      OPTIONS: ---
# REQUIREMENTS: POSIX compatible shell
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: awmyhr, awmyhr@gmail.com
#      VERSION: 3.0.0
#      CREATED: ????-??-??
#     REVISION: 2016-09-28
#===============================================================================
#----------------------------------------------------------------------
#-- Notes/known bugs/other issues
#       20160908 May have broken compatibility w/non-bash/zsh shells
#----------------------------------------------------------------------

#----------------------------------------------------------------------
#  Set sane path, check for debug, and exit if not an interactive shell
#----------------------------------------------------------------------
export PATH='/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin'
[ "${TRACE}" ]  && set -x    # Run in debug mode if called for
[ -z "${PS1}" ] || return    # Exit if not an interactive shell

#----------------------------------------------------------------------
#-- "Baby, baby, baby, let's do it interactive"
#----------------------------------------------------------------------
export PROFILED="${HOME}/.profile.d"   # sh shell files
export SHELLD="${HOME}/.shell.d"       # Common shell files
export SHELL="${0}"                    # fix SHELL variable
[ ! -d "${PROFILED}" ] && mkdir "${PROFILED}" && chmod 700 "${PROFILED}"
[ -d "${HOME}'/bin'" ] && PATH="${HOME}'/bin:'${PATH}"

#----------------------------------------------------------------------
# From /etc/profile.d/256term.sh on Fedora 24:
#----------------------------------------------------------------------
# Set this variable in your local shell config (such as ~/.bashrc)
# if you want remote xterms connecting to this system, to be sent 256 colors.
# This must be set before reading global initialization such as /etc/bashrc.
export SEND_256_COLORS_TO_REMOTE=1
#----------------------------------------------------------------------
#-- Load in system profiles if they exist
#----------------------------------------------------------------------
for i in /etc/profile.d/*.sh; do
    [ -r "$i" ] && . "$i"
done; unset i

#----------------------------------------------------------------------
#-- Load/Initilize/Override settings
#----------------------------------------------------------------------
[ -r "${SHELLD}/settings" ] && . "${SHELLD}/settings"

#----------------------------------------------------------------------
#-- color TERM settings
#----------------------------------------------------------------------
if [ "$COLORTERM" == gnome-* && "$TERM" == xterm* ] && /usr/bin/infocmp gnome-256color >/dev/null 2>&1; then
    if [ -x /usr/bin/dircolors ]; then
        if [ -r "$HOME/.dirColors/dircolors.256dark" ]; then
            eval $(dircolors -b "$HOME/.dirColors/dircolors.256dark")
        elif [ -r "$HOME/.dirColors" ]; then
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
    if [ $(tput colors) -ge 256 ] 2>/dev/null; then
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
elif [ "$TERM" == linux ]; then
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
    [ $UNAMES = "SCO_SV" ] && TERM=xterm
    [ -x $(which tset) ] && eval `tset -s -Q`
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

#----------------------------------------------------------------------
#-- load general aliases
#----------------------------------------------------------------------
[ -r "${PROFILED}/alias.general" ] && . "${PROFILED}/alias.general"
#   load default VCS aliases
[ -r "${PROFILED}/alias.${DEFAULT_VCS}" ] && [ -x "$(which $DEFAULT_VCS 2>/dev/null)" ] && . "${PROFILED}/alias.${DEFAULT_VCS}"
#   load platform aliases
[ -r "${PROFILED}/alias.${UNAMES}" ] && . "${PROFILED}/alias.${UNAMES}"

#----------------------------------------------------------------------
#-- platform-specific stuff goes in these files.
#----------------------------------------------------------------------
[ -r "${PROFILED}/profile.${UNAMES}" ] && . "${PROFILED}/profile.${UNAMES}"

#This will most likely only execute on Mac OS X systems w/Fink
#  but it's here like this in case I emulate the system elsewhere
[ -x /sw/bin/init.sh ] && . /sw/bin/init.sh

#----------------------------------------------------------------------
#-- Load functions
#----------------------------------------------------------------------
[ -r "${SHELLD}/functions/general" ] && . "${SHELLD}/functions/general"

#----------------------------------------------------------------------
#-- Set up the shell environment
#----------------------------------------------------------------------
trap "echo 'logout'" 0
# removed '-o nounset' as it caused problems w/bash autocomplete
set -o noclobber -o vi -o notify

#----------------------------------------------------------------------
#-- Shell dependent settings
#----------------------------------------------------------------------
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

#----------------------------------------------------------------------
# FWIW:
# tcsh   - $version  - set to tcsh version number (also: set prompt='%n@%m %~ ')
# bash   - $BASH     - set to bash path
# [t]csh - $shell    - set to 'csh' or 'tcsh'
# zsh    - $ZSH_NAME - set to 'zsh'
# ksh has $PS3 & $PS4 set (normal Bourne shell (sh) only has $PS1 & $PS2 set).
#   This generally seems like the hardest to distinguish - the ONLY difference
#   in entire set of envionmental variables between sh and ksh installed on
#   Solaris: $ERRNO, $FCEDIT, $LINENO, $PPID, $PS3, $PS4, $RANDOM, $SECONDS, $TMOUT
#----------------------------------------------------------------------

type whereis >/dev/null 2>&1 || {
	alias whereis='type -all'
}

#----------------------------------------------------------------------
#-- Display some useful information
#----------------------------------------------------------------------
echo -e "${c_white}You're logged into ${c_bold}$HOSTNAME${c_norm}${c_white} in a(n) ${c_bold}$TERM${c_norm}${c_white} terminal with:${c_norm}
    ${c_white}${c_bold}System:${c_norm} ${c_purple}${UNAMES} (${UNAMER})${c_norm}
    ${c_white}${c_bold}Shell:${c_norm}  ${c_purple}${SHELLSTRING}${c_norm}
    ${c_white}${c_bold}Pager:${c_norm}  ${c_purple}${PAGER}${c_norm}
    ${c_white}${c_bold}Editor:${c_norm} ${c_purple}${EDITOR}${c_norm}
    ${c_white}${c_bold}VCS:${c_norm}    ${c_purple}${DEFAULT_VCS}${c_norm}"

# Print the Discordian date.
if [ -x $(which ddate 2>/dev/null) ]; then
    echo -e "${c_cyan}$(ddate +'Today is %{%A, the %e of %B%}, %Y YOLD. %N%nCelebrate %H')${c_norm}"
fi

# Print a random, hopefully interesting, adage.
if [ -x $(which fortune 2>/dev/null) ]; then
    echo -e "${c_purple}$(fortune -s)${c_norm}"
fi

