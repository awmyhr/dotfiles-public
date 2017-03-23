#!/usr/bin/zsh
# [SublimeLinter shellcheck-exclude:"SC2154,1071" ]
#===============================================================================
#
#         FILE: .zshrc
#
#        USAGE: (automagically loaded by zsh interactive shell)
#
#  DESCRIPTION: My personalized zsh profile, based on tons of things I've
#              found/learned over the years.
#
#      OPTIONS: ---
# REQUIREMENTS: ZSH shell
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: awmyhr, awmyhr@gmail.com
#      VERSION: 2.4.0
#      CREATED: ????-??-??
#     REVISION: 2017-03-23
#===============================================================================
#----------------------------------------------------------------------
#-- Notes/known bugs/other issues
#----------------------------------------------------------------------

#----------------------------------------------------------------------
#-- Check for debug, and exit if not an interactive shell
#----------------------------------------------------------------------
[[ "${TRACE}" ]]  && set -x  # Run in debug mode if called for
[[ -o interactive ]] || return  # Exit if not an interactive shell

#----------------------------------------------------------------------
#-- Load in ancillary if they exist
#----------------------------------------------------------------------
[[ -a "${ZSHD}/*.zsh" ]] && for i in ${ZSHD}/*.zsh; do
    [ -r "${i}" ] && source "${i}"
done; unset i

#----------------------------------------------------------------------
#-- Set zsh options stuff
#----------------------------------------------------------------------
# Initialization
setopt all_export
# Changing Directories
setopt auto_cd cdable_vars auto_pushd pushd_ignore_dups pushd_silent pushd_to_home
# Completion
setopt complete_aliases hash_list_all list_packed menu_complete
# Expansion and Globbing
setopt extended_glob numeric_glob_sort glob_dots
# History
setopt append_history hist_ignore_space hist_ignore_all_dups hist_reduce_blanks
setopt hist_lex_words hist_no_functions hist_verify hist_save_no_dups bang_hist
setopt share_history
# First set 'nocorrectall' than 'correct' to keep zsh from correcting args
# Input/Output              Jobs    Prompting       scripts/funcions
setopt nocorrectall correct notify   prompt_subst    multios
# zle
unsetopt beep

#----------------------------------------------------------------------
#-- Prompt configuration
#----------------------------------------------------------------------
precmd () {
    # Update terminal title string
    # xterm*|vte*|rxvt*
    printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"
    # screen*
    # printf "\033k%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"
    VCS_CHAR=$(_vcs_prompt_char)
    if [[ "${VCS_CHAR}" == "${s_GIT}" ]];then
        VCS_MESS=$(_git_prompt)
    else
        VCS_MESS=''
    fi
}

if [[ "${ISSET_COLORS}" ]]; then
    # Going to assume if ISSET_COLORS then ISSET_SYMBOLS and ISSET_FUNCTIONS
    # zsh needs special formating for prompt colors
    export c_pEMERG="%{${c_EMERG}%}"
    export c_pALERT="%{${c_ALERT}%}"
    export c_pCRIT="%{${c_CRIT}%}"
    export c_pERR="%{${c_ERR}%}"
    export c_pWARNING="%{${c_WARNING}%}"
    export c_pNOTICE="%{${c_NOTICE}%}"
    export c_pINFO="%{${c_INFO}%}"
    export c_pDEBUG="%{${c_DEBUG}%}"
    export c_pnorm="%{$c_norm%}"

    if [[ -n "${SSH_CLIENT}" || -n "${SSH_CONNECTION}" || -n "${SSH_TTY}" ]] ; then
        C_LOCATION="${c_cyan}"
    else
        C_LOCATION="${c_blue}"
    fi

    # %B sets bold, %b turns it off
    # %F{color} sets forground color, %f turns it off
    # %K(color} sets background color, $k turns it off
    # %{ and %} tell zsh to not count characters inbetween
    # %n username, %m hostname
    # see http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html for more
    Z_NL=$'\n'

    # Main Prompt line 1 -- Status info such as exit code, sudo user
    PROMPT="${c_ALERT}"
    PROMPT+='$(exit_code="${?}" && [ "${exit_code}" -ne 0 ] && printf "¡%s¡" "${exit_code}")'
    PROMPT+="${c_pINFO}"
    PROMPT+='$(if [ -z "${SUDO_USER}" ] ; then printf "%s" "---"; else printf "%s" "${SUDO_USER}"; fi)'
    PROMPT+="---${c_pnorm}${Z_NL}"
    # Main Prompt line 2 -- host/current user/vcs info
    PROMPT+="%{%K{${c_black}}%}${s_zsh}┌%{%b%K{${c_black}}${c_green}%}($UNAMES) "
    # This is not working because once user is changed the c_ vars are lost
    # PROMPT+='$(if [ ${UID} -eq 0 ] ; then printf "%s" "${c_red}"; else printf "%s" "${C_LOCATION}"; fi)'
    # PROMPT+="\u${c_green}@${C_LOCATION}\h: ${c_yellow}\w "
    PROMPT+="%{${C_LOCATION}%}%n%{${c_green}%}@%{${C_LOCATION}%}%m: %{${c_yellow}%}%~ "
    PROMPT+='${VCS_MESS}'
    PROMPT+=" ${c_pnorm}${Z_NL}"
    # Main Prompt line 3 -- command number, quick info/symbol
    PROMPT+="%{%K{${c_black}}%}${s_zsh}└!${c_pDEBUG}%! [%l] "
    PROMPT+='${VCS_CHAR}'
    PROMPT+=" \$ ${c_pnorm}"

    # Secondary Prompt
    PS2="${c_yellow}%_ ${s_NEXT} ${c_pnorm}"
else
    # Main Prompt line 1 -- Status info such as sudo
    PROMPT=''
    PROMPT+='$(exit_code="${?}" && [ "${exit_code}" -ne 0 ] && printf "¡%s¡" "${exit_code}")'
    PROMPT+='$(if [ -z "${SUDO_USER}" ] ; then printf "%s" "---"; else printf "%s" "${SUDO_USER}"; fi)'
    PROMPT+="---${Z_NL}"
    # Main Prompt line 2 -- host/current user/vcs info
    PROMPT+='Z (${OSTYPE}) '
    PROMPT+='%n@%m: ${PWD/#$HOME/~}\n'
    # Main Prompt line 3 -- command number, quick info/symbol
    PROMPT+='Z !%! [%l] %#$ '

    # Secondary Prompt
    PS2='%_ > '
fi
export PROMPT PS2

#----------------------------------------------------------------------
#-- key bindings
#----------------------------------------------------------------------
bindkey -v                                       # Use VIM bindings
bindkey ' ' magic-space                          # History expansion on space
if [[ "$(whence -w hh)" == 'hh: command' ]]; then # Bind Ctrl-r to history search
    function _hh { hh }                          # Create hh widget first
    zle -N _hh
    bindkey '^R' _hh
else
    bindkey '^R' history-incremental-search-backward
fi

#----------------------------------------------------------------------
#-- auto completion things
#----------------------------------------------------------------------
autoload -Uz compinit && compinit
zmodload -i zsh/complist                         # color in auto-complete menu
zstyle :compinstall filename '/home/awmyhr/.zshrc'

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*:manuals' separate-sections true       # show seperate manpage sections
zstyle ':completion::complete:*' use-cache on               # completion caching, use rehash to clear
zstyle ':completion:*' cache-path ~/.zshrc.d/zcompcache     # cache path
zstyle ':completion:*' menu select=2                        # menu if nb items > 2
zstyle ':completion:*' group-name ''                        # use match tags for groups
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list '' '' '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[._-]=** r:|=**'

zstyle ':completion:*'              format 'Completing %d'
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:messages'     format 'message for %d'
zstyle ':completion:*:warnings'     format '%BSorry, no matches for: %d%b'

zstyle ':completion:*:processes'   command 'ps -au$USER'
zstyle ':completion:*:*:kill:*'    menu yes select
zstyle ':completion:*:kill:*'      force-list always
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=29=34"
zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*'   force-list always

# SSH autocomplete
zstyle -e ':completion::*:*:*:hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
# format: :completion::complete:dvips:option-o-1:files

# _gnu_generic completion works with commands that understand std --help
[[ "$(whence -w gcc)"     == 'gcc: command' ]]     && compdef _gnu_generic gcc
[[ "$(whence -w r2)"      == 'r2: command' ]]      && compdef _gnu_generic r2
[[ "$(whence -w gdb)"     == 'gdb: command' ]]     && compdef _gnu_generic gdb
[[ "$(whence -w ack)"     == 'ack: command' ]]     && compdef _gnu_generic ack
[[ "$(whence -w openssl)" == 'openssl: command' ]] && compdef _gnu_generic openssl

# format: compdef <function> <program>
# also: _pids works for commands which expect a pid
#   maybe other functions in /usr/share/zsh/5.2/functions/_gnu_generic

#----------------------------------------------------------------------
#-- Take advantage of some zsh built-in features
#----------------------------------------------------------------------
REPORTTIME=60                     # report time if runs more than >60 seconds
WATCH=all                         # watch for all login/logout events
LOGCHECK=30                       # check for above every 30 seconds
# format for watch/log, ex:
# amyhr@:0 has logged on [pts/0] at 2016-10-07 18:14
WATCHFMT="%(a:${c_blue}:${c_cyan})%n@%m has %B%a%b%(a:${c_blue}:${c_cyan}) [%l] at 20%D %T${c_norm}"
