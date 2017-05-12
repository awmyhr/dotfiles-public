# awmyhr's public dotfiles _(dotfiles-public)_

> Yet another .file repo...

## Table of Contents

- [Background](#background)
- [Install](#install)
- [Usage](#usage)
- [References](#references)
- [Maintainers](#maintainers)
- [Contribute](#contribute)
- [License](#license)

## Background

Over the many years I've worked with many systems. From the old TI/99-4a to the
newest release of Red Hat Enterprise Linux, I've strived to learn all I could not
only about what made each system unique, but also what made them similar.

It was in the late 80s/early 90s when I first encountered a POSIX shell on an 
Amiga 500 (or 1200? Had both, can't remember when exactly I found the shell),
and that is also where I learned about dotfiles.

Since then, I have borrowed, built, re-built, cobbled toghether, maintained and 
moved my dotfile collection with me where ever I went. At different times I've 
used csh, tcsh, bash, ksh, zsh, and many others on top of over a dozen different
UNIX/UNIXlike systems; always finding ways to bring my perferred environment with
me, as well as ways to improve it. I've also gone through many different 
approaches, like trying to have all my shell profile scripts point to one single
file.

Though it is likely there's no vistiges of that early stuff left, if I had
maintanied this code in a repository the whole time, one could trace the 
evolution of its current state back to the earliest days on that Amiga.

I have dipped into source control every now and then. First with rcs, then moving
to svn, darcs, and now git. Unfortunately, due to many factors, there is not much
continuity from one to the next. Hopefully now that can change. Even this repo is
not my first attempt at putting this code out there publicly, but I think I've 
learned enough from previous attempts that this one will be more successful.

I've dicided to use this particular 'fresh' start to re-version the entire project 
as '1.0' and call everything before it an extended alpha/beta test. Since this
project is a collection of things I will be using date-stamp versioning for the
whole thing, though individual files will use semantic versioning when it makes
sense. 

Feel free to poke around, use stuff, learn stuff, teach me stuff, and share alike...

## Install

Initialize ssh keys:
    
    ssh-keygen -o -t ed25519 -f ~/.ssh/id_ed25519 -C "${USER}@${HOSTNAME} secure"
    ssh-keygen -o -t rsa -b 4096 -f ~/.ssh/id_rsa -C "${USER}@${HOSTNAME} compat"

(Note: -o is not supported in OpenSSH prior to 6.5)

#### Outside Projects

Several outside projects are potentially installed into ~/bin (and other $HOME
locations) during a play run, including:

- [ack2](https://github.com/petdance/ack2/)
- [dircolors-solarized](https://github.com/seebi/dircolors-solarized/)
- [dstat](https://github.com/dagwieers/dstat/)
- [inxi](https://github.com/smxi/inxi/)
- [iotop](http://guichaz.free.fr/iotop/)
- [ps_mem](https://github.com/pixelb/ps_mem/)
- [screenFetch](https://github.com/KittyKatt/screenFetch)

This is accomplished by downloading the needed files into a cache directory,
then copying them out to the target system(s). All of these are handled by
the 'toolbelt' role.

## Usage

There are a few variables which can (or should) be set:

    ssh_keys (roles/common/defaults/main.yml)
        If you want to distribute more than the two defaults created in Install.

    git_user (roles/git/defaults/main.yml)
        Primarily for .gitconfig. Defaults to ansible_user.

    git_email (roles/git/defaults/main.yml)
        Primarily for .gitconfig. No reasonable default, please set this.

    system_control (host_vars/localhost and group_vars/all)
        Anotates whether one (politically) is able to install whatever on a system.
        Currently the only value used is 'full', which is the default for localhost.
        The group 'all' defaults to 'user', which may be used in the future.
        Note: this has no barring on if one is able to 'become' on a system.

    system_devenv (host_vars/localhost and group_vars/all)
    system_devenv_site (host_vars/localhost and group_vars/all)
        Used to determine if outside and/or inside development related settings
        are included (for example, ssh configs for GitHub/Bitbucket). These
        both default to True for localhost and False for all.

One should keep in mind that playbook group\_vars/host\_vars override ones
inventory settings. ([See precedence rules here.](http://docs.ansible.com/ansible/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable))

## References

This project attempts to use/borrow from concepts and ideas I've seen from across
the Internet, and in the course of my career/life. There is simply no way I can 
effectively credit all I have been influenced by, nor the source of everything
I've used (though I do try to leave comments in the code when I can).

There are also a few projects that heavily influenced my current direction.
For reference, here are just some:

- [Semantic Versioning](http://semver.org/)
- [Keep A Changelog](http://keepachangelog.com/en/0.3.0/)
- [The Solarized Project](https://github.com/altercation/solarized)
- [base16](http://chriskempson.com/projects/base16/)
- [standard-readme](https://github.com/RichardLitt/standard-readme)

## Maintaniers

- awmyhr <awmyhr@gmail.com>

## Contribute

PRs will be reviewed.

## License

Apache-2.0 © 2017, awmyhr
