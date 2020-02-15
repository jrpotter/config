let $NVIM_DIR = expand('~/.config/nvim/')

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
  Plug 'jrpotter/vim-highlight'
  Plug 'junegunn/fzf', { 'do': './install --bin' }
  Plug 'junegunn/fzf.vim'
  Plug 'justinmk/vim-dirvish'
  Plug 'justinmk/vim-sneak'
  Plug 'neomake/neomake'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-unimpaired'
  Plug 'vim-airline/vim-airline'
  call plug#end()
else
  echohl WarningMsg | echo 'vim-plug could not be installed.' | echohl None
endif

augroup TerminalInit
  autocmd!
  autocmd TermOpen * setlocal foldcolumn=0
augroup END

hi ColorColumn  cterm=bold        ctermfg=White  ctermbg=Black
hi DiffAdd      cterm=bold        ctermfg=White  ctermbg=Green
hi DiffChange   cterm=bold        ctermfg=White  ctermbg=Blue
hi DiffDelete   cterm=bold        ctermfg=White  ctermbg=Red
hi FoldColumn   ctermfg=LightBlue ctermbg=none
hi Folded       cterm=bold        ctermfg=White  ctermbg=Black
hi MatchParen   cterm=bold        ctermfg=White  ctermbg=Black

let mapleader = "\<Space>"

noremap  0          ^
noremap  ^          0
noremap  '          `
noremap  `          '
nnoremap j          gj
nnoremap k          gk
nnoremap <BS>       <C-^>
nnoremap <Space>    <NOP>
nnoremap <C-g>      :tag<CR>
nnoremap <Leader>ve :e $MYVIMRC<CR>
nnoremap <Leader>vr :so $MYVIMRC<CR>

" Replace current buffer with new one.
command -nargs=1 -bang Br edit<bang> <args> <Bar> bd<bang> #

set expandtab
set foldcolumn=3
set foldlevel=99
set foldmethod=syntax
set hidden
set matchpairs+=<:>
set noshowmode
set nostartofline
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
  let s:statusline_plugins = { 'y': { }, 'warning': { } }

  if has_key(g:plugs, 'vim-fugitive')
    augroup FugitiveInit
      autocmd!
      " Clean up fugitive buffers when navigating commit tree
      autocmd BufReadPost fugitive://* set bufhidden=delete
    augroup END
  endif

  if has_key(g:plugs, 'vim-highlight')
    function! s:statusline_plugins.y.highlight()
      return highlight#statusline()
    endfunction
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
    " This is the function that actually performs the generation of the async
    " statusline.  By running each check for all jobs in one single function,
    " we can properly control the spacing of the statusline objects (by using
    " join() on all nonempty status results).
    function! s:PollStatusline(section)
      let l:statuses = []
      for key in sort(keys(s:statusline_plugins[a:section]))
        let l:result = s:statusline_plugins[a:section][key]()
        if !empty(l:result)
          call add(l:statuses, l:result)
        endif
      endfor
      return join(l:statuses)
    endfunction
    " Construction of the 'y' segment. This requires manually setting the
    " vim-highlight value to ensure proper highlighting.
    function! g:PollYStatusline()
      return s:PollStatusline('y')
    endfunction
    " Note the highlight group must match g:highlight_register_prefix defined in
    " vim-highlight.
    let g:airline_section_y = airline#section#create_right(
          \ [ 'ffenc', '%#HighlightRegister#%{g:PollYStatusline()}%#__restore__#'])
    " Construction of the 'warning' segment.
    function! g:PollWarningStatusline()
      return s:PollStatusline('warning')
    endfunction
    call airline#parts#define_function('warning', 'g:PollWarningStatusline')
    let g:airline_section_warning = airline#section#create(['warning'])
  endif

endif
