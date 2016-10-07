#!/usr/bin/zsh
# [SublimeLinter shellcheck-exclude:"SC1071" ]
#===============================================================================
#
#         FILE: .zprofile
#
#        USAGE: (automagically loaded by zsh interactive login shell)
#
#  DESCRIPTION:  My personalized bash profile, based on tons of things I've
#               found/learned over the years.
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

#----------------------------------------------------------------------
#-- Load general shell stuff
#----------------------------------------------------------------------
export ZSHD="${HOME}/.zshrc.d"    # ZSH specific files
export ZDOTDIR="${ZSHD}"          # set zsh env for zshd
[[ ! -d "${ZSHD}" ]]     && mkdir "${ZSHD}" && chmod 700 "${ZSHD}"

_src_etc_profile() {
    emulate -L ksh
    
    [[ -r "${HOME}/.profile" ]] && source "${HOME}/.profile"
}
_src_etc_profile && unset -f _src_etc_profile

#----------------------------------------------------------------------
#-- Set zsh specific stuff
#----------------------------------------------------------------------
export HIST_STAMPS='yyyy-mm-dd'
export HISTFILE="${ZSHD}/.zsh_history"
export HISTIGNORE='(&|[ ]*|exit|ls|history|[bf]g|reset|clear|cd|cd ..|cd..|fc *)'
# Uncomment the following line to display red dots whilst waiting for completion.
export COMPLETION_WAITING_DOTS="true"

#----------------------------------------------------------------------
#-- Completion dump file schtuff
#----------------------------------------------------------------------
# export ZSH_COMPDUMP="${ZSHD}/.zcompdump-${HOSTNAME}-${ZSH_VERSION}"

# {
#     # Compile the completion dump to increase startup speed.
#     if [[ -s "${ZSH_COMPDUMP}" && (! -s "${ZSH_COMPDUMP}.zwc" || "${ZSH_COMPDUMP}" -nt "${ZSH_COMPDUMP}.zwc") ]]; then
#         zcompile "${ZSH_COMPDUMP}"
#     fi
# } &!

