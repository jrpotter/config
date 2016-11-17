" vim-plug {{{
" ===================================================

function! DoRemote(arg)
    UpdateRemotePlugins
endfunction

call plug#begin('$NVIM_DIR/plugged')

Plug 'jpalardy/vim-slime'
Plug 'jrpotter/vim-highlight'
Plug 'jrpotter/vim-unimpaired'
Plug 'junegunn/fzf', { 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-dirvish'
Plug 'justinmk/vim-sneak'
Plug 'Konfekt/FastFold'
Plug 'ludovicchabant/vim-gutentags'
Plug 'mbbill/undotree'
Plug 'mhinz/vim-startify'
Plug 'neomake/neomake'
Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
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

hi ColorColumn cterm=bold ctermfg=White ctermbg=Black
hi CursorColumn cterm=bold ctermfg=White ctermbg=Black
hi DiffAdd cterm=bold ctermfg=Green ctermbg=Black
hi DiffChange cterm=bold ctermfg=Blue ctermbg=Black
hi DiffDelete cterm=bold ctermfg=Red ctermbg=Black
hi FoldColumn ctermfg=Blue ctermbg=none
hi Folded cterm=bold ctermfg=White ctermbg=Black
hi MatchParen cterm=bold ctermfg=White ctermbg=Black
hi Search cterm=bold,underline ctermfg=Yellow ctermbg=none
hi Visual cterm=bold ctermfg=White ctermbg=Black

syntax on


" Deoplete {{{
" ==================================================

let g:deoplete#enable_at_startup = 1


" }}}


" Folding {{{
" ===================================================

set foldcolumn=3
set foldlevel=99
set foldmethod=syntax

autocmd FileType vim setlocal foldmethod=marker


" }}}

" FZF (Fuzzy Finder) {{{
" ===================================================

let g:fzf_action = {
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-s': 'split',
            \ 'ctrl-v': 'vsplit'
            \ }

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
nmap <silent> <Leader><C-p>c :Bcommits<CR>
nmap <silent> <Leader><C-p>l :BLines<CR>
nmap <silent> <Leader><C-p>t :BTags<CR>


" }}}

" Gutentags {{{
" ===================================================

let g:gutentags_project_root = ['tags']


" Mappings {{{
" ===================================================

noremap ' `
noremap ` '
noremap 0 ^
noremap ^ 0
noremap j gj
noremap k gk
nnoremap <BS> <C-^>
nnoremap <silent> K kJ
nnoremap <silent> gK kgJ
nmap n :norm! nzzzv<CR>
nmap N :norm! Nzzzv<CR>

" Allows use of w!! to edit file that required root after ropening without sudo
cmap w!! w !sudo tee % >/dev/null


" }}}

" Neomake {{{
" ===================================================

autocmd BufWritePost * Neomake

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
autocmd BufRead * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif


" }}}

" Sessions {{{
" ===================================================
" Convenience function to avoid writing NVIM_DIR repeatedly

" Save Session As
function! s:SSA(name)
    let path = $NVIM_DIR . '/sessions/' . a:name
    exec 'mks! ' . path
endfunction

" Load Saved Session
function! s:LSS(name)
    let path = $NVIM_DIR . '/sessions/' . a:name
    exec 'source ' . path
endfunction

command -nargs=1 SSA :call <SID>SSA(<f-args>)
command -nargs=1 LSS :call <SID>LSS(<f-args>)


" }}}

" Settings {{{
" ===================================================

set backspace=indent,eol,start
set expandtab
set noshowmode
set notimeout
set nowrap
set number
set relativenumber
set ruler
set scrolloff=1
set shiftwidth=4
set showcmd
set sidescrolloff=5
set smartcase
set splitright
set tabstop=4
set textwidth=80
set updatetime=500


" }}}

" Slime {{{
" ===================================================

let g:slime_target = 'neovim'
let g:slime_dont_ask_default = 1
let g:slime_paste_file = tempname()

" Custom Variables
let s:repl_targets = {
            \ 'python' : 'python3',
            \ 'haskell' : 'ghci',
            \ }

function! s:SlimeConfig()
    let bv = getbufvar('%', 'terminal_job_id')
    exe "normal! \<C-w>p"
    let b:slime_config = { 'jobid' : bv }
endfunction

function! s:SlimeMappings()
    if has_key(s:repl_targets, &filetype)
        exe 'nnoremap <silent> <Leader>ss ' .
                \ ':split term://' . s:repl_targets[&filetype] . '<CR>' .
                \ ':call <SID>SlimeConfig()<CR>'
        exe 'nnoremap <silent> <Leader>sv ' .
                \ ':vsplit term://' . s:repl_targets[&filetype] . '<CR>' .
                \ ':call <SID>SlimeConfig()<CR>'
    else
        nnoremap <silent> <Leader>ss
            \ :split<Bar>enew<Bar>call termopen("$SHELL -d -f")<CR>
            \ :call <SID>SlimeConfig()<CR>
        nnoremap <silent> <Leader>sv
            \ :vsplit<Bar>enew<Bar>call termopen("$SHELL -d -f")<CR>
            \ :call <SID>SlimeConfig()<CR>
    end
endfunction

autocmd BufEnter * call <SID>SlimeMappings()


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

nmap <silent> <C-]> :exe 'tag ' . expand('<cword>')<CR>zzzv<CR>
nmap <silent> <C-t> :exe "norm! \<C-t>zzzv"<CR>
nmap <silent> <C-g> :ta<CR>zzzv


" }}}

" Undo Tree {{{
" ===================================================

nmap <silent> <C-w>u :UndotreeToggle<CR>


" }}}

" Windows {{{
" ===================================================

function! s:ExpandWindowLeft(count) range
    let cur_win = winnr()
    exe "normal! \<C-w>h"
    let next_win = winnr()
    if next_win != cur_win
        exe "normal! \<C-w>p" . a:count . "\<C-w>>"
    else
        exe "normal! " . a:count . "\<C-w><"
    endif
endfunction

function! s:ExpandWindowRight(count) range
    let cur_win = winnr()
    exe "normal! \<C-w>l"
    let next_win = winnr()
    if next_win != cur_win
        exe "normal! \<C-w>p" . a:count . "\<C-w>>"
    else
        exe "normal! " . a:count . "\<C-w><"
    endif
endfunction

nnoremap <silent> <C-w>< :<C-u>call <SID>ExpandWindowLeft(v:count1)<CR>
nnoremap <silent> <C-w>> :<C-u>call <SID>ExpandWindowRight(v:count1)<CR>

