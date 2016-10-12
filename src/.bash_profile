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
#      VERSION: 1.0.1
#      CREATED: 2016-10-05
#     REVISION: 2016-10-12
#===============================================================================
#----------------------------------------------------------------------
#-- Notes/known bugs/other issues
#----------------------------------------------------------------------

export BASHD="${HOME}/.bashrc.d"  # Bash specific files
[[ ! -d "${BASHD}" ]]    && mkdir "${BASHD}" && chmod 700 "${BASHD}"

#----------------------------------------------------------------------
#-- Load shell settings (general and bash)
#----------------------------------------------------------------------
[[ -r "${HOME}/.profile" ]] && source "${HOME}/.profile"
[[ -r "${HOME}/.bashrc" ]]  && source "${HOME}/.bashrc"

#----------------------------------------------------------------------
#-- some history stuff
#----------------------------------------------------------------------
export HISTFILE="${BASHD}/.bash_history"
export HISTCONTROL=ignoreboth:erasedups

#----------------------------------------------------------------------
#-- Display some useful information
#----------------------------------------------------------------------
export SHELLSTRING="${BASH} (${BASH_VERSION})"
[[ -r "${SHELLD}/lib/greeting" ]] && "${SHELLD}/lib/greeting"

printf "\n%s\n" "${c_purple}May U Live 2 See The Dawn...${c_norm}"
