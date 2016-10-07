# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) 
and this project tries to adhere to [Semantic Versioning](http://semver.org/).

Most files will have their own version number, project release numbers are 
more of a suggestion than anything else...

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
- re-work colors to enable themeing
- implement said themeing 
- optimize calling of variables/functions to take advantage of login vs subshells
- optimize functions for bash and zsh
- 'build' system, probably using make

## [Unreleased]
### Added

### Changed

### Deprecated

### Removed

### Fixed

### Security

## [1.2.0] - 2016-10-07
### Added
- real .zlogin/.zlogout
- .zshenv, .zprofile (which is read *before* .zshrc, .zlogin is read *after*)
- zsh profile files are now considered released

### Changed
- bring .zshrc in-line with previous work
- all zsh profile files moved into .zshrc.d except .zshenv, which tells zsh where to go

### Fixed
- fixed loading BASHD ancillary scripts
- put bash login stuff in the bash_login file

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

### Removed
- removed (mis-)use of SHELL
- no longer trying to second-guess system profiles (for PATH, etc)

## [1.0.0] - 2016-10-04
### Added
- .profile is now considered 'released' and is at v3.0.0
- the .shell.d tree is now considered 'released' and is at v1.0.0
- other bash/zsh files are considered 'alpha'
- all other depends/, src/ and tools/ files are not considered for this release

