" ------------------------------------------------------------------------------------
" Plugin Installation 
" ------------------------------------------------------------------------------------

" Define Required Plugins
call plug#begin("$VIMFILES/plugged")

	" PaperColor Theme https://vimawesome.com/plugin/papercolor-theme
	Plug 'nlknguyen/papercolor-theme'

	" Colorfull Status Bar 
	Plug 'itchyny/lightline.vim'

	" The Nerd Tree https://vimawesome.com/plugin/nerdtree-red
	Plug 'scrooloose/nerdtree'

	" Fugitive (Git Commands) https://vimawesome.com/plugin/fugitive-vim
	Plug 'tpope/vim-fugitive'

	" Git Gutter (show diff) https://vimawesome.com/plugin/vim-gitgutter
	Plug 'airblade/vim-gitgutter'

	" Surround (quoting/parenthesizing made simple) https://vimawesome.com/plugin/surround-vim
	Plug 'tpope/vim-surround'

	" delimitmate (auto close stuff) https://vimawesome.com/plugin/delimitmate
	Plug 'raimondi/delimitmate'

	" Syntax checking hacks for vim https://vimawesome.com/plugin/syntastic
	Plug 'scrooloose/syntastic'

	" Syntax for Rust w/Syntastic https://vimawesome.com/plugin/rust-vim-superman
	Plug 'rust-lang/rust.vim'

	" Syntax for Powershell https://vimawesome.com/plugin/vim-ps1
	Plug 'pprovost/vim-ps1'
	
	" Nix syntax highlighting
	Plug 'lnl7/vim-nix'
	
	" Org Mode
	Plug 'jceb/vim-orgmode'
	
	" Ansible Common Files https://github.com/pearofducks/ansible-vim
	Plug 'pearofducks/ansible-vim'

call plug#end()

" Install Missing Plugins
if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
	autocmd VimEnter * PlugInstall --sync | q
endif

" ------------------------------------------------------------------------------------
" Plugin Settings
" ------------------------------------------------------------------------------------

" Paper Color Theme Settings
let g:PaperColor_Theme_Options = {
  \   'theme': {
  \     'default.dark': {
  \       'transparent_background': 1
  \     }
  \   }
  \ }

" Syntastic Settings
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Syntax Powershell Settings
let g:ps1_nofold_blocks = 1
