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
#       AUTHOR: awmyhr, awmyhr@gmail.com
#      VERSION: 1.1.0
#     REVISION: 2017-05-02
#      CREATED: 2016-10-07
#===============================================================================
#----------------------------------------------------------------------
#-- Notes/known bugs/other issues
#----------------------------------------------------------------------

#----------------------------------------------------------------------
#-- Display some useful information
#----------------------------------------------------------------------
[[ -r "${SHELLD}/lib/ssh-keycheck" ]] && "${SHELLD}/lib/ssh-keycheck"
[[ -r "${SHELLD}/lib/greeting" ]] && "${SHELLD}/lib/greeting"

printf "\n%s\n" "${c_purple}May U Live 2 See The Dawn...${c_norm}"
