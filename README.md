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
as '1.0.0' and call everything before it an extended alpha/beta test. Feel free
to poke around, use stuff, learn stuff, teach me stuff, and share alike...

## Install

Initial ssh keygen:
    
    ssh-keygen -o -t ed25519 -f ~/.ssh/id_ed25519 -C "Non-backward compat base key"
    ssh-keygen -o -t rsa -b 4096 -f ~/.ssh/id_rsa -C "Backward compat base key"

(Note: -o is not supported in OpenSSH prior to 6.5)

## Usage

```
```

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

PRs accepted.

## License

{{ software_license|default("TODO: CHANGEME", true) }} © {{ software_copyright|default("TODO: CHANGEME", true) }}

