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

    " Lean & mean status/tabline for vim that's light as air; REQ 7.2 (7.3 perferred)
    " https://github.com/vim-airline/vim-airline
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

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
" Status Line Format
" ------------------------------------------------------------------
" set statusline=%f\ %h%w%m%r\ %=%(%l,%c%V\ %=\ (%P)%) " close to default
" set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P     " another close default
set statusline=[%{strlen(&fenc)?&fenc:&enc}]%r%h%w\ %n:%<%f%m\ %y[%{&ff}]%=%(l:%l\/%L\ c:%c\ %=\ %P%)
" Add %{fugitive#statusline()} to 'statusline' to get an indicator with the current branch in (surprise!) your statusline.
" set statusline=[%{strlen(&fenc)?&fenc:&enc}]%r%h%w\ %n:%<%f%m\ %y[%{&ff}]\ %{fugitive#statusline()}%=%(l:%l\/%L\ c:%c\ %=\ %P%)

" ------------------------------------------------------------------
" Airline Settings
" ------------------------------------------------------------------
let g:airline_theme='solarized'

let g:airline_section_b = '%{fugitive#statusline()}'
let g:airline_section_c = '%t'

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_left_sep = '▶'
let g:airline_left_alt_sep = ''
let g:airline_right_sep = '◀'
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = '☰'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.readonly = ''
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.whitespace = 'Ξ'

" define short text to display for each mode (i.e, Normal, Insert, Command, etc)
let g:airline_mode_map = {
    \ '__' : '-',
    \ 'n'  : 'N',
    \ 'i'  : 'I',
    \ 'R'  : 'R',
    \ 'c'  : 'C',
    \ 'v'  : 'V',
    \ 'V'  : 'V',
    \ '^V' : 'V',
    \ 's'  : 'S',
    \ 'S'  : 'S',
    \ '^S' : 'S',
    \ }

