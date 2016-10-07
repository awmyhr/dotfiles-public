#!/usr/bin/zsh
# [SublimeLinter shellcheck-exclude:"SC1071" ]
#===============================================================================
#
#         FILE: .zprofile
#
#        USAGE: (automagically loaded by zsh interactive login shell)
#
#  DESCRIPTION:  This is loaded after zshenv, before zshrc
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
#-- Load general shell stuff
#----------------------------------------------------------------------

_src_etc_profile() {
    # since the general files are coded in posix
    emulate -L posix
    
    [[ -r "${HOME}/.profile" ]] && source "${HOME}/.profile"
}
_src_etc_profile && unset -f _src_etc_profile

