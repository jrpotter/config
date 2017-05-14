let $NVIM_DIR = expand('~/.config/nvim/')

" Utility method to replace all words in the a:abbrs array with expr if any of
" said words appear first in the command line.
function! s:cabbrev(abbrs, expr)
  let l:cmd = '<C-r>=(getcmdpos() == 1 && getcmdtype() == ":")'
  for key in a:abbrs
    let l:ternary = l:cmd . ' ? "' . a:expr . '" : "' . key
    execute 'cabbrev ' . key . ' ' . l:ternary . '"<CR>'
  endfor
endfunction

if !filereadable(expand('$NVIM_DIR/autoload/plug.vim'))
  echohl WarningMsg | echo 'vim-plug not installed. Installing...' | echohl None
  silent !curl -fLo $NVIM_DIR/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | nested source $MYVIMRC
endif

runtime autoload/plug.vim
if exists('*plug#begin')
  call plug#begin('$NVIM_DIR/plugged')
  Plug 'airblade/vim-gitgutter'
  Plug 'ludovicchabant/vim-gutentags'
  Plug 'jrpotter/vim-fugitive'
  Plug 'jrpotter/vim-unimpaired'
  Plug 'junegunn/fzf', { 'do': './install --bin' }
  Plug 'junegunn/fzf.vim'
  Plug 'justinmk/vim-dirvish'
  Plug 'neomake/neomake'
  Plug 'tpope/vim-surround'
  Plug 'vim-airline/vim-airline'
  call plug#end()
else
  echohl WarningMsg | echo 'vim-plug could not be installed.' | echohl None
endif

augroup TerminalInit
  autocmd!
  autocmd TermOpen * setlocal foldcolumn=0
augroup END

hi ColorColumn  cterm=bold   ctermfg=White  ctermbg=Black
hi DiffAdd      cterm=bold   ctermfg=White  ctermbg=Green
hi DiffChange   cterm=bold   ctermfg=White  ctermbg=Blue
hi DiffDelete   cterm=bold   ctermfg=White  ctermbg=Red
hi FoldColumn   ctermfg=Blue ctermbg=none
hi Folded       cterm=bold   ctermfg=White  ctermbg=Black
hi MatchParen   cterm=bold   ctermfg=White  ctermbg=Black

let mapleader = "\<Space>"

nnoremap '          `
nnoremap `          '
nnoremap g'         g`
nnoremap g`         g'
nnoremap 0          ^
nnoremap ^          0
nnoremap j          gj
nnoremap k          gk
nnoremap K          kJ
nnoremap gK         kgJ
nnoremap <BS>       <C-^>
nnoremap <Space>    <NOP>
nnoremap <C-g>      :tag<CR>

nnoremap <Leader>ve :e $MYVIMRC<CR>
nnoremap <Leader>vr :so $MYVIMRC<CR>

set expandtab
set foldcolumn=3
set foldlevel=99
set foldmethod=syntax
set hidden
set matchpairs+=<:>
set noshowmode
set number
set relativenumber
set shada='100,f1,<50,:50,@50,/50,n$NVIM_DIR/.shada
set shiftwidth=2
set tabstop=2
set textwidth=80
set updatetime=250

" g:plugs is defined in *plug#begin and is used internally by plug.vim. Though
" not explicitly documented, piggybacking off its functionality to test for
" proper installation of the given plugins.
if exists('g:plugs') && type(g:plugs) == v:t_dict

  " Contains a mapping for statusline notifications during the running of
  " asynchronous jobs initiated by plugins. These will be displayed onto the
  " warning section of airline.
  let s:statusline_async = {}

  if has_key(g:plugs, 'vim-gutentags')
    let g:gutentags_project_root = ['tags']
    function! s:statusline_async.gutentags()
      return gutentags#statusline("\uf02b")
    endfunction
  endif

  if has_key(g:plugs, 'neomake')
    let g:neomake_open_list = 2
    call s:cabbrev(['mak', 'make'], 'Neomake')
    function! s:statusline_async.neomake()
      redir => l:background_jobs
      call neomake#ListJobs()
      redir END
      return empty(l:background_jobs) ? '' : "\uf0ad"
    endfunction
  endif

  if has_key(g:plugs, 'vim-fugitive')
    augroup FugitiveInit
      autocmd!
      " Clean up fugitive buffers when navigating commit tree
      autocmd BufReadPost fugitive://* set bufhidden=delete
    augroup END
  endif

  if has_key(g:plugs, 'fzf')
    let g:fzf_action = {
          \ 'ctrl-t': 'tab split',
          \ 'ctrl-s': 'split',
          \ 'ctrl-v': 'vsplit'
          \ }
    nnoremap <silent> <C-p><C-n> :Buffers<CR>
    nnoremap <silent> <C-p><C-p> :FZF<CR>
    nnoremap <silent> <C-p><C-j> :Tags<CR>
    nnoremap <silent> <C-p><C-k> :BTags<CR>
  endif

  if has_key(g:plugs, 'vim-airline')
    let g:airline_powerline_fonts = 1
    " This is the function that actually performs the generation of the
    " asynchronous job display.  By running each check for asynchronous jobs
    " in one single function, we can properly control the spacing of the
    " statusline objects (by using join() on all nonempty status results).
    function! g:AsyncRunning()
      let l:statuses = []
      for key in sort(keys(s:statusline_async))
        let l:result = s:statusline_async[key]()
        if !empty(l:result)
          call add(l:statuses, l:result)
        endif
      endfor
      return join(l:statuses)
    endfunction
    call airline#parts#define_function('async', 'g:AsyncRunning')
    let g:airline_section_warning = airline#section#create(['async'])
  endif
endif

