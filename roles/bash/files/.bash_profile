#!/bin/bash
# [SublimeLinter shellcheck-exclude:"SC2154" ]
#===============================================================================
#
#         FILE: .bash_profile
#
#  DESCRIPTION: My personalized bash profile, based on tons of things I've
#               found/learned over the years.
#
# REQUIREMENTS: Bash shell
#       AUTHOR: awmyhr, awmyhr@gmail.com
#      VERSION: 1.2.2
#     REVISION: 2018-06-15
#      CREATED: 2016-10-05
#===============================================================================
#----------------------------------------------------------------------
#-- Notes/known bugs/other issues
#----------------------------------------------------------------------

#----------------------------------------------------------------------
#-- Load shell settings (general and bash)
#----------------------------------------------------------------------
export BASHD="${HOME}/.bashrc.d"  # Bash specific files
[[ ! -d "${BASHD}" ]]       && mkdir "${BASHD}" && chmod 700 "${BASHD}"
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
[[ -r "${SHELLD}/lib/ssh-keycheck" ]] && "${SHELLD}/lib/ssh-keycheck"
[[ -r "${HOME}/bin/inxi" ]]           && "${HOME}/bin/inxi" -CI 2>/dev/null
[[ -r "${SHELLD}/lib/greeting" ]]     && "${SHELLD}/lib/greeting"

printf "\n%s\n" "${c_purple}May U Live 2 See The Dawn...${c_norm}"
