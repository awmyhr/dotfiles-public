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
#      VERSION: 1.0.0
#      CREATED: 2016-10-07
#     REVISION: 2016-10-07
#===============================================================================
#----------------------------------------------------------------------
#-- Notes/known bugs/other issues
#----------------------------------------------------------------------

export ZSHD="${HOME}/.zshrc.d"         # ZSH specific files
export ZDOTDIR="${ZSHD}"               # set zsh env for zshd
[[ ! -d "${ZSHD}" ]]     && mkdir "${ZSHD}" && chmod 700 "${ZSHD}"

export SHELLSTRING="${ZSH_NAME} (${ZSH_VERSION})"

export HIST_STAMPS='yyyy-mm-dd'
export HISTFILE="${ZSHD}/.zsh_history"
export COMPLETION_WAITING_DOTS="true"   # display red dots while waiting for completion.
export ZSH_COMPDUMP="${ZSHD}/.zcompdump-${HOSTNAME/.*/}-${ZSH_VERSION}"
