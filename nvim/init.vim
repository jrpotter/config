" Leader {{{
" ===================================================

let mapleader = " "


" }}}

" vim-plug {{{
" ===================================================

if &compatible
    set nocompatible
endif

function! DoRemote(arg)
    UpdateRemotePlugins
endfunction

call plug#begin('$NVIM_DIR/plugged')

Plug 'christoomey/vim-tmux-navigator'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'honza/vim-snippets'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'justinmk/vim-sneak'
Plug 'junegunn/fzf', { 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-startify'
Plug 'neomake/neomake'
Plug 'sirver/ultisnips'
Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }
Plug 'tmhedberg/SimpylFold'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'vim-airline/vim-airline'
Plug 'xolox/vim-easytags'
Plug 'xolox/vim-misc'

call plug#end()


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
tnoremap <A-Space> <C-\><C-n>


" }}}

" Deoplete {{{
" ==================================================

let g:deoplete#enable_at_startup = 1


" }}}

" EasyTags {{{
" ===================================================

set tags=$NVIM_DIR/vimtags
let g:easytags_file = '$NVIM_DIR/vimtags'
let g:easytags_auto_highlight = 0
let g:easytags_async = 1


" }}}

" Folding {{{
" ===================================================

set foldcolumn=3
set foldlevel=99
set foldmethod=syntax

autocmd! FileType vim setlocal foldmethod=marker


" }}}

" FZF (Fuzzy Finder) {{{
" ===================================================

" Try to emulate ctrl-p
nmap <silent> <C-p>b :BTags<CR>
nmap <silent> <C-p>g :GFiles<CR>
nmap <silent> <C-p>m :Marks<CR>
nmap <silent> <C-p>n :Buffers<CR>
nmap <silent> <C-p>p :FZF<CR>
nmap <silent> <C-p>s :Snippets<CR>
nmap <silent> <C-p>t :Tags<CR>


" }}}

" Mappings {{{
" ===================================================

" Escaping
noremap <NUL> <ESC>
inoremap <NUL> <ESC>
vnoremap <NUL> <ESC>
cnoremap <NUL> <C-c>

" Natural editor movement
nnoremap j gj
nnoremap k gk

" Switch Marking
nnoremap ' `
nnoremap ` '

" Tags
nnoremap <silent> <C-g> :ta<CR>

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

" Highlighting
noremap <silent> Y :noh<CR>

" Allows use of w!! to edit file that required root after ropening without sudo
cmap w!! w !sudo tee % >/dev/null


" }}}

" Neomake {{{
" ===================================================

autocmd! BufWritePost * Neomake

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


" }}}

" Restoration {{{
" ===================================================

" Tell vim to remember certain things when exiting
"   '10  : marks will be remembered for up to 10 previously edited files
"   "100 : will save up to 100 lines for each register
"   :20  : up to 20 lines of command-line history will be remembered
"   %    : saves and restores the buffer list
"   n... : where to save the viminfo files
set viminfo='10,\"100,:20,%,n~/.config/nvim/.viminfo

" Save the cursor position
function! ResCur()
    if line("'\"") <= line("$")
        normal! g`"
        return 1
    endif
endfunction

" Save the folding level set previously
if has("folding")
    function! UnfoldCur()
        if !&foldenable
            return
        endif
        let cl = line(".")
        if cl <= 1 | return | endif
        let cf = foldlevel(cl)
        let uf = foldlevel(cl -1)
        let min = (cf > uf ? uf : cf)
        if min
            execute "normal!" min . "zo"
            return 1
        endif
    endfunction
endif

" Restore cursor and setup folding level if possible
augroup restoreCursor
    autocmd!
    if has("folding")
        autocmd BufWinEnter * if ResCur() | call UnfoldCur() | endif
    else
        autocmd BufWinEnter * call ResCur()
    endif
augroup END


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
set number
set expandtab
set tabstop=4
set shiftwidth=4
set splitright

syntax on


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

" UltiSnips {{{
" ===================================================

let g:UltiSnipsExpandTrigger="<Tab>"
let g:UltiSnipsJumpForwardTrigger="<C-l>"
let g:UltiSnipsJumpBackwardTrigger="<C-h>"


" }}}

" Windows {{{
" ===================================================

let g:tmux_navigator_no_mappings = 1

nmap <silent> <A-h> :TmuxNavigateLeft<CR>
nmap <silent> <A-j> :TmuxNavigateDown<CR>
nmap <silent> <A-k> :TmuxNavigateUp<CR>
nmap <silent> <A-l> :TmuxNavigateRight<CR>


" }}}
