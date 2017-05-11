#!/usr/bin/zsh
# [SublimeLinter shellcheck-exclude:"SC1071" ]
#===============================================================================
#
#         FILE: .zlogout
#
#  DESCRIPTION:  This is the last file automagically loaded by a zsh interactive
#                login shell.
#
# REQUIREMENTS: ZSH shell
#       AUTHOR: awmyhr, awmyhr@gmail.com
#      VERSION: 1.2.0
#     REVISION: 2017-05-11
#      CREATED: 2016-10-07
#===============================================================================
#----------------------------------------------------------------------
#-- Notes/known bugs/other issues
#----------------------------------------------------------------------

#----------------------------------------------------------------------
#-- Display some useful information
#----------------------------------------------------------------------
[[ -r "${SHELLD}/lib/ssh-keycheck" ]] && "${SHELLD}/lib/ssh-keycheck"
[[ -r "${HOME}/bin/inxi" ]]           && "${HOME}/bin/inxi" -CSI
[[ -r "${SHELLD}/lib/greeting" ]]     && "${SHELLD}/lib/greeting"

printf "\n%s\n" "${c_purple}May U Live 2 See The Dawn...${c_norm}"
