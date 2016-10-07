#!/usr/bin/bash
# [SublimeLinter shellcheck-exclude:"SC2154" ]
#===============================================================================
#
#         FILE: .bashrc
#
#        USAGE: (automagically loaded by bash interactive non-login shell)
#               (also called from .bash_profile)
#
#  DESCRIPTION: My personalized bash profile, based on tons of things I've
#               found/learned over the years.
#
#      OPTIONS: ---
# REQUIREMENTS: Bash shell
#    OPTIONALS: hh (via 'hstr')
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: awmyhr, awmyhr@gmail.com
#      VERSION: 2.0.2
#      CREATED: ????-??-??
#     REVISION: 2016-10-06
#===============================================================================
#----------------------------------------------------------------------
#-- Notes/known bugs/other issues
#       Exporting functions for sub-shell usage can throw errors once 
#       the sub-shell is entered in some circumstances.
#----------------------------------------------------------------------

#----------------------------------------------------------------------
#-- Check for debug, and exit if not an interactive shell
#----------------------------------------------------------------------
[[ "${TRACE}" ]]  && set -x  # Run in debug mode if called for
[[ $- =~ .*i*. ]] || return  # Exit if not an interactive shell

#----------------------------------------------------------------------
#-- Load ancillary bash configs if they exist
#----------------------------------------------------------------------
for i in $(ls ${BASHD}/*.bash 2>/dev/null); do
    [[ -r "$i" ]] && source "$i"
done; unset i

#----------------------------------------------------------------------
#-- Prompt time
#----------------------------------------------------------------------
if [[ "${ISSET_COLORS}" ]]; then
    export c_pEMERG="\[${c_EMERG}\]"
    export c_pALERT="\[${c_ALERT}\]"
    export c_pCRIT="\[${c_CRIT}\]"
    export c_pERR="\[${c_ERR}\]"
    export c_pWARNING="\[${c_WARNING}\]"
    export c_pNOTICE="\[${c_NOTICE}\]"
    export c_pINFO="\[${c_INFO}\]"
    export c_pDEBUG="\[${c_DEBUG}\]"
    export c_pnorm="\[${c_norm}\]"

    if [[ ! -z ${SSH_TTY} ]]; then
        TTY=${SSH_TTY}
    elif [[ -z ${TTY} ]]; then
        TTY=$(tty)
    fi
    TTY=${TTY#/dev/}
    # \j = # of jobs ; \l basname of terminal device
    PS1="---${c_pnorm}
B┌${c_ALERT}\$(_return_code)${c_pnorm}${c_green}($UNAMES) ${c_blue}\u${c_green}@${c_blue}\h: ${c_yellow}\w${c_pnorm} 
B└${c_pDEBUG}\041\! [${TTY}] \$(_vcs_prompt_char) \$${c_pnorm} "
else
    PS1="---
B ($(uname -s)) \u@\h: \w 
B \041\! \$ "
fi
export PS1
# Record each line of history right away instead of at the end of the session
PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"

#----------------------------------------------------------------------
#-- Let's set some shell options...
#----------------------------------------------------------------------
# noclobber Prevent output redirection (>/>&/<>) from overwriting existing files.
# notify    Status of terminated background jobs are reported immediately
# vi        Use vi-style line editing (also affects editing w/'read -e.')
set -o noclobber -o notify -o vi

#----------------------------------------------------------------------
#-- Let's set some shoptions...
#----------------------------------------------------------------------
# autocd       - type 'directoryname' instead of 'cd directoryname'
# cdspell      - autocorrect typos in path names when using cd
# checkwinsize - keeps bash updated on window size
# cmdhist      - save multi-line commands to history as one command
# dirspell     - correct spelling of directories
# extglob      - Enable extended pattern matching features
# histappend   - Turn on parallel history
for i in autocd cdspell checkwinsize cmdhist dirspell extglob histappend; do
    shopt -s -q "${i}"
done; unset i

#----------------------------------------------------------------------
#-- Conditional keybinds
#----------------------------------------------------------------------
# bind hh to Ctrl-r
[[ $(type -t hh) == file ]] && bind '"\C-r": "\C-a hh \C-j"'

