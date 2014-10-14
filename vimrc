" Use Vim settings, rather than Vi settings.

set nocompatible         " This must be first, because it changes other options.

set hidden                     " allow hidden buffers

call pathogen#infect()   " activate pathogen.vim
" use sensible.vim to set reasonable defaults for vimrc
runtime! plugin/sensible.vim

set relativenumber  " Set cursor line to zero for quick navigation

" Set the font name and size
set guifont=Ubuntu\ Mono:h14

" Removes trailing spaces
function! TrimWhiteSpace()
  %s/\s\+$//e
endfunction

" gui settings {{{
if has ("gui_running")
    set guifont=Ubuntu\ Mono:h14
    set undofile
    set undodir=~/.vim/undos
    " use ⌘ 1– ⌘ 9to switch tabs
    nmap <D-1> 1gt
    nmap <D-2> 2gt
    nmap <D-3> 3gt
    nmap <D-4> 4gt
    nmap <D-5> 5gt
    nmap <D-6> 6gt
    nmap <D-7> 7gt
    nmap <D-8> 8gt
    nmap <D-9> 9gt
    " Command-/ to toggle comments
    map <D-/> <plug>NERDCommenterToggle<CR>
    imap <D-/> <Esc><plug>NERDCommenterToggle<CR>i
endif
"}}}

" Whitespace stuff {{{
set wrap
set linebreak
set shiftround
set tabstop=8          " make tabs 8 columns wide
set softtabstop=4      " indent as if tabs are 4 columns wide
set shiftwidth=4       " indent 4 columns
set expandtab          " insert spaces instead of tabs
set smartindent        " guess new indentation levels
"}}}

