#!/bin/bash

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
### bash specific variables (common are set in .profile)
HISTFILE=$SHELLD/.bash_history
HISTFILESIZE=2000

###############################################################################
### Ancillary file directory set and create if necessary
export SHELLD=$HOME/.bashrc.d
[[ ! -d "$SHELLD" ]] && mkdir "$SHELLD" && chmod 700 "$SHELLD"

###############################################################################
### Load in system profiles if they exist
for i in /etc/profile.d/*.sh; do
    [ -r "$i" ] && source "$i"
done
unset i

###############################################################################
### Load in ancillary if they exist
for i in $SHELLD/*.sh; do
    [ -r "$i" ] && source "$i"
done
unset i

###############################################################################
### This gives us darcs completion in bash if it exists
[[ -f /usr/local/share/darcs_completion ]] && source /usr/local/share/darcs_completion

# User configuration -- NOTE: a lot of fuctions depend on my .profile!
if [[ -r "$HOME/.profile" ]]; then
    . "$HOME/.profile"
    # Because zsh needed special variables, we set them here as well
    c_pEMERG="${c_EMERG}"
    c_pALERT="${c_ALERT}"
    c_pCRIT="${c_CRIT}"
    c_pERR="${c_ERR}"
    c_pWARNING="${c_WARNING}"
    c_pNOTICE="${c_NOTICE}"
    c_pINFO="${c_INFO}"
    c_pDEBUG="${c_DEBUG}"

    # \j = # of jobs ; \l basname of terminal device
    PS1="${c_ALERT}\$(_return_code)${c_norm}${c_green}($UNAMES) ${c_blue}\u${c_green}@${c_blue}\h:${c_yellow}\w${c_norm} \n${c_pDEBUG}\041\! [\l] \$(_vcs_prompt_char) \$${c_norm} "
else
    echo "WARNING: missing $HOME/.profile!!"
    export MANPATH="/usr/local/man:$MANPATH"

    PS1="$(uname -s) \u@\h:\w \n\041\! \$ "
fi
export PS1

# Turn on parallel history
shopt -s histappend
history -a
# Turn on checkwinsize
shopt -s checkwinsize

# Clean up
