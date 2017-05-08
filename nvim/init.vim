" vim-plug {{{
" ===================================================

function! DoRemote(arg)
  UpdateRemotePlugins
endfunction

if empty(expand('$NVIM_DIR/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | nested source $MYVIMRC
endif

call plug#begin('$NVIM_DIR/plugged')

Plug 'jmcantrell/vim-diffchanges'
Plug 'jrpotter/vim-highlight'
Plug 'jrpotter/vim-repl'
Plug 'jrpotter/vim-unimpaired'
Plug 'junegunn/fzf', { 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-dirvish'
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

" Buffers & Windows {{{
" ===================================================

set hidden

" For Mac OSX, need to set the terminal to map <M-Space> to <C-\><C-n> hex
" codes (0x1C 0x0E)
tnoremap <M-Space> <C-\><C-n>

" It is simpler to have '<' and '>' simply mean grow in the direction the
" GT and LT signs are pointing towards.
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

" Move to lower window when splitting
nnoremap <silent> <C-w>s :wincmd s <Bar> wincmd j<CR>


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

autocmd FileType vim setlocal foldmethod=marker


" }}}

" FZF (Fuzzy Finder) {{{
" ===================================================

let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split | wincmd j',
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


" }}}

" Highlighting {{{
" ==================================================

hi ColorColumn cterm=bold ctermfg=White ctermbg=Black
hi CursorColumn cterm=bold ctermfg=White ctermbg=Black
hi DiffAdd cterm=bold ctermfg=White ctermbg=Green
hi DiffChange cterm=bold ctermfg=White ctermbg=Blue
hi DiffDelete cterm=bold ctermfg=White ctermbg=Red
hi FoldColumn ctermfg=Blue ctermbg=none
hi Folded cterm=bold ctermfg=White ctermbg=Black
hi MatchParen cterm=bold ctermfg=White ctermbg=Black
hi Search cterm=bold,underline ctermfg=Yellow ctermbg=none
hi Visual cterm=bold ctermfg=White ctermbg=Black

syntax on


" }}}

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
nnoremap <silent> <Leader>d :DiffChangesDiffToggle<CR>

" Allows use of w!! to edit file that required root after ropening without sudo
cmap w!! w !sudo tee % >/dev/null


" }}}

" Motions {{{
" ===================================================

nnoremap <expr> n 'Nn'[v:searchforward] . 'zzzv'
nnoremap <expr> N 'nN'[v:searchforward] . 'zzzv'

" 0 indicates backward, 1 indicates forward, -1 indicates inconclusive
function! s:CheckDirection(motion, ord)
  let oldpos = getcurpos()
  exe 'norm! ' . a:motion
  let newpos = getcurpos()

  let direction = -1
  if oldpos[2] != newpos[2]
    call setpos('.', oldpos)
    exe 'let direction = (oldpos[2] ' . a:ord . ' newpos[2])'
  endif
  return direction
endfunction

function! s:MoveAbsoluteDirection(forward)
  " Determine direction semicolon and comma moves towards
  let direction = s:CheckDirection(';', '<')
  if direction == -1
    let direction = s:CheckDirection(',', '>')
  endif
  if direction != -1
    exe 'norm! ' . (a:forward != direction ? ',' : ';')
  endif
endfunction

nnoremap <silent> ; :call <SID>MoveAbsoluteDirection(1)<CR>
nnoremap <silent> , :call <SID>MoveAbsoluteDirection(0)<CR>

" Allow adding and subtracting next number in both directions across lines.
function! s:AddSubtract(char, back)
  call search('[[:digit:]]', 'cw' . a:back)
  exe 'norm! ' . v:count1 . a:char
  silent! call repeat#set( \
      ":\<C-u>call AddSubtract('" . a:char . "', '" . a:back . "')\<CR>")
endfunction

nnoremap <silent> <C-a> :<C-u>call <SID>AddSubtract("\<C-a>", '')<CR>
nnoremap <silent> <Leader><C-a> :<C-u>call <SID>AddSubtract("\<C-a>", 'b')<CR>
nnoremap <silent> <C-x> :<C-u>call <SID>AddSubtract("\<C-x>", '')<CR>
nnoremap <silent> Leader<C-x> :<C-u>call <SID>AddSubtract("\<C-x>", 'b')<CR>


" }}}

" Neomake {{{
" ===================================================

autocmd BufWritePost * Neomake

let g:neomake_verbose = 0
let g:neomake_cpp_enable_makers = ['gcc']
let g:neomake_cpp_gcc_maker = { 'exe' : 'g++' }


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

function! s:SaveCursorPosition()
  if line("'\"") > 1 && line("'\"") <= line("$")
    exe "normal! g`\""
  endif
endfunction

" Save the cursor position
autocmd BufRead * call <SID>SaveCursorPosition()


" }}}

" Sessions {{{
" ===================================================
" Convenience function to avoid writing NVIM_DIR repeatedly

let s:sessions_path = $NVIM_DIR . '/sessions/'

function s:ListSessions(ArgLead, CmdLine, CursorPos)
  if !isdirectory(s:sessions_path)
    return ''
  endif
  return system('ls ' . s:sessions_path)
endfunction

function! s:SaveSessionAs(name)
  if !isdirectory(s:sessions_path)
    call mkdir(s:sessions_path)
  endif
  exec 'mksession! ' . s:sessions_path . a:name
endfunction

function! s:LoadSavedSession(name)
  let path = s:sessions_path . a:name
  if filereadable(path)
    exec 'source ' . path
  endif
endfunction

function! s:DeleteSavedSession(name)
  let path = s:sessions_path . a:name
  if filereadable(path)
    call delete(path)
  endif
endfunction

command -nargs=1 -complete=custom,<SID>ListSessions SSA :call <SID>SaveSessionAs(<f-args>)
command -nargs=1 -complete=custom,<SID>ListSessions LSS :call <SID>LoadSavedSession(<f-args>)
command -nargs=1 -complete=custom,<SID>ListSessions DSS :call <SID>DeleteSavedSession(<f-args>)


" }}}

" Settings {{{
" ===================================================

set backspace=indent,eol,start
set expandtab
set matchpairs+=<:>
set noerrorbells
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
