" Leader
" ===================================================
let mapleader = " "


" vim-plug 
" ===================================================

if &compatible
    set nocompatible
endif

call plug#begin('~/.config/nvim/plugged')

Plug 'bling/vim-bufferline'
Plug 'chrisbra/csv.vim'
Plug 'easymotion/vim-easymotion'
Plug 'ervandew/supertab'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'junegunn/fzf', { 'do': './install --all' }
Plug 'lervag/vimtex'
Plug 'majutsushi/tagbar'
Plug 'neovimhaskell/haskell-vim'
Plug 'scrooloose/syntastic'
Plug 'tmhedberg/SimpylFold'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'vim-airline/vim-airline'

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

" We save the folding level set previously
if has("folding")
    function! UnfoldCur()
        if !&foldenable
            return
        endif
        let cl = line(".")
        if cl <= 1 | return | endif
        let cf = foldlevel(cl)
        let uf = foldlevel(cl - 1)
        let min = (cf > uf ? uf : cf)
        if min
            execute "normal!" min . "zo"
            return 1
        endif
    endfunction
endif

" Restore the cursor and setup folding level if possible
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


" Vim Bufferline
" ===================================================

let g:bufferline_echo = 0
autocmd VimEnter *
    \ let &statusline='%{bufferline#refresh_status()}'
    \ .bufferline#get_status_string()


" Tagbar
" ===================================================
" Note you must use exuberant ctags for this to work.
" This can be installed from ctags.sourceforge.net

nmap <F8> :TagbarToggle<CR>


" FZF (Fuzzy Finder)
" ===================================================

" Try to emulate ctrl-p
nmap <C-p> :FZF<CR>


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


" Miscellaneous Settings
" ===================================================

set showcmd
set number
set expandtab
set tabstop=4
set shiftwidth=4
set foldlevel=99
set foldmethod=syntax

syntax on