" Vimscript file settings --------------- {{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" Add autcmd to trim whitespace on file save {{{
augroup trim_whitespace
    autocmd FileWritePre    * :call TrimWhiteSpace()
    autocmd FileAppendPre   * :call TrimWhiteSpace()
    autocmd FilterWritePre  * :call TrimWhiteSpace()
    autocmd BufWritePre     * :call TrimWhiteSpace()
augroup END
"}}}

" Add spell checking and automatic wrapping to commit messages and text docs
augroup git_commands
    autocmd!
    autocmd FileType gitcommit setlocal spell textwidth=72
    autocmd FileType text setlocal spell textwidth=80
augroup END

" filetype specific tabs {{{
augroup filetype_tabs
    autocmd!
    autocmd FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4
    autocmd FileType less setlocal shiftwidth=4 tabstop=4 softtabstop=4
    autocmd FileType javascript setlocal shiftwidth=4 tabstop=4 softtabstop=4
    autocmd FileType html setlocal softtabstop=2 shiftwidth=2

    au BufNewFile,BufReadPost *.coffee setlocal softtabstop=2 shiftwidth=2
    au BufNewFile,BufReadPost *.jade setlocal softtabstop=2 shiftwidth=2
augroup END
"}}}

" Remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif


augroup set_filetype
    autocmd!
    " Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
    au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru}    set ft=ruby

    " add json syntax highlighting
    au BufNewFile,BufRead *.json set ft=javascript
augroup end

let javascript_enable_domhtmlcss=1  "enable HTML/CSS syntax highlighting in js files

" filetype specific abbreviations {{{
aug filetype_abbrevs
    au!
    au FileType javascript :iabbrev <buffer> fn function() {<cr><cr>}<up>
    au FileType javascript :iabbrev <buffer> fna function(
    au FileType javascript :iabbrev <buffer> iff if ()<left>
    au FileType javascript :iabbrev <buffer> ret return;<left>
    au FileType python :iabbrev <buffer> iff if:<left>
    au FileType python :iabbrev <buffer> ret return
aug END
"}}}

aug filetype_folding
    au!
    au FileType html setlocal foldmethod=manual
    au FileType html nnoremap <buffer> <localleader>f Vatzf
aug END

"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use

" search
set hlsearch        " Highlight searches
set ignorecase      " Case insensitive search
set smartcase       " except when using capital letters
" Maps CTRL-n to :noh to remove search highlighting
nnoremap <silent> <C-n> :silent nohlsearch<CR>

" swap files
set nobackup
set noswapfile

" Use modeline overrides
set modeline
set modelines=10

" terminal
set t_Co=256    " enable 256-color terminal support

" colors -------- {{{
syntax enable           " Enable syntax highlighting
set colorcolumn=81
let g:khuno_max_line_length=90
let g:solarized_termtrans = 1
set background=dark            " use a dark background
colorscheme solarized          " set theme

" customize terminal color choices
highlight LineNr ctermbg=Black
highlight CursorLine ctermbg=LightGray
" }}}

" Tab completion
"complete longest common string, then list alternatives
set wildmode=list:longest,full
set wildignore+=*.png,*.jpg,*.gif,*.zip,.git,.svn,node_modules,site-packages

" status line settings ------ {{{
" status line : filepath, modified, read-only, help buffer, preview-window
set statusline=%f%m%r%h%w
" current line number / total lines
set statusline+=\ L%l/%L
" column number
set statusline+=\ C%v
" git branch information from fugitive.vim if file is in git
set statusline+=\ %{exists('g:loaded_fugitive')?fugitive#statusline():''}
" }}}

" Hide the toolbar in gui mode
set go-=T

" NERDTree configuration
let NERDTreeIgnore=['\.pyc$', '\.rbc$', '\~$']
nnoremap <Leader>n :NERDTreeToggle<CR>

" Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup

" Turn off jslint errors by default
let g:JSLintHighlightErrorLine = 0

" MacVIM shift+arrow-keys behavior (required in .vimrc)
let macvim_hig_shift_movement = 1

" *** Convenience mappings *** {{{
" ----------------------------

let mapleader=";"  " Allows you to use ';' instead of ':'
let maplocalleader=","  " Allows you to use ',' as the prefix in certain files

nnoremap <silent> <D-d> :NERDTreeToggle<CR>
nnoremap <silent> <Leader><space> :NERDTreeToggle<CR>
nnoremap <silent> <D-D> :NERDTree<CR>
nnoremap <silent> <Leader>w :w<CR>
nnoremap <silent> <Leader>q :q<CR>
nnoremap <silent> <Leader>x :wq<CR>


" Movement mappings
" ------
" select text inside next parens
onoremap in( :<c-u>normal! f(vi(<cr>
" select text inside previous parens
onoremap il( :<c-u>normal! F)vi(<cr>

" Mode mappings
" ------
"toggle line numbers on and off
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>
nnoremap <F4> :set norelativenumber!<CR>:set foldcolumn=0<CR>

" move up/down by row, not by line (for wrapped lines)
nnoremap j gj
nnoremap k gk

" move the current row up
nnoremap <Leader>- ddkkp

"open ~/.vimrc in split view for quick editing
nnoremap <leader>ev :vsplit $MYVIMRC<cr>

"source vimrc
nnoremap <leader>sv :source $MYVIMRC<cr>

" surround word in quotes
nnoremap <Leader>" ciw""<esc>hp
nnoremap <Leader>' ciw''<esc>hp

" surround a visual selection in quotes, for multiple words
vnoremap <Leader>" c""<esc>hp
vnoremap <Leader>' c''<esc>hp

" exit insert mode
inoremap jk <esc>
" make <esc> a no op
inoremap <esc> <nop>
" }}}

" useful insert abbreviations {{{
iabbrev hellow hello
iabbrev ssig --<cr>Jacob Speidel<cr>jacob.speidel@gmail.com
iabbrev @@ jacob@jacobspeidel.com
iabbrev @@g jacob.speidel@gmail.com
iabbrev ccopy Copyright 2014 Jacob Speidel, all rights reserved
iabbrev scopy Copyright 2014 Seattle Sockeye Frisbee Club, all rights reserved
" Insert timestamp
nnoremap <F3> a<C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR><Esc>
inoremap <F3> <C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR>
" }}}
