" Leader
" ===================================================
let mapleader = " "


" vim-plug 
" ===================================================

if &compatible
    set nocompatible
endif

call plug#begin('$NVIM_DIR/plugged')

Plug 'chrisbra/csv.vim'
Plug 'easymotion/vim-easymotion'
Plug 'ervandew/supertab'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'junegunn/fzf', { 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'lervag/vimtex'
Plug 'mhinz/vim-startify'
Plug 'neovimhaskell/haskell-vim'
Plug 'scrooloose/syntastic'
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


" Restoration
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


" Vim Airline
" ===================================================

let g:airline_powerline_fonts = 1


" FZF (Fuzzy Finder)
" ===================================================

" Try to emulate ctrl-p
nmap <C-p> :FZF<CR>
nmap <Leader><C-p> :Buffers<CR>
nmap <Leader><C-t> :Tags<CR>


" EasyMotion
" ==================================================

" Disable default mappings
let g:EasyMotion_do_mapping = 0

" Keep cursor column when moving rows
let g:EasyMotion_startofline = 0

" Enhance searching
map / <Plug>(easymotion-sn)
map ? <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

" Provide different highlight methods (after search)
map n <Plug>(easymotion-next)
map N <Plug>(easymotion-prev)

" Enhance forward/backward motions
nmap <Leader>f <Plug>(easymotion-lineforward)
nmap <Leader>F <Plug>(easymotion-linebackward)

" Line by line motions
map s <Plug>(easymotion-overwin-f)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)


" Startify
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


" EasyTags
" ===================================================

set tags=$NVIM_DIR/vimtags
let g:easytags_file = '$NVIM_DIR/vimtags'
let g:easytags_async = 1


" NetRW
" ===================================================

" Add numbers to NetRW
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'


" Mappings
" ===================================================

" Escaping
noremap <NUL> <ESC>
inoremap <NUL> <ESC>
vnoremap <NUL> <ESC>
cnoremap <NUL> <C-c>

" Natural editor movement
nnoremap j gj
nnoremap k gk

" Allows use of w!! to edit file that required root after ropening without sudo
cmap w!! w !sudo tee % >/dev/null


" Buffers
" ===================================================

set hidden

" Because vi-mode in zsh is set to escape with '^ ', it is necessary
" to escape out of terminal mode in a way that does not interfere with
" vi-mode. Thus, Alt is used for terminal related activities.
tnoremap <A-Space> <C-\><C-n>


" Sessions
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


" Folding
" ===================================================

set foldcolumn=3
set foldlevel=99
set foldmethod=syntax


" Miscellaneous Settings
" ===================================================

set showcmd
set number
set expandtab
set tabstop=4
set shiftwidth=4
set splitright

syntax on

