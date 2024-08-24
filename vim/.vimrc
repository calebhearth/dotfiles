" Environment
" Basics
set nocompatible        " must be first line
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.branch = ''
" let g:airline_symbols.colnr = ' ℅:'
let g:airline_symbols.readonly = ''
" let g:airline_symbols.linenr = ' :'
" let g:airline_symbols.maxlinenr = '☰ '
let g:airline_symbols.dirty = '⚡'
let g:airline_section_z = '%p%% %1:%v'

" Bundles
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

if has ("unix") && "Darwin" != system("echo -n \"$(uname)\"")
  " on Linux use + register for copy-paste
  set clipboard=unnamedplus
else
  " one mac and windows, use * register for copy-paste
  set clipboard=unnamed
endif
"

" General
set background=dark         " Assume a dark background
if !has('gui')
  "set term=$TERM          " Make arrow and other keys work
endif
filetype plugin on   " Automatically detect file types.
syntax on                   " syntax highlighting
set mouse=a                 " automatically enable mouse usage
scriptencoding utf-8

set shortmess+=filmnrxoOtTI      " abbrev. of messages (avoids 'hit enter')
set viewoptions=folds,options,cursor " better unix / windows compatibility
set sessionoptions=folds,options,buffers,globals,resize " better unix / windows compatibility
set virtualedit=onemore         " allow for cursor beyond last character
set history=1000                " Store a ton of history (default is 20)
set nospell                     " spell checking off. OMG FUCK SPELLCHECK. usually.
set spellfile=~/.vim/spell/en.utf-8.add
set hidden                      " allow buffer switching without saving

" Setting up the directories
set backup                      " backups are nice ...
if has('persistent_undo')
  set undofile                "so is persistent undo ...
  set undolevels=1000         "maximum number of changes that can be undone
  set undoreload=10000        "maximum number lines to save for undo on a buffer reload
endif

" Vim UI
colorscheme detailed
set tabpagemax=15               " only show 15 tabs
set showmode                    " display the current mode
set colorcolumn=81,101,121
set cursorline                  " highlight current line

if has('cmdline_info')
  set ruler                   " show the ruler
  set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " a ruler on steroids
  set showcmd                 " show partial commands in status line and
  " selected characters/lines in visual mode
endif

