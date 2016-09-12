#!/bin/zsh

umask 022

###############################################################################
### set a reasonable default path
PATH='/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin'
[[ -d $HOME'/bin' ]] && PATH=$HOME'/bin:'$PATH

###############################################################################
### If this is not an interactive shell, exit here
[[ $- = *i* ]] || return
# fix SHELL variable
export SHELL=$0

###############################################################################
### zsh specific variables (common are set in .profile)
export HIST_STAMPS="yyyy-mm-dd"
export HISTFILE=$SHELLD/.zsh_history

###############################################################################
### Ancillary file directory set and create if necessary
export SHELLD=$HOME/.zshrc.d
[[ ! -d "$SHELLD" ]] && mkdir "$SHELLD" && chmod 700 "$SHELLD"

###############################################################################
### Load in ancillary if they exist
# this does not appear to be working if there are no files. grrr.
# for i in $SHELLD/*.zsh; do
#     [ -r "$i" ] && source "$i"
# done
# unset i

###############################################################################
### Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"
# Save the location of the current completion dump file.
if [ -z "$ZSH_COMPDUMP" ]; then
  export ZSH_COMPDUMP="${SHELLD}/.zcompdump-${HOSTNAME}-${ZSH_VERSION}"
fi

###############################################################################
### User configuration -- NOTE: a lot of fuctions depend on my .profile!
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

    # %B sets bold, %b turns it off
    # %F{color} sets forground color, %f turns it off
    # %K(color} sets background color, $k turns it off
    # %{ and %} tell zsh to not count characters inbetween
    # %n username, %m hostname
    # see http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html for more
    export PROMPT='%{$reset_color%}
%{%K{${c_black}}%}┌${c_pALERT}$(_return_code)%{%b%K{${c_black}}${c_green}%}($UNAMES) %{${c_blue}%}%n%{${c_green}%}@%{${c_blue}%}%m:%{${c_yellow}%}${PWD/#$HOME/~} $(_git_prompt)%E$reset_color
%{%K{${c_black}}%}└!${c_pDEBUG}%! [%l] $(_vcs_prompt_char) %#%{$reset_color%} '
    export RPROMPT=''

else
    echo "WARNING: missing $HOME/.profile!!"
    export MANPATH="/usr/local/man:$MANPATH"
    
    export PROMPT="┌$(uname -s) \u@\h:\w \n└!\! \$ "
    export RPROMPT=''
fi

# Use VIM bindings
bindkey -v
# Set Ctrl-R to search history
bindkey '^R' history-incremental-search-backward
# bind hh to Ctrl-r (for Vi mode check doc)
#bindkey -s "\C-r" "\eqhh\n"

# Set up auto completion, etc...
setopt auto_cd multios prompt_subst
setopt appendhistory autocd extendedglob correctall histignorealldups
zstyle :compinstall filename '/home/awmyhr/.zshrc'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
autoload -U colors && colors
autoload -Uz compinit && compinit
