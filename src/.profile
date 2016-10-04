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
#     REVISION: 2016-10-04
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
[ -r "${PROFILED}/alias.${DEFAULT_VCS}" ] && [ -x "$(which ${DEFAULT_VCS} 2>/dev/null)" ] && . "${PROFILED}/alias.${DEFAULT_VCS}"
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
#--     Theoretically, we'll never run this file under zsh/bash
#----------------------------------------------------------------------
case "${SHELL}" in
    *zsh* )
        SHELLSTRING="${SHELL} (${ZSH_VERSION})"
        PS1='${c_bold}${USER}@${HOSTNAME} (${UNAMES}): ${c_norm} $PWD
! $ '
        ;;

    *bash* )
        SHELLSTRING="${SHELL} (${BASH_VERSION})"
        PS1='${c_bold}${USER}@${HOSTNAME} (${UNAMES}): ${c_norm} $PWD
! $ '
        ;;

    *ksh* )
        SHELLSTRING="${SHELL} (${KSH_VERSION})"
        PS1='${c_bold}${USER}@${HOSTNAME} (${UNAMES}): ${c_norm} $PWD
! $ '
        ;;
    *csh )
        # Set a simple prompt
        SHELLSTRING="${shell}"
        PS1='${USER}@${HOSTNAME} $ '
        ;;
    *sh )
        # Set a simple prompt
        SHELLSTRING="${SHELL}"
        PS1='${USER}@${HOSTNAME} $ '
        ;;
    * )
        # Sorry, unknown shell??
        SHELLSTRING="UNKNOWN"

        PS1='$ '
        ;;
esac

export PS1 SHELLSTRING
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

#----------------------------------------------------------------------
#-- Display some useful information
#----------------------------------------------------------------------
[ -r "${SHELLD}/misc/greeting" ] && "${SHELLD}/misc/greeting"

