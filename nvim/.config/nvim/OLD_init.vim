set nocompatible
let g:mapleader = "\<Space>"    " set leader key

" ==================================================================================================
" ### Plugins ###
" ==================================================================================================
call plug#begin()

" Color scheme
Plug 'gruvbox-community/gruvbox'

call plug#end()

" ==================================================================================================
" ### Settings ###
" ==================================================================================================
" Enable gruvbox color scheme
colorscheme gruvbox
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_italic=0

syntax enable                   " Enables syntax highlighing
set hidden                      " Required to keep multiple buffers open multiple buffers
set encoding=utf-8              " The encoding displayed
set pumheight=10                " Makes popup menu smaller
set fileencoding=utf-8          " The encoding written to file
set ruler                       " Show the cursor position all the time
set cmdheight=2                 " More space for displaying messages
set iskeyword+=-                " treat dash separated words as a word text object"

set t_Co=256                    " Support 256 colors
set background=dark             " tell vim what the background color looks like

set backspace=indent,eol,start  " Better backspace behavior
" set nohlsearch                  " Turn off search highlighting between searches
set ignorecase                  " Ignore case in searches with only lower case search string
set smartcase                   " Make search case sensitive when there are upper case in search
set incsearch                   " Enable searching as you type

set mouse=a                     " Enable your mouse
set splitbelow                  " Horizontal splits will automatically be below
set splitright                  " Vertical splits will automatically be to the right
set conceallevel=0              " So that I can see `` in markdown files

set textwidth=100
set tabstop=4                   " Insert 4 spaces for a tab
set softtabstop=-1              " Behave the same as tabstop
set shiftwidth=0                " Behave the same as tabstop
set expandtab                   " Converts tabs to spaces
set smarttab                    " Makes tabbing smarter will realize you have 2 vs 4
set smartindent                 " Makes indenting smart
set autoindent                  " Good auto indent
set nowrap                      " Display long lines as just one line

set laststatus=2                " Always display the status line
"set relativenumber              " Relative line numbers
set number                      " Line numbers
"set cursorline                  " Enable highlighting of the current line
set showtabline=2               " Always show tabs
"set noshowmode                  " We don't need to see things like -- INSERT -- anymore

set noswapfile                  " No swap file
set nobackup                    " This is recommended by coc
set nowritebackup               " This is recommended by coc
set updatetime=300              " Faster completion
set timeoutlen=500              " By default timeoutlen is 1000 ms
set formatoptions-=cro          " Stop newline continution of comments
set clipboard=unnamedplus       " Copy paste between vim and everything else
set autochdir                   " Your working directory will always be the same

" Permanent undo
set undodir=~/.vimdid
set undofile

highlight OverLength ctermbg=red ctermfg=white guibg=#592929    " Highlight text outside bounds
match OverLength /\%101v.\+/                                    " Column width

" ==================================================================================================
" ### Keybinds ###
" ==================================================================================================
nmap Q <Nop>                        " 'Q' in normal mode enters Ex mode. You almost never want this.
set noerrorbells visualbell t_vb=   " Disable audible bell because it's annoying.

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Move a line of text using ALT+[jk]
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

" ==================================================================================================
" ### Functions ###
" ==================================================================================================
" Remove any trailing whitespace
fun! TrimWhitespace()
  let l:view=winsaveview()
  execute '%s/\s\+$//e'
  call winrestview(l:view)
endfun

" Trim whitespace on save
autocmd! BufWrite * call TrimWhitespace()

" Auto-source when writing to init.vim
autocmd! BufWritePost $MYVIMRC source %

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
