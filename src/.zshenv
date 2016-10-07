#!/usr/bin/zsh
# [SublimeLinter shellcheck-exclude:"SC1071" ]
#===============================================================================
#
#         FILE: .zshenv
#
#        USAGE: (automagically loaded by zsh shell)
#
#  DESCRIPTION:  Sets up very basic bits of the zsh environment
#
#      OPTIONS: ---
# REQUIREMENTS: ZSH shell
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: awmyhr, awmyhr@gmail.com
#      VERSION: 1.0.0-alpha
#      CREATED: 2016-10-07
#     REVISION: 2016-10-07
#===============================================================================
#----------------------------------------------------------------------
#-- Notes/known bugs/other issues
#----------------------------------------------------------------------

export ZSHD="${HOME}/.zshrc.d"    # ZSH specific files
export ZDOTDIR="${ZSHD}"          # set zsh env for zshd
[[ ! -d "${ZSHD}" ]]     && mkdir "${ZSHD}" && chmod 700 "${ZSHD}"

