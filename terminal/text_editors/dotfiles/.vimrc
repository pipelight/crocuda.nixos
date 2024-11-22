" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" Set shift width to 4 spaces.
set shiftwidth=4

" Set tab width to 4 columns.
set tabstop=4

" Do not let cursor scroll below or above N number of lines when scrolling.
set scrolloff=10

" While searching though a file incrementally highlight matching characters as you type.
set incsearch

" Ignore capital letters during search.
set ignorecase

" Override the ignorecase option if searching for capital letters.
" This will allow you to search specifically for capital letters.
set smartcase

" Show partial command you type in the last line of the screen.
set showcmd

" Show the mode you are on the last line.
set showmode

" Show matching words during a search.
set showmatch

" Use highlighting when doing a search.
set hlsearch

" Set the commands to save in history default number is 20.
set history=1000



" Colemak-DH keybindings
" disabled
nnoremap <C-h> <Nop>
nnoremap <C-j> <Nop>
nnoremap <C-k> <Nop>
nnoremap <C-l> <Nop>

" directions
nnoremap m h
vnoremap m h

nnoremap n j
vnoremap n j

nnoremap e k
vnoremap e k

nnoremap i l
vnoremap i l

" insert
nnoremap l i
nnoremap L I

" select
nnoremap vi vl
nnoremap vn vj
