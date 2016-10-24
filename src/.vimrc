" ----------------------------------------------------------------------
"   awmyhr
"   vimrc
"   Modified: 2016-10-24
" ----------------------------------------------------------------------

set nocompatible                " explicitly leave vi-compatibility mode
                                " (must be first as may impact options below)

" ----------------------------------------------------------------------
" Setup Plugin Support
" Download the vim-plug manager if it doesn't exist already
" ------------------------------------------------------------------
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" ----------------------------------------------------------------------
" Load Plugins
" ------------------------------------------------------------------
call plug#begin('~/.vim/plugged')

    " Solarized Color Scheme for Vim
    " https://github.com/altercation/vim-colors-solarized
    Plug 'altercation/vim-colors-solarized'

    " fugitive.vim: 'Best' Git wrapper
    " https://github.com/tpope/vim-fugitive
    Plug 'tpope/vim-fugitive'

    " A light and configurable statusline/tabline for Vim
    " https://github.com/itchyny/lightline.vim
    Plug 'itchyny/lightline.vim'

    " sensible.vim: universal set of defaults (hopefully) everyone can agree on
    " https://github.com/tpope/vim-sensible
    Plug 'tpope/vim-sensible'

    " EditorConfig -- only if python support detected;
    " https://github.com/editorconfig/editorconfig-vim
    if has('python')
        Plug 'editorconfig/editorconfig-vim'
    endif

call plug#end()

" ------------------------------------------------------------------
" Colors/Syntax
" ------------------------------------------------------------------
syntax enable

set background=dark
colorscheme solarized

" ------------------------------------------------------------------
" Default Environment
" (Some of this may be affected by vim-sensible or other plugins)
" ------------------------------------------------------------------
set encoding=utf-8      " unicode encoding by default
set title               " show title in terminal
set showcmd             " show the command being typed
set showmode            " show insert, replace, visual mode indicator
set laststatus=2        " always show the status line
set ruler               " always show current positions along the bottom

" ------------------------------------------------------------------
" Built-in Status Line Format
" ------------------------------------------------------------------
" set statusline=%f\ %h%w%m%r\ %=%(%l,%c%V\ %=\ (%P)%) " close to default
" set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P     " another close default

if has('fugitive')
    " Add %{fugitive#statusline()} to 'statusline' to get an indicator with the current branch in (surprise!) your statusline.
    set statusline=%{fugitive#statusline()}\ %r\ %n:%<%f%m\ %=[%{&ff}][%{strlen(&fenc)?&fenc:&enc}]%y\ %P%%\ %l:%c
else
    set statusline=%r\ %n:%<%f%m\ %=[%{&ff}][%{strlen(&fenc)?&fenc:&enc}]%y\ %P%%\ %l:%c
endif

" ------------------------------------------------------------------
" Lightline Status formats
" ------------------------------------------------------------------
"if has('lightline')
    set noshowmode
    let g:lightline={
        \ 'colorscheme': 'solarized',
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ],
        \             [ 'fugitive', 'readonly', 'filename', 'modified' ] ]
        \   },
        \ 'component': {
        \   'readonly': '%{&filetype=="help"?"":&readonly?"🔒":""}',
        \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
        \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
        \   },
        \ 'component_visible_condition': {
        \   'readonly': '(&filetype!="help"&& &readonly)',
        \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
        \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
        \   },
        \ }
"endif