if has('statusline')
  set laststatus=2

  " Broken down into easily includeable segments
  set statusline=%<%f\    " Filename
  set statusline+=%w%h%m%r " Options
  set statusline+=%{fugitive#statusline()} "  Git Hotness
  set statusline+=\ [%{&ff}/%Y]            " filetype
  set statusline+=\ [%{getcwd()}]          " current dir
  set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
endif

set backspace=indent,eol,start  " backspace for dummies
set linespace=0                 " No extra spaces between rows
set number                      " Line numbers on
set showmatch                   " show matching brackets/parenthesis
set matchtime=5                 " duration to show matching brace (1/10 sec)
set incsearch                   " find as you type search
set nohlsearch                  " don't highlight searches
set winminheight=0              " windows can be 0 line high
set ignorecase                  " case insensitive search
set smartcase                   " case sensitive when uc present
set tagcase=match
set wildmenu                    " show list instead of just completing
set wildmode=list:longest,full  " command <Tab> completion, list matches, then longest common part, then all.
set wildignore+=.git/*,*/tmp/*,*.swp
set whichwrap=b,s,h,l,<,>,[,]   " backspace and cursor keys wrap to
set scrolljump=5                " lines to scroll when cursor leaves screen
set scrolloff=3                 " minimum lines to keep above and below cursor
set foldenable                  " auto fold code
set list
set nojoinspaces                " One space after ./?/! with join commands
set visualbell                  " shut the fuck up
set swapfile


" Formatting
set textwidth=80                " wrap at 80 chars by default
set nowrap                      " don't soft wrap long lines
set autoindent                  " indent at the same level of the previous line
set smartindent                 " be smart about it
set shiftwidth=2                " use indents of 2 spaces
set expandtab                   " tabs are spaces, not tabs
autocmd BufEnter * if &expandtab " Highlight problematic whitespace
  \ setlocal listchars=tab:»·,trail:·,extends:>
\ else
  " don't show tab characters if we're not expanding them
  \ setlocal listchars=tab:\ \ ,trail:·,extends:>
\ endif
set tabstop=2                   " an indentation every two columns
set softtabstop=2               " let backspace delete indent
set nosmarttab                  " fuck tabs
set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)

" Key (re)Mappings

let mapleader = ','

" Easier moving in tabs and windows
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_
map <C-L> <C-W>l<C-W>_
map <C-H> <C-W>h<C-W>_

" Wrapped lines goes down/up to next row, rather than next line in file.
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" Stupid shift key fixes
if has("user_commands")
  command! -bang -nargs=* -complete=file E e<bang> <args>
  command! -bang -nargs=* -complete=file W w<bang> <args>
  command! -bang -nargs=* -complete=file Wq wq<bang> <args>
  command! -bang -nargs=* -complete=file WQ wq<bang> <args>
  command! -bang Wa wa<bang>
  command! -bang WA wa<bang>
  command! -bang Q q<bang>
  command! -bang QA qa<bang>
  command! -bang Qa qa<bang>
endif

cmap Tabe tabe

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

" visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee % >/dev/null

" Adjust viewports to the same size
map <Leader>= <C-w>=

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

let b:match_ignorecase = 1

" OmniComplete
if has("autocmd") && exists("+omnifunc")
  autocmd Filetype *
        \if &omnifunc == "" |
        \setlocal omnifunc=syntaxcomplete#Complete |
        \endif
endif

highlight Pmenu  guifg=#000000 guibg=#F8F8F8 ctermfg=black ctermbg=Lightgray
highlight PmenuSbar  guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
highlight PmenuThumb  guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE
highlight CursorLine cterm=underline gui=underline guibg=NONE ctermbg=NONE
set termguicolors
let g:rainbow_guifgs = [
      \ '#626262',
      \ '#005f00',
      \ '#5f00d7',
      \ '#af0000',
      \ '#5faf87',
      \ '#d75f00',
      \ '#af0087',
      \ '#00afd7',
      \ ]

" some convenient mappings
inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <C-d>      pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
inoremap <expr> <C-u>      pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

" automatically open and close the popup menu / preview window
autocmd CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menu,preview,longest

" Ctags
set tags=./tags;/,~/.vimtags,./.git/tags

" ctrlp {
let g:ctrlp_working_path_mode = 2
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\.git$\|\.hg$\|\.svn$',
      \ 'file': '\.exe$\|\.so$\|\.dll$' }

"Configure ctrlp for SPEED
let g:ctrlp_use_caching = 700

" indent_guides
let g:indent_guides_auto_colors = 1
set ts=2 sw=2 et
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1

if &term == 'xterm' || &term == 'screen'
  set t_Co=256                 " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
endif

" Functions

function! InitializeDirectories()
  let separator = "."
  let parent = $HOME
  let prefix = '.vim'
  let dir_list = {
        \ 'backup': 'backupdir',
        \ 'views': 'viewdir' } ",
        " \ 'swap': 'directory' }

  if has('persistent_undo')
    let dir_list['undo'] = 'undodir'
  endif

  for [dirname, settingname] in items(dir_list)
    let directory = parent . '/' . prefix . dirname . "/"
    if exists("*mkdir")
      if !isdirectory(directory)
        call mkdir(directory)
      endif
    endif
    if !isdirectory(directory)
      echo "Warning: Unable to create backup directory: " . directory
      echo "Try: mkdir -p " . directory
    else
      let directory = substitute(directory, " ", "\\\\ ", "g")
      exec "set " . settingname . "=" . directory
    endif
  endfor
endfunction
call InitializeDirectories()

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

if executable("rg")
  set grepprg=rg\ --color=never
  let g:ctrlp_user_command="rg %s --files --color=never --glob ''"
  let g:ctrlp_use_caching=0
elseif executable("ag")
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrlp_user_command="ag %s --nocolor --nogroup"
  let g:ctrlp_use_caching=0
elseif executable("git")
  set grepprg=git\ grep
end

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" vim-rspec mappings
let test#strategy = {
      \ 'nearest': "dispatch",
      \ 'file': "dispatch_background",
      \ 'suite': "dispatch_background",
      \}
nnoremap <Leader>a :TestSuite<CR>
nnoremap <Leader>t :TestFile<CR>
nnoremap <Leader>s :TestNearest<CR>
nnoremap <Leader>l :TestLast<CR>
nnoremap <Enter> :w<CR> :Dispatch<CR>
autocmd BufWinEnter quickfix nnoremap <buffer> <Enter> <Enter>

let g:dispatch_tmux_pipe_pane=1

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

" use local vimrc if available
if filereadable(expand("./.vimrc.local"))
  source ./.vimrc.local
endif

set confirm
set exrc " enable per-directory .vimrc files
set secure " disable unsafe commands in local .vimrc files
