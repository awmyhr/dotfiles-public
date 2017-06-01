# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) 
and this project tries to adhere to [Semantic Versioning](http://semver.org/)
for files, but will use date-stamp versioning for the overall project.

---

## TODO
- refactor variables for uniformity & put them in a namespace
    - DF_       default namespace
    - DFc_      colors
    - DFec_     error codes
    - DFf_      file names
    - DFmeta_   meta vars
    - DFos_     OS information vars
    - DFs_      single character symbols
    - DFsys_    System (hardware) information vars
    - DFt_      terminal request/setting strings (including appropriate escaping)
    - DFtc_     terminal color strings           (including appropriate escaping)
    - DFv_      version string
    - DF_IS_    Flag to describe an environment (i.e., IS_BASH)
    - DF_ISSET_ Flag to confirm a library has been loaded
    - DF_PROG_  Holds which program to use for a service (i.d., PROG_BECOME='sudo')
- re-work colors to enable themeing
- implement said themeing 
- convert functions to use FPATH in zsh/ksh
- setup FPATH emulation for bash/etc
- optimize calling of variables/functions to take advantage of login vs subshells
- optimize functions for specific shells (esp bash and zsh)
- optimize various checks based on environment (i.e., don't check for Linuxy things on a Solarisish syste)
- standardize prompt building accross shells
- prompt should(?) take queue from vim statusline
- audit all variables to ensure there is no code in them per [BashFAQ 050](http://mywiki.wooledge.org/BashFAQ/050)
unless there's a gosh-darned-good reason for it.
- setup test (linux) environments using Docker
- come up with non-linux test environment solution
- add Ansible playbook to create a skel directory for the useradd command
- add logging throughout (log to ~/var/log/)

---

## [Unreleased]
### Added

### Changed

### Deprecated

### Removed

### Fixed

### Security

---

## [2017.05.12]
### Added
- Download several tools and push to home directoy
    (ack2, dircolors-solarized, dstat, inxi, iotop, ps_mem, screenfetch)
- Now set PERL5LIB and PYTHONPATH

### Changed
- many roles now depend on common to create base directories
- login now runs inxi

### Removed
- No longer installing system-level things unless really necessary
- inxi no longer its own role, installation moved to toolbelt, 
  config file moved to misc

### Fixed
- VIM complained about colorscheme not existing

---

## [2017.05.05]
### Added
- project has been transformed into an Ansible project (this is huge)
- ssh-keycheck will test ssh key strength upon login
- Bash & Zsh now have a dynamic 'dashboard' for prompts
- tmux/vim/inxi/ssh/xonsh/CodeClimate config files added
- loginspeedtest script to test speed of profiles upon login
- variables to hold default editor/vcs version, and display in greeting
- list of window roles & types which should float in i3 
- minorly decorated PS2 for zsh/bash/posix
- precmd for zsh to display user@host:pwd in terminal tital bar

### Changed
- project is now Apache 2.0 licensed
- project has been radically re-organized to fit the Ansible workflow
- overall project version changed to datestamp versioning
- alias 'ssu' now requires a user name, use 'ssr' for sudo to root
- testusers:
    - added meta info variables
    - output improved
    - now tests for too few/too many arguments
- inputrc overhauled, considered released
- small tweak to the way branch name in git is found
- reduced prompt call outs to git down to 1, and only if needed
- all '.gitdir' have been chenged to '.keepdir'
- many tweaks to ouput strings/formats

### Removed
- removed all subtrees, will simply reference them in a doc

### Fixed
-'type <command>' was not working as expected in zshrc, this has been replaced
with 'whence -w <command>'. Also, check for existance of command before doing a
compdef
- git prompt status fully functional in Bash
- TIMEFORMAT was messed up

---

## [1.3.2] - 2016-10-17
### Added
- git-flow cheatsheet for SublimeText "Cheatsheet" plugin
- a bunch of new (hopefully useful) aliases
- extract() to act as single entry point for several unarchivers
- mans() to search a term in a manpage

### Changed
- tweaks/additions to ps related aliases
- for exported functins, use a command -v instead of letting posix fail
- removed unneeded call to ls in for loops for bashrc/zshrc

### Removed
- splitvar() is gone, too fragile see sysinfo protion of shellinit for replacement

### Fixed
- rolled back changes in git package which somehow found their way into the 
wrong place (i.e., master and develop branches)

---

## [1.3.1] - 2016-10-14
### Fixed
- splitvar() declared a local variable (not supported in some shells)
- whereis alias should be set if whereis *doesn't* exist, and the -all flag
is not supported by some shells, so -a only

---

## [1.3.0] - 2016-10-13
### Added
- time output formating for bash/zsh
- auto-time and login/logout reporting for zsh
- lib/aliases file [considered released]
- platform/Linux file [considered released]
- package/yum file
- install_ack -- installs single-file version of ack (as opposed to repo package)
- function psz (ps grep for zombies -- used to be an alias)
- function mymemuse (report current users memory use)
- s_(shellname) vars for prompts, etc
- git package done for prompts [considered released]

### Changed
- install_SublimeText renamed and overhauled
- all VCS_ symbol vars have been renamed to s_
- overhauled .gitconfig, including adding aliases
- bash/zsh use $OSTYPE for vanilla prompt instead of calling out to uname
- now calling _git_prompt from bash -- however, this feature is not working 100%

### Removed
- .profile.d/alias.general
- .profile.d/profile.Linux

### Fixed
- dusort alias had some issues w/directories which didn't match both globs
- no longer blanket exporting all functions in Bash, instead these are explicitly
exported when declared via 'declare -fx'. POSIX shells will complain, but those
complaints are sent to /dev/null and will be dealt with there...

---

## [1.2.0] - 2016-10-07
### Added
- real .zlogin/.zlogout
- .zshenv, .zprofile (which is read *before* .zshrc, .zlogin is read *after*)
- all zsh profile files [considered released]

### Changed
- bring .zshrc in-line with previous work
- all zsh profile files moved into .zshrc.d except .zshenv, which tells zsh where to go

### Fixed
- fixed loading BASHD ancillary scripts
- put bash login stuff in the bash_login file

---

## [1.1.0] - 2016-10-06
### Added
- a real .bash_profile [considered released]
- .bash_logout [considered released]
- .profilerc (split out pertinent parts from .profile)
- .shell.d/lib/exitcodes (set vars for common codes) [considered released]
- testenv/testusers (creates/removes groups of test users) [considered released]
- .bashrc exports functions for subshells [considered released]

### Changed
- more ISSET_ variables
- many minor functions/variables/settings moved to more sensible locations

### Deprecated
- all .profile.d/[alias|profile].* files

### Removed
- removed (mis-)use of SHELL
- no longer trying to second-guess system profiles (for PATH, etc)

---

## [1.0.0] - 2016-10-04
### Added
- .profile is now considered 'released' and is at v3.0.0
- the .shell.d tree is now considered 'released' and is at v1.0.0
- other bash/zsh files are considered 'alpha'
- all other depends/, src/ and tools/ files are not considered for this release

