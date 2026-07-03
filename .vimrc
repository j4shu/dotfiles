" misc
syntax on
set nocompatible
set undofile
set undodir=~/.vim/undodir
set noswapfile
set clipboard=unnamedplus
set mouse=a
set ttimeoutlen=50
set confirm

" ui
set number
set nowrap
set background=dark
set laststatus=2
set noshowcmd

" tabs/indents
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent
set copyindent

" search
set ignorecase
set smartcase
set noincsearch
set hlsearch
set nowrapscan

" editing
set virtualedit=block

" maps
let mapleader = ' '
nnoremap <leader>tw :setlocal wrap!<CR>
nnoremap ; :
nnoremap j gj
nnoremap k gk
nnoremap <Esc> :nohlsearch<CR>
nnoremap U <C-r>
nnoremap <CR> "_ciw
nnoremap <expr> dd getline('.') =~ '^\s*$' ? '"_dd' : 'dd'
nnoremap x "_x
xnoremap x "_x
nnoremap Y y$
noremap E g$