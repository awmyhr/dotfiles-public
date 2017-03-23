#!/usr/bin/zsh
# [SublimeLinter shellcheck-exclude:"SC1071" ]
#===============================================================================
#
#         FILE: .zlogout
#
#        USAGE: (automagically loaded by zsh interactive login shell)
#
#  DESCRIPTION:  This is the last file automagically loaded by a zsh interactive
#                login shell.
#
#      OPTIONS: ---
# REQUIREMENTS: ZSH shell
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: awmyhr, awmyhr@gmail.com
#      VERSION: 1.0.0
#      CREATED: 2016-10-07
#     REVISION: 2016-10-07
#===============================================================================
#----------------------------------------------------------------------
#-- Notes/known bugs/other issues
#----------------------------------------------------------------------

#----------------------------------------------------------------------
#-- Display some useful information
#----------------------------------------------------------------------
[[ -r "${SHELLD}/lib/greeting" ]] && "${SHELLD}/lib/greeting"

printf "\n%s\n" "${c_purple}May U Live 2 See The Dawn...${c_norm}"
