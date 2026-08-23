" --- GENERAL QUALITY OF LIFE ---
set nocompatible            " Use Vim defaults instead of strict vi compatibility
syntax on                   " Enable syntax highlighting
filetype plugin indent on   " Enable filetype detection, built-in plugins, and custom indenting
set number                  " Show line numbers
"set relativenumber          " Show relative line numbers for faster jumping
set mouse=a                 " Enable mouse support in all modes
set clipboard=unnamedplus   " System clipboard sharing (requires +clipboard)
set hidden                  " Hide buffers instead of closing them when opening a new file
set encoding=utf-8          " Use standard UTF-8 text encoding

" --- SEARCH AND NAVIGATION ---
set hlsearch                " Highlight search matches
set incsearch               " Jump to matches as you type
set ignorecase              " Ignore case when searching...
set smartcase               " ...unless the search query contains uppercase letters
set path+=**                " Search recursively down directories (enables powerful :find)
set wildmenu                " Visual autocomplete menu for command-line mode

" --- TABS AND INDENTATION ---
set tabstop=4               " Number of visual spaces per TAB
set softtabstop=4           " Number of spaces a TAB counts for while editing
set shiftwidth=4            " Number of spaces used for autoindentation
"set expandtab               " Convert TABs into spaces
set autoindent              " Copy indent from current line when starting a new line
set smartindent             " Insert indents automatically where appropriate

" --- PERFORMANCE AND BACKUPS ---
set nobackup                " Disable backup files
set noswapfile              " Disable swap files
set updatecount=0           " Do not write swap files to disk
set history=1000            " Remember more commands and search history

" --- BUILT-IN PLUGINS CONFIG ---
let g:netrw_banner = 0       " Hide the bloat banner in Netrw (built-in file explorer)
let g:netrw_liststyle = 3   " Use a clean tree view structure in Netrw
let g:netrw_browse_split = 4 " Open files from Netrw in a previous window

