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
#      VERSION: 2.0.0
#      CREATED: ????-??-??
#     REVISION: 2016-10-07
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
[[ -a "${ZSHD}/*.zsh" ]] && for i in $(ls ${ZSHD}/*.zsh); do
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
if [[ "${ISSET_COLORS}" ]]; then
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
    export PROMPT='---${c_pnorm}
%{%K{${c_black}}%}Z┌${c_pALERT}$(_return_code)%{%b%K{${c_black}}${c_green}%}($UNAMES) %{${c_blue}%}%n%{${c_green}%}@%{${c_blue}%}%m:%{${c_yellow}%}${PWD/#$HOME/~} $(_git_prompt)%E${c_pnorm}
%{%K{${c_black}}%}Z└!${c_pDEBUG}%! [%l] $(_vcs_prompt_char) %#${c_pnorm} '
    export RPROMPT=''
else
    export PROMPT='---
Z ($(uname -s)) %n@%m: ${PWD/#$HOME/~}
Z !%! [%l] %#$ '
    export RPROMPT=''
fi

#----------------------------------------------------------------------
#-- key bindings
#----------------------------------------------------------------------
bindkey -v                                       # Use VIM bindings
bindkey ' ' magic-space                          # History expansion on space
if [[ $(type hh >/dev/null) == file ]]; then     # Bind Ctrl-r to history search
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
compdef _gnu_generic gcc
compdef _gnu_generic r2
compdef _gnu_generic gdb
compdef _gnu_generic openssl
# format: compdef <function> <program>
# also: _pids works for commands which expect a pid
#   maybe other functions in /usr/share/zsh/5.2/functions/_gnu_generic


#----------------------------------------------------------------------
#-- Some notes for future reference
#----------------------------------------------------------------------
## ZSH has "builtin" support for VCS. see:
# ls /usr/share/zsh/5.2/functions/[vV]*
#
#like this:
# autoload -Uz vcs_info
# zstyle ':vcs_info:*' enable git svn hg
# zstyle ':vcs_info:*' check-for-changes true
# zstyle ':vcs_info:*' formats "%{$fg[yellow]%}%c%{$fg[green]%}%u%{$reset_color%} [%{$fg[blue]%}%b%{$reset_color%}] %{$fg[yellow]%}%s%{$reset_color%}:%r"
# precmd() {  # run before each prompt
#   vcs_info
# }
# color="blue"
# RPROMPT='${vcs_info_msg_0_}'

# special functions:
# chpwd ()    - Executed whenever the current working directory is changed.
# periodic () - If  the parameter PERIOD is set, this function is executed every $PERIOD sec‐
#   onds, just before a prompt.  Note that  if  multiple  functions  are  defined
#   using the array periodic_functions only one period is applied to the complete
#   set of functions, and the scheduled time is not reset if the  list  of  func‐
#   tions is altered.  Hence the set of functions is always called together.

# precmd ()   - Executed  before each prompt.  Note that precommand functions are not re-exe‐
#   cuted simply because the command line is redrawn, as  happens,  for  example,
#   when a notification about an exiting job is displayed.

# preexec ()  - Executed  just after a command has been read and is about to be executed.  If
#   the history mechanism is active (regardless of whether the line was discarded
#   from  the  history  buffer),  the string that the user typed is passed as the
#   first argument, otherwise it is an empty string.   The  actual  command  that
#   will  be  executed  (including  expanded  aliases) is passed in two different
#   forms: the second argument is a single-line, size-limited version of the com‐
#   mand  (with  things like function bodies elided); the third argument contains
#   the full text that is being executed.

# zshaddhistory () - Executed when a history line has been read interactively, but  before  it  is
#   executed.  The sole argument is the complete history line (so that any termi‐
#   nating newline will still be present).

# zshexit () - Executed  at  the point where the main shell is about to exit normally.  This
#   is not called by exiting subshells, nor when the exec precommand modifier  is
#   used  before  an  external  command.  Also, unlike TRAPEXIT, it is not called
#   when functions exit.

# EXPORTING FUNCTIONS
# If you are using ksh or zsh:

# You can use the environment variable FPATH, wherein you can place all your functions.

# If FPATH is set on an interactive interpreter, and a command or function is not found in the current shell environment or the PATH, the directories listed there are searched for the existence of a file named after the missing command. If one is found, it is sourced in the current shell environment, and expected to define the function.

# So, you can place all your functions in a location in FPATH, and child scripts will also be able to find it.

# You can use the autoload command in shell scripts to load the functions you require:

# autoload fun_a fun_b
# In zsh, autoload is required for FPATH to work. In ksh and its close relatives, I believe it simply causes functions defined in FPATH to override regular command in your PATH, as they would if defined directly.

# Some details on FPATH and autoload:

# http://docstore.mik.ua/orelly/unix3/upt/ch29_13.htm
# http://users.speakeasy.net/~arkay/216-7.4KshFunctions.html

### suffix aliases - matches the end of a filename to tie it to a program
# alias -s md=sublime_text
### now simply typing <filename>.md will open it in sublime_text

### global aliases - replaced anywhere in a command line
# alias -g ...='../..'
### now you can: cd ...

### built in less-alike, just type this to read textfilename
# <textfilename

