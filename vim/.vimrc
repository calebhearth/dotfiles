" Environment
" Basics
set nocompatible        " must be first line

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
filetype plugin on   " Automatically detect file types.
syntax on                   " syntax highlighting
set mouse=a                 " automatically enable mouse usage
scriptencoding utf-8

set shortmess=aoOtTWIF      " abbrev. of messages (avoids 'hit enter')
set viewoptions=folds,options,cursor " better unix / windows compatibility
set sessionoptions=folds,options,buffers,globals,resize " better unix / windows compatibility
set virtualedit=onemore         " allow for cursor beyond last character
set history=1000                " Store a ton of history (default is 20)
set nospell                     " spell checking off. OMG FUCK SPELLCHECK. usually.
set spellfile=~/.vim/spell/en.utf-8.add
set hidden                      " allow buffer switching without saving

" Setting up the directories
set backup                      " backups are nice ...
set backupdir=~/.local/state/nvim/backup//
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
set laststatus=2
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
set nofoldenable                " auto fold code
set list
set nojoinspaces                " One space after ./?/! with join commands
set visualbell                  " shut the fuck up
set noswapfile


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

set completeopt=menu,preview,longest

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
augroup RestoreCursor
  autocmd!
  autocmd BufRead * autocmd FileType <buffer> ++once
    \ let s:line = line("`\"")
    \ | if s:line >= 1 && s:line <= line("$") && &filetype !~# 'commit'
    \      && index(['xxd', 'gitrebase'], &filetype) == -1
    \ |   execute "normal! g`\""
    \ | endif
augroup END

if executable("rg")
  set grepprg=rg\ --vimgrep
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


function! FocusDispatchStrategy(cmd)
  execute "FocusDispatch " . a:cmd
  execute "Dispatch"
endfunction

let g:test#custom_strategies = {'focus_dispatch': function('FocusDispatchStrategy')}
let test#strategy = "focus_dispatch"
nnoremap <Leader>a :TestSuite<CR>
nnoremap <Leader>t :TestFile<CR>
nnoremap <Leader>s :TestNearest<CR>
nnoremap <Leader>l :TestLast<CR>
nnoremap <Enter> :w<CR> :Dispatch<CR>
autocmd BufWinEnter quickfix nnoremap <buffer> <Enter> <Enter>

let g:dispatch_tmux_pipe_pane=1

set confirm
set exrc " enable per-directory .vimrc files
set secure " disable unsafe commands in local .vimrc files
