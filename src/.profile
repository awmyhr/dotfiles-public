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
#     REVISION: 2016-09-30
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

