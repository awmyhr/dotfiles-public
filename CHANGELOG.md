# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) 
and this project tries to adhere to [Semantic Versioning](http://semver.org/).

Most files will have their own version number, project release numbers are 
more of a suggestion than anything else...

---

## TODO
- refactor variables for uniformity
    - c_  colors
    - ec_ error codes
    - f_  file names
    - t_  terminal request/setting strings (including appropriate escaping)
    - tc_ terminal color strings           (including appropriate escaping)
    - s_  single character symbols
    - v_  version string
    - IS_ Flag to describe an environment (i.e., IS_BASH)
    - ISSET_ Flag to confirm a library has been loaded
    - PROG_  Holds which program to use for a service (i.d., PROG_BECOME='sudo')
- re-work colors to enable themeing
- implement said themeing 
- optimize calling of variables/functions to take advantage of login vs subshells
- optimize functions for bash and zsh
- 'build' system, probably using make

---

## [Unreleased]
### Added
- tmux.conf
- loginspeedtest script to test speed of profiles upon login 

### Changed
- alias 'ssu' now requires a user name, use 'ssr' for sudo to root
- testusers:
    - added meta info variables
    - output improved
    - now tests for too few/too many arguments

### Deprecated

### Removed

### Fixed
-'type <command>' was not working as expected in zshrc, this has been replaced
with 'whence -w <command>'. Also, check for existance of command before doing a
compdef

### Security

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

