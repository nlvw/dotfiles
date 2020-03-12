" ------------------------------------------------------------------------------------
" Plugin Installation 
" ------------------------------------------------------------------------------------

" Define Required Plugins
call plug#begin("$VIMFILES/plugged")

	" PaperColor Theme https://vimawesome.com/plugin/papercolor-theme
	Plug 'nlknguyen/papercolor-theme'

	" Colorfull Status Bar 
	"Plug 'itchyny/lightline.vim'

	" Status Bar
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'

	" Markdown Syntax (https://github.com/plasticboy/vim-markdown)
	Plug 'plasticboy/vim-markdown'

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
	
	" Ansible Common Files https://github.com/pearofducks/ansible-vim
	Plug 'pearofducks/ansible-vim'

call plug#end()

" Install Missing Plugins
if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
	autocmd VimEnter * PlugInstall
endif

" ------------------------------------------------------------------------------------
" Plugin Settings
" ------------------------------------------------------------------------------------

" Paper Color Theme Settings
let g:PaperColor_Theme_Options = {
	\		'theme': {
	\			'default.dark': {
	\				'transparent_background': 1
	\			}
	\		}
	\ }

" Status Line Settings
let g:airline_powerline_fonts = 0
let g:airline_theme='papercolor'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'default'

" Markdown Settings
let g:vim_markdown_folding_level = 6
let g:vim_markdown_toc_autofit = 1
let g:vim_markdown_conceal = 2
let g:vim_markdown_follow_anchor = 1
let g:vim_markdown_anchorexpr = "'<<'.v:anchor.'>>'"
let g:vim_markdown_autowrite = 1
let g:vim_markdown_no_extensions_in_markdown = 0
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_edit_url_in = 'tab'

" Syntastic Settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Syntax Powershell Settings
let g:ps1_nofold_blocks = 1

