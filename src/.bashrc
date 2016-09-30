#!/usr/bin/bash
#===============================================================================
#
#         FILE: .bashrc
#
#        USAGE: (automagically loaded by bash interactive shell)
#
#  DESCRIPTION: My personalized bash profile, based on tons of things I've
#               found/learned over the years.
#
#      OPTIONS: ---
# REQUIREMENTS: Bash shell
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: awmyhr, awmyhr@gmail.com
#      VERSION: 2.0.0
#      CREATED: ????-??-??
#     REVISION: 2016-09-30
#===============================================================================
#----------------------------------------------------------------------
#-- Notes/known bugs/other issues
#----------------------------------------------------------------------

#----------------------------------------------------------------------
#-- Set sane path, check for debug, and exit if not an interactive shell
#----------------------------------------------------------------------
export PATH='/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin'
[[ "${TRACE}" ]]  && set -x  # Run in debug mode if called for
[[ $- =~ .*i*. ]] || return  # Exit if not an interactive shell

#----------------------------------------------------------------------
#-- "Baby, baby, baby, let's do it interactive"
#----------------------------------------------------------------------
export BASHD="${HOME}/.bashrc.d"  # Bash shell files
export SHELLD="${HOME}/.shell.d"  # Common shell files
export SHELL="${BASH}"            # fix SHELL variable
[[ ! -d "${BASHD}" ]]    && mkdir "${BASHD}" && chmod 700 "${BASHD}"

#----------------------------------------------------------------------
# From /etc/profile.d/256term.sh on Fedora 24:
#----------------------------------------------------------------------
# Set this variable in your local shell config (such as ~/.bashrc)
# if you want remote xterms connecting to this system, to be sent 256 colors.
# This must be set before reading global initialization such as /etc/bashrc.
export SEND_256_COLORS_TO_REMOTE=1
#----------------------------------------------------------------------
#-- Load in system profiles if they exist
#----------------------------------------------------------------------
for i in /etc/profile.d/*.sh; do
    [[ -r "$i" ]] && source "$i"
done; unset i

#----------------------------------------------------------------------
#-- Load/Initilize/Override settings
#----------------------------------------------------------------------
[[ -r "${SHELLD}/settings" ]] && source "${SHELLD}/settings"

export HISTFILE="${BASHD}/.bash_history"

#----------------------------------------------------------------------
#-- Load ancillary bash configs if they exist
#----------------------------------------------------------------------
for i in ${BASHD}/*.bash; do
    [[ -r "$i" ]] && source "$i"
done; unset i

#----------------------------------------------------------------------
### This gives us darcs completion in bash if it exists
#----------------------------------------------------------------------
[[ -f /usr/local/share/darcs_completion ]] && source /usr/local/share/darcs_completion

# User configuration -- NOTE: a lot of fuctions depend on my .profile!
if [[ -r "$HOME/.profile" ]]; then
    . "$HOME/.profile"
    # Because zsh needed special variables, we set them here as well
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
    PS1="B${c_ALERT}\$(_return_code)${c_pnorm}${c_green}($UNAMES) ${c_blue}\u${c_green}@${c_blue}\h:${c_yellow}\w${c_pnorm} \nB${c_pDEBUG}\041\! [${TTY}] \$(_vcs_prompt_char) \$${c_pnorm} "
else
    echo "WARNING: missing $HOME/.profile!!"
    export MANPATH="/usr/local/man:$MANPATH"

    PS1="B$(uname -s) \u@\h:\w \nB\041\! \$ "
fi
export PS1

#----------------------------------------------------------------------
### Let's set some shoptions...
#----------------------------------------------------------------------
# autocd       - type 'directoryname' instead of 'cd directoryname'
# cdspell      - autocorrect typos in path names when using cd
# checkwinsize - keeps bash updated on window size
# cmdhist      - save multi-line commands to history as one command
# dirspell     - correct spelling of directories
# histappend   - Turn on parallel history
# Some shoptions are not available in every version of Bash, so check first
for i in autocd cdspell checkwinsize cmdhist dirspell histappend; do
    shopt -s "${i}"
done
unset i

# Append to history file
history -a
export HISTCONTROL=ignoreboth:erasedups
# Record each line of history right away instead of at the end of the session
PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"


# bind hh to Ctrl-r
[[ $(type -t hh) == file ]] && bind '"\C-r": "\C-a hh \C-j"'

# Clean up
