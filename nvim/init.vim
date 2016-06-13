" Dein Plugin Manager
" ===================================================

if &compatible
    set nocompatible
endif

call plug#begin('~/.config/nvim/plugged')

Plug 'chrisbra/csv.vim'
Plug 'easymotion/vim-easymotion'
Plug 'ervandew/supertab'
Plug 'kien/ctrlp.vim'
Plug 'lervag/vimtex'
Plug 'majutsushi/tagbar'
Plug 'neovimhaskell/haskell-vim'
Plug 'scrooloose/syntastic'
Plug 'tmhedberg/SimpylFold'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
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


" Mappings
" ===================================================

noremap <NUL> <ESC>
inoremap <NUL> <ESC>
vnoremap <NUL> <ESC>
cnoremap <NUL> <C-c>


" Miscellaneous Settings
" ===================================================

set number
set expandtab
set tabstop=4
set shiftwidth=4
set foldlevel=99
set foldmethod=syntax

syntax on

