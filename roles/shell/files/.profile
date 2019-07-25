#!/usr/bin/sh
# [SublimeLinter shellcheck-exclude:"SC2154" ]
#==============================================================================
#
#         FILE: .profile
#
#  DESCRIPTION: My personalized shell profile, based on tons of things I've
#               found/learned over the years.
#
# REQUIREMENTS: POSIX compatible shell
#       AUTHOR: awmyhr, awmyhr@gmail.com
#      VERSION: 3.4.3
#     REVISION: 2019-07-25
#      CREATED: ????-??-??
#==============================================================================
#------------------------------------------------------------------------------
#-- Notes/known bugs/other issues
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
#-- Check for debug, and exit if not an interactive shell
#------------------------------------------------------------------------------
[ "${TRACE}" ]  && set -x    # Run in debug mode if called for
[ -t 0 ]        || return    # Exit if not interactive (no stdin)

#------------------------------------------------------------------------------
#-- "Baby, baby, baby, let's do it interactive"
#------------------------------------------------------------------------------
export SHELLD="${HOME}/.shell.d"       # Common shell files
export ENV="${HOME}/.profilerc"        # Set rc file for posix shells

#------------------------------------------------------------------------------
#-- Load/Initilize/Override settings
#------------------------------------------------------------------------------
[ -r "${SHELLD}/shellinit" ] && . "${SHELLD}/shellinit"

#------------------------------------------------------------------------------
#-- Let's set some shell options...
#------------------------------------------------------------------------------
# noclobber Prevent output redirection (>/>&/<>) from overwriting existing files.
# notify    Status of terminated background jobs are reported immediately
# vi        Use vi-style line editing (also affects editing w/'read -e.')
set -o noclobber -o notify -o vi

#------------------------------------------------------------------------------
#-- FWIW, some ways to identify current shell other than $SHELL & $0:
#--   tcsh   - $version  - set to tcsh version (also: set prompt='%n@%m %~ ')
#--   bash   - $BASH     - set to bash path
#--   [t]csh - $shell    - set to 'csh' or 'tcsh'
#--   zsh    - $ZSH_NAME - set to 'zsh'
#-- ksh has $PS3 & $PS4 set (normal Bourne shell (sh) only has $PS1 & $PS2 set).
#--     ksh adds 'l' to $-
#-- This generally seems like the hardest to distinguish - the ONLY difference
#-- in entire set of envionmental variables between sh and ksh installed on
#-- Solaris: $ERRNO $FCEDIT $LINENO $PPID $PS3 $PS4 $RANDOM $SECONDS $TMOUT
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
#-- Leave now if we're bash or zsh
#------------------------------------------------------------------------------
if [ "${BASH##/[a-z]*/}" = bash ] ; then
    SHELL='bash'
    return
elif [ -n "${ZSH_NAME:+set}" ] ; then
    SHELL='zsh'
    return
elif [ -z "${SHELL:+set}" ]; then
    SHELL="$(/usr/bin/basename "$(/usr/bin/ps -p $$ -ocomm=)")"
else
    SHELL="${SHELL##/[a-z]*/}"
fi

if [ "${SHELL}" = ksh ]; then
    s_SHELL="${s_ksh}"
else
    s_SHELL="${s_posix}"
fi

#------------------------------------------------------------------------------
#-- Display some useful information
#------------------------------------------------------------------------------
export SHELLSTRING="${SHELL}"
[ -x "${SHELLD}/lib/ssh-keycheck" ] && "${SHELLD}/lib/ssh-keycheck"
[ -x "${HOME}/bin/inxi" ]           && "${HOME}/bin/inxi" -CI 2>/dev/null
[ -x "${SHELLD}/lib/greeting" ]     && "${SHELLD}/lib/greeting"

printf "\n%s\n" "${c_purple}May U Live 2 See The Dawn...${c_norm}"

#------------------------------------------------------------------------------
#-- A Parting comment...
#------------------------------------------------------------------------------
[ "${BASH}" ] || trap 'printf "\n%s\n" "${c_purple}Welcome 2 The Dawn${c_norm}"' EXIT
