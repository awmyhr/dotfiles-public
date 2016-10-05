#!/usr/bin/zsh
# [SublimeLinter shellcheck-exclude:"SC2154" ]
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
#      VERSION: 2.0.0-alpha
#      CREATED: ????-??-??
#     REVISION: 2016-10-05
#===============================================================================
#----------------------------------------------------------------------
#-- Notes/known bugs/other issues
#----------------------------------------------------------------------

#----------------------------------------------------------------------
#-- Check for debug, and exit if not an interactive shell
#----------------------------------------------------------------------
[[ "${TRACE}" ]]  && set -x  # Run in debug mode if called for
[[ $- =~ .*i*. ]] || return  # Exit if not an interactive shell

#----------------------------------------------------------------------
#-- "Baby, baby, baby, let's do it interactive"
#----------------------------------------------------------------------
export ZSHD="${HOME}/.zshrc.d"    # ZSH specific files
export SHELLD="${HOME}/.shell.d"  # Common shell files
export SHELL="${ZSH_NAME}"        # fix SHELL variable
[[ ! -d "${ZSHD}" ]]     && mkdir "${ZSHD}" && chmod 700 "${ZSHD}"

#----------------------------------------------------------------------
#-- Load in system profiles if they exist - currently not enabled for zsh
#----------------------------------------------------------------------
#for i in /etc/profile.d/*.sh; do
#    [[ -r "$i" ]] && . "$i"
#done; unset i

#----------------------------------------------------------------------
#-- Load/Initilize/Override settings
#----------------------------------------------------------------------
[[ -r "${SHELLD}/shellinit" ]] && source "${SHELLD}/shellinit"

export HIST_STAMPS='yyyy-mm-dd'
export HISTFILE="${ZSHD}/.zsh_history"
export HISTIGNORE='(&|[ ]*|exit|ls|history|[bf]g|reset|clear|cd|cd ..|cd..|fc *)'
# Uncomment the following line to display red dots whilst waiting for completion.
export COMPLETION_WAITING_DOTS="true"

#----------------------------------------------------------------------
#-- Load in ancillary if they exist
#----------------------------------------------------------------------
# this does not appear to be working if there are no files. grrr.
# for i in $ZSHD/*.zsh; do
#     [ -r "$i" ] && source "$i"
# done
# unset i

#----------------------------------------------------------------------
#-- Completion schtuff
#----------------------------------------------------------------------
# Save the location of the current completion dump file.
if [ -z "$ZSH_COMPDUMP" ]; then
  export ZSH_COMPDUMP="${ZSHD}/.zcompdump-${HOSTNAME}-${ZSH_VERSION}"
fi

{
  # Compile the completion dump to increase startup speed.
  if [[ -s "$ZSH_COMPDUMP" && (! -s "${ZSH_COMPDUMP}.zwc" || "$ZSH_COMPDUMP" -nt "${ZSH_COMPDUMP}.zwc") ]]; then
    zcompile "$ZSH_COMPDUMP"
  fi
} &!

#----------------------------------------------------------------------
#-- User configuration -- NOTE: a lot of fuctions depend on my .profile!
#----------------------------------------------------------------------
if [[ -r "$HOME/.profile" ]]; then
    . "$HOME/.profile"
    # zsh needs special formating for prompt colors
    c_pEMERG="%{${c_EMERG}%}"
    c_pALERT="%{${c_ALERT}%}"
    c_pCRIT="%{${c_CRIT}%}"
    c_pERR="%{${c_ERR}%}"
    c_pWARNING="%{${c_WARNING}%}"
    c_pNOTICE="%{${c_NOTICE}%}"
    c_pINFO="%{${c_INFO}%}"
    c_pDEBUG="%{${c_DEBUG}%}"
    c_pnorm="%{$c_norm%}"
    # %B sets bold, %b turns it off
    # %F{color} sets forground color, %f turns it off
    # %K(color} sets background color, $k turns it off
    # %{ and %} tell zsh to not count characters inbetween
    # %n username, %m hostname
    # see http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html for more
    export PROMPT='${c_pnorm}
%{%K{${c_black}}%}Z${c_pALERT}$(_return_code)%{%b%K{${c_black}}${c_green}%}($UNAMES) %{${c_blue}%}%n%{${c_green}%}@%{${c_blue}%}%m:%{${c_yellow}%}${PWD/#$HOME/~} $(_git_prompt)%E${c_pnorm}
%{%K{${c_black}}%}Z!${c_pDEBUG}%! [%l] $(_vcs_prompt_char) %#${c_pnorm} '
    export RPROMPT=''
else
    echo "WARNING: missing $HOME/.profile!!"
    export MANPATH="/usr/local/man:$MANPATH"
    
    export PROMPT="Z$(uname -s) \u@\h:\w \nZ!\! \$ "
    export RPROMPT=''
fi

# Use VIM bindings
bindkey -v
# also do history expansion on space
bindkey ' ' magic-space
# Bind Ctrl-r to history search
if [[ $(type hh >/dev/null) == file ]]; then
    function _hh { hh }      # Create hh widget first
    zle -N _hh
    bindkey '^R' _hh
else
    bindkey '^R' history-incremental-search-backward
fi

# Set up auto completion, etc...
# First set 'nocorrectall' than 'correct' to keep zsh from correcting args
setopt autocd multios prompt_subst nocorrectall correct extendedglob
setopt appendhistory histignorespace histignorealldups histreduceblanks histverify
zstyle :compinstall filename '/home/awmyhr/.zshrc'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
# SSH autocomplete
zstyle -e ':completion::*:*:*:hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
autoload -U colors && colors
autoload -Uz compinit && compinit

#----------------------------------------------------------------------
#-- Display some useful information
#----------------------------------------------------------------------
[ -r "${SHELLD}/lib/greeting" ] && "${SHELLD}/lib/greeting"

printf "\n%s\n" "${c_purple}May U Live 2 See The Dawn...${c_norm}"

#----------------------------------------------------------------------
#-- A Parting comment...
#----------------------------------------------------------------------
trap 'printf "\n%s\n" "${c_purple}Welcome 2 The Dawn${c_norm}"' EXIT
