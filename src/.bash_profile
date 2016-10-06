#!/usr/bin/bash
# [SublimeLinter shellcheck-exclude:"SC2154" ]
#===============================================================================
#
#         FILE: .bash_profile
#
#        USAGE: (automagically loaded by bash interactive login shell)
#
#  DESCRIPTION: My personalized bash profile, based on tons of things I've
#               found/learned over the years.
#
#      OPTIONS: ---
# REQUIREMENTS: Bash shell
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: awmyhr, awmyhr@gmail.com
#      VERSION: 1.0.0
#      CREATED: 2016-10-05
#     REVISION: 2016-10-06
#===============================================================================
#----------------------------------------------------------------------
#-- Notes/known bugs/other issues
#----------------------------------------------------------------------

#----------------------------------------------------------------------
#-- Load .bashrc
#----------------------------------------------------------------------
[[ -r "${HOME}/.profile" ]] && source "${HOME}/.profile"
[[ -r "${HOME}/.bashrc" ]]  && source "${HOME}/.bashrc"

#----------------------------------------------------------------------
#-- Display some useful information
#----------------------------------------------------------------------
export SHELLSTRING="${BASH} (${BASH_VERSION})"
[[ -r "${SHELLD}/lib/greeting" ]] && "${SHELLD}/lib/greeting"

printf "\n%s\n" "${c_purple}May U Live 2 See The Dawn...${c_norm}"
