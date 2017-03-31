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
#      VERSION: 2.7.0
#      CREATED: ????-??-??
#     REVISION: 2017-03-31
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
[[ -a "${BASH}/*.bash" ]] && for i in ${BASHD}/*.bash; do
    [[ -r "$i" ]] && source "$i"
done; unset i

#----------------------------------------------------------------------
#-- Prompt time
#----------------------------------------------------------------------
_prompt_command() {
    history -a
    history -n
    # Update terminal title string
    # xterm*|vte*|rxvt*
    printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"
    # screen*
    # printf "\033k%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"
    command -v _vcs_prompt_char >/dev/null 2>&1 && {
        VCS_CHAR=$(_vcs_prompt_char)
    }
    command -v _vcs_prompt >/dev/null 2>&1 && {
        if [[ "${VCS_CHAR}" != "${s_NOVCS}" ]];then
            VCS_MESS=$(_vcs_prompt)
        else
            VCS_MESS=''
        fi
    }
}
PROMPT_COMMAND=_prompt_command

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

    if [[ "${STAT_SSH}" != '---' ]] ; then
        TTY="${SSH_TTY}"
        C_LOCATION="${c_cyan}"
    else
        C_LOCATION="${c_blue}"
    fi

    if [[ -z "${TTY}" ]]; then
        TTY=$(tty)
    fi

    TTY=${TTY#/dev/}

    # NOTE: Bash under MINGW64 does not like $() in PS1. Why? IDK && Li2S...
    # Main Prompt line 1 -- Status info such as exit code, sudo user
    # These should be VERY simple checks (i.e., if a variable or file exists)
    # In modern systems one can reasonably rely on 80 columns, but building
    #   in a margin of error is reasonable. Target no more than 60 at this time.
    # exit_code -> upto 5, SUDO_USER -> upto 12, service checks -> 3 each
    # current checks: (static) VM? SSH? / (dynamic) Docker? PCS?
    # current total: 29
    PS1="${c_ALERT}"
    PS1+='`exit_code="${?}" && [ "${exit_code}" -ne 0 ] && printf "¡%s¡" "${exit_code}"`'
    PS1+='`[ ! -z "${SUDO_USER+x}" ] && printf "%s" "[${SUDO_USER}]"`'
    PS1+="${c_pINFO}${STAT_VM}${STAT_SSH}"
    PS1+='`if [[ -f /var/run/docker.pid ]];then printf "%s" "[D]"; else printf "%s" "---"; fi`'
    PS1+='`if [[ -f /var/run/pcsd.pid ]];then printf "%s" "[P]"; else printf "%s" "---"; fi`'
    PS1+="---${c_pnorm}\n"
    # Main Prompt line 2 -- host/current user/vcs info
    PS1+="${s_bash}┌${c_pnorm}${c_green}($UNAMES) "
    # This is not working because once user is changed the c_ vars are lost
    # PS1+='$(if [ ${UID} -eq 0 ] ; then printf "%s" "${c_red}"; else printf "%s" "${C_LOCATION}"; fi)'
    # PS1+="\u${c_green}@${C_LOCATION}\h: ${c_yellow}\w "
    PS1+="${C_LOCATION}\u${c_green}@${C_LOCATION}\h: ${c_yellow}\w "
    PS1+='${VCS_MESS}'
    PS1+=" ${c_pnorm}\n"
    # Main Prompt line 3 -- command number, quick info/symbol
    PS1+="${s_bash}└${c_pDEBUG}\041\! [${TTY}] "
    PS1+='${VCS_CHAR}'
    PS1+=" \$ ${c_pnorm}"

    # Secondary Prompt
    PS2="${c_yellow}${s_NEXT} ${c_pnorm}"
else
    # Main Prompt line 1 -- Status info such as sudo
    PS1=''
    PS1+='`exit_code="${?}" && [ "${exit_code}" -ne 0 ] && printf "¡%s¡" "${exit_code}"`'
    PS1+='`[ ! -z "${SUDO_USER+x}" ] && printf "%s" "[${SUDO_USER}]"`'
    PS1+="${STAT_VM}${STAT_SSH}"
    PS1+='`if [[ -f /var/run/docker.pid ]];then printf "%s" "[D]"; else printf "%s" "---"; fi`'
    PS1+='`if [[ -f /var/run/pcsd.pid ]];then printf "%s" "[P]"; else printf "%s" "---"; fi`'
    PS1+="---\n"
    # Main Prompt line 2 -- host/current user/vcs info
    PS1+='B (${OSTYPE}) '
    PS1+='\u@\h: \w \n'
    # Main Prompt line 3 -- command number, quick info/symbol
    PS1+='B \041\! \$ '

    # Secondary Prompt
    PS2='> '
fi
export PS1 PS2

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

