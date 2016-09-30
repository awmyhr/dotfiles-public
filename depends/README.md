# External Dependencies

These are projects I intend to use to some extent with little or no modification.
---
## Projects Subtreed

[EditorConfig plugin for VIM](https://github.com/editorconfig/editorconfig-vim)

    git subtree add --prefix depends/vim/editorconfig-vim git@github.com:editorconfig/editorconfig-vim.git master --squash

[The Solarized Project](https://github.com/altercation/solarized)

    git subtree add --prefix depends/solarized git@github.com:altercation/solarized.git master --squash

[Solarized .dir_colors](https://github.com/seebi/dircolors-solarized)

    git subtree add --prefix depends/dircolors git@github.com:seebi/dircolors-solarized.git master --squash

[Shell YAML config file parsing](https://github.com/pkuczynski/8665367)

    git subtree add --prefix depends/misc/parse_yaml git@gist.github.com:8665367.git master --squash

---
## Deprecated Subtrees (git rm'd)

[SublimeText "installer"](https://gist.github.com/dkd903/8ba3f51313c1781cc571)
I basically re-wrote this to the point it's unrecognizable

    git subtree add --prefix depends/misc git@gist.github.com:8ba3f51313c1781cc571.git master --squash
