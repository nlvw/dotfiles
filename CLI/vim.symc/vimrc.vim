" ------------------------------ "
" Set Paths and Needed Variables "
" ------------------------------ "

" Enable New VIM Syntax/Settings
set nocompatible

" Set Lunix Paths
if has('unix')
	set runtimepath^=~/.config/vim

	if v:version > 800
		set packpath^=~/.config/vim
	endif
elseif has('win32') || has('win64')
	set runtimepath^=$USERPROFILE\.vim
	set packpath^=$USERPROFILE\.vim
endif

" Create Variable For Vim Config Directory
let $VIMFILES=split(&rtp,",")[0]

" Change mapleader
nnoremap <SPACE> <Nop>
let mapleader=" "

" ------------------------------ "
" Source Additional Config Files "
" ------------------------------ "
runtime plugins.vim

" -------------------- "
" Default Vim Settings "
" -------------------- "

" Set Themeing
set background=dark
silent! colorscheme PaperColor

" Enable syntax highlighting
syntax on

" Disable audio bell / beebing tone
if v:version > 800
	set belloff=all
endif

" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard^=unnamed,unnamedplus

" Reload Settings
nnoremap <Leader>r :source $VIMFILES/vimrc.vim<CR>

" Keymap for OS clipboard
vnoremap <C-c> "+y
map <C-v> "+P

" Keymap for Primary Selection Clipboard (Linux)
vnoremap <C-C> "*y :let @+=@*<CR>

" Enhance command-line completion
set wildmenu

" Allow cursor keys in insert mode
"set esckeys

" Remap Escape Key Functionality
inoremap jk <Esc>
onoremap jk <Esc>
inoremap fd <Esc>
vnoremap fd <Esc>
onoremap fd <Esc>

" Line Navigation
nnoremap <S-h> <Home>
nnoremap <S-l> <End>

" Tab Navigation
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
nnoremap <C-j> :tabprevious<CR>
nnoremap <C-h> :tabprevious<CR>
nnoremap <C-k> :tabnext<CR>
nnoremap <C-l> :tabnext<CR>

" Buffer Navigation
nnoremap <Leader>l :bnext<CR>
nnoremap <Leader>h :bprev<CR>
nnoremap <Leader>q :bd<CR>

" Run Line In Bash
nmap <F8> :exec '!'.getline('.')

" Allow backspace in insert mode
set backspace=indent,eol,start

" Optimize for fast terminal connections
set ttyfast

" Add the g flag to search/replace by default
"set gdefault

" Use UTF-8 without BOM
set encoding=utf-8 nobomb

" Don’t add empty newlines at the end of files
set binary
set noeol

" Centralize backups, swapfiles, viminfo, and undo history
if !isdirectory("$VIMFILES")
 set backupdir=$VIMFILES/backups
	set directory=$VIMFILES/swaps
	if exists("&undodir")
		set undodir=$VIMFILES/undo
	endif
	if !has('nvim')
		set viminfo+=n$VIMFILES/backups/viminfo
	endif
endif
" Don’t create backups when editing files in certain directories
set backupskip=/tmp/*,/private/tmp/*

" Respect modeline in files
set modeline
set modelines=4

" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure

" Enable line numbers
set number

" Highlight current line
set cursorline

" Make tabs as wide as two spaces
set tabstop=2

" Use tabs, not spaces
set noexpandtab

" Set default shiftwidth
set shiftwidth=2

" Show “invisible” characters
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
set list

" Highlight searches
set hlsearch

" Ignore case of searches
set ignorecase

" Highlight dynamically as pattern is typed
set incsearch

" Always show status line
set laststatus=2

" Enable mouse in all modes
if v:version > 800
	set mouse=a
else
	set mouse=
endif

" Disable error bells
set noerrorbells

" Don’t reset cursor to start of line when moving around.
set nostartofline

" Show the cursor position
set ruler

" Don’t show the intro message when starting Vim
set shortmess=atI

" Show the current mode
set showmode

" Show the filename in the window titlebar
set title

" Show the (partial) command as it’s being typed
set showcmd

" Start scrolling three lines before the horizontal window border
set scrolloff=3

" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" Trim trailing whitespace
function! TrimWhitespace()
	" trailing whitespaces have meaning in markdown so don't try there
	if &filetype!='markdown'
		let l:save = winsaveview()
		%s/\s\+$//e
		call winrestview(l:save)
	endif
endfunction
command! TrimWhitespace call TrimWhitespace()
noremap <leader>ss :call TrimWhitespace()<CR>

" Automatic commands
if has("autocmd")
	" Enable file type detection
	filetype on

	" Disable ro formatoptions
	autocmd BufNewFile,BufRead * setlocal formatoptions-=ro

	" Enable Tab Expansion in Python/yaml
	autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
	autocmd Filetype yaml setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
	autocmd Filetype yml setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2

	" Treat .json files as .js
	autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript

	" Treat .md files as Markdown
	autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
endif