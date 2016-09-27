" vim-plug {{{
" ===================================================

function! DoRemote(arg)
    UpdateRemotePlugins
endfunction

call plug#begin('$NVIM_DIR/plugged')

Plug 'jrpotter/vim-unimpaired'
Plug 'justinmk/vim-sneak'
Plug 'junegunn/fzf', { 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'
Plug 'mbbill/undotree'
Plug 'mhinz/vim-startify'
Plug 'neomake/neomake'
Plug 'sirver/ultisnips' | Plug 'honza/vim-snippets'
Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }
Plug 'tmhedberg/SimpylFold'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'vim-airline/vim-airline'
Plug 'wellle/targets.vim'

call plug#end()


" }}}

" Leader {{{
" ===================================================

let mapleader = " "


" }}}

" Airline {{{
" ===================================================

let g:airline_powerline_fonts = 1


" }}}

" Buffers {{{
" ===================================================

set hidden

" Because vi-mode in zsh is set to escape with '^ ', it is necessary
" to escape out of terminal mode in a way that does not interfere with
" vi-mode. Thus, Alt is used for terminal related activities.
"
" For Mac OSX, need to set the terminal to map <M-Space> to <C-\><C-n> hex
" codes (0x1C 0x0E)
tnoremap <M-Space> <C-\><C-n>


" }}}

" Colors {{{
" ==================================================

hi FoldColumn ctermfg=Blue ctermbg=none
hi Visual cterm=bold ctermfg=none ctermbg=DarkBlue
hi Search cterm=bold,underline ctermfg=Yellow ctermbg=none

syntax on


" Commentary {{{
" ==================================================

au! FileType c,cpp,cs,java setlocal commentstring=//\ %s


" }}}

" Deoplete {{{
" ==================================================

let g:deoplete#enable_at_startup = 1


" }}}

" Folding {{{
" ===================================================

set foldcolumn=3
set foldlevel=99
set foldmethod=syntax

au! FileType vim setlocal foldmethod=marker


" }}}

" FZF (Fuzzy Finder) {{{
" ===================================================

" Try to emulate ctrl-p
nmap <silent> <C-p>c :Commits<CR>
nmap <silent> <C-p>g :GFiles<CR>
nmap <silent> <C-p>h :History:<CR>
nmap <silent> <C-p>l :Lines<CR>
nmap <silent> <C-p>m :Marks<CR>
nmap <silent> <C-p>n :Buffers<CR>
nmap <silent> <C-p>p :FZF<CR>
nmap <silent> <C-p>s :History/<CR>
nmap <silent> <C-p>t :Tags<CR>
nmap <silent> <C-p>s :Snippets<CR>

" Buffer Specific
nmap <silent> <C-p><Leader>c :Bcommits<CR>
nmap <silent> <C-p><Leader>l :BLines<CR>
nmap <silent> <C-p><Leader>t :BTags<CR>


" }}}

" Gutentags {{{
" ===================================================

let g:gutentags_project_root = ['tags']


" Mappings {{{
" ===================================================

" Escaping
noremap <NUL> <ESC>
inoremap <NUL> <ESC>
vnoremap <NUL> <ESC>
cnoremap <NUL> <C-c>

" Natural editor movement
noremap j gj
noremap k gk

" Buffer Toggling
noremap <BS> <C-^>

" Switch Marking
noremap ' `
noremap ` '

" Switch Start of Line
noremap 0 ^
noremap ^ 0

" Join lines above
nnoremap <silent> K :-1,.j<CR>

" Insert Mode Completion Popup
inoremap <C-j> <C-n>
inoremap <C-k> <C-p>

" Command Mode Scrolling
cnoremap <C-h> <Left>
cnoremap <C-k> <Up>
cnoremap <C-l> <Right>
cnoremap <C-j> <Down>

" Shift Tab Backward
inoremap <S-Tab> <C-d>

" Folding Navigation
noremap zk zk[z

" Allows use of w!! to edit file that required root after ropening without sudo
cmap w!! w !sudo tee % >/dev/null


" }}}

" Neomake {{{
" ===================================================

au! BufWritePost * Neomake

let g:neomake_verbose = 0

let g:neomake_cpp_enable_makers = ['gcc']
let g:neomake_cpp_gcc_maker = {
            \ 'exe': 'g++'
            \ }


" }}}

" NetRW {{{
" ===================================================

" Add numbers to NetRW
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'
let g:netrw_banner = 1


" }}}

" Restoration {{{
" ===================================================

" Tell nvim to remember certain things when exiting
"  '1000 : Number of files for which one saves marks
"  f1    : Controls whether global marks are stored
"  <500  : # of lines for each register
"  :500  : # of lines in cmd line history
"  @500  : # of lines to save from input line history
"  /500  : # of lines to save from search history
"  n     : Name used for ShaDa file
set shada='1000,f1,<500,:500,@500,/500,n$NVIM_DIR/.shada

" Save the cursor position
au! BufRead * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif


" }}}

" Search {{{
" ===================================================

function SearchUnderCursor()
    let @/='\<' . expand("<cword>") . '\>'
    set hls
endfunction

noremap <silent> * *:%s///gn<CR><C-O>
noremap <silent> # #:%s///gn<CR><C-O>
noremap <silent> & :call SearchUnderCursor()<CR>:%s///gn<CR><C-O>
noremap <silent> <C-L> :noh<Bar>diffupdate<CR>

nmap n :norm! nzzzv<CR>
nmap N :norm! Nzzzv<CR>


" }}}

" Sessions {{{
" ===================================================
" Convenience function to avoid writing NVIM_DIR repeatedly

" Save Session As
function SSA(name)
    let path = $NVIM_DIR . '/sessions/' . a:name
    exec 'mks! ' . path
endfunction

" Load Saved Session
function LSS(name)
    let path = $NVIM_DIR . '/sessions/' . a:name
    exec 'source ' . path
endfunction

command -nargs=1 SSA :call SSA(<f-args>)
command -nargs=1 LSS :call LSS(<f-args>)


" }}}

" Settings {{{
" ===================================================

set showcmd
set noshowmode
set number
set expandtab
set tabstop=4
set shiftwidth=4
set splitright
set backspace=indent,eol,start
set complete-=i
set backupdir=$NVIM_DIR/backup//
set directory=$NVIM_DIR/swap//
set undodir=$NVIM_DIR/undo//
set ruler
set scrolloff=1
set sidescrolloff=5
set number
set relativenumber
set notimeout
set updatetime=500


" }}}

" Startify {{{
" ===================================================

let g:startify_custom_header = [
            \ '     ________   ___      ___ ___  _____ ______            ', 
            \ '     |\   ___  \|\  \    /  /|\  \|\   _ \  _   \         ', 
            \ '     \ \  \\ \  \ \  \  /  / | \  \ \  \\\__\ \  \        ',
            \ '      \ \  \\ \  \ \  \/  / / \ \  \ \  \\|__| \  \       ',
            \ '       \ \  \\ \  \ \    / /   \ \  \ \  \    \ \  \      ',
            \ '        \ \__\\ \__\ \__/ /     \ \__\ \__\    \ \__\     ',
            \ '         \|__| \|__|\|__|/       \|__|\|__|     \|__|     ',
            \ ]

let g:startify_session_dir = '$NVIM_DIR/sessions'


" }}}

" Tags {{{
" ===================================================

nmap <silent> <C-]> :exe "tag " . expand('<cword>')<CR>zzzv<CR>
nmap <silent> <C-t> :exe "norm! \<C-t>zzzv"<CR>
nmap <silent> <C-g> :ta<CR>zzzv


" }}}

" Tagbar {{{
" ===================================================

nmap <silent> <C-w>t :TagbarToggle<CR>

let g:tagbar_autoshowtag = 1
let g:tagbar_compact = 1
let g:tagbar_show_linenumbers = 2


" }}}

" UltiSnips {{{
" ===================================================

let g:UltiSnipsExpandTrigger="<Tab>"
let g:UltiSnipsJumpForwardTrigger="<C-l>"
let g:UltiSnipsJumpBackwardTrigger="<C-h>"


" }}}

" Undo Tree {{{
" ===================================================

nmap <silent> <C-w>u :UndotreeToggle<CR>


" }}}
