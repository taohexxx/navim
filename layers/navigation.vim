" functions {{{

"}}}

"call dein#add('yonchu/accelerated-smooth-scroll')
call dein#add('mileszs/ack.vim') "{{{
  if executable('ag')
    let g:ackprg = "ag --nogroup --column --smart-case --follow"
  endif
"}}}
call dein#add('mbbill/undotree', {'on_cmd': 'UndotreeToggle'}) "{{{
  let g:undotree_WindowLayout = 2
  let g:undotree_SetFocusWhenToggle = 1
"}}}
call dein#add('vim-scripts/EasyGrep', {'on_cmd': 'GrepOptions'}) "{{{
  let g:EasyGrepRecursive = 1
  let g:EasyGrepAllOptionsInExplorer = 1
  let g:EasyGrepCommand = 1
"}}}
"call dein#add('ctrlpvim/ctrlp.vim', {'on_cmd': 'CtrlP'}) "{{{
"  call dein#add('tacahiroy/ctrlp-funky', {'depends': 'ctrlpvim/ctrlp.vim', 'on_cmd': 'CtrlP'})
"  let g:ctrlp_clear_cache_on_exit = 1
"  let g:ctrlp_max_height = 40
"  let g:ctrlp_show_hidden = 0
"  let g:ctrlp_follow_symlinks = 1
"  let g:ctrlp_max_files = 20000
"  let g:ctrlp_cache_dir = NavimGetCacheDir('ctrlp')
"  let g:ctrlp_reuse_window = 'startify'
"  let g:ctrlp_extensions = ['funky']
"  let g:ctrlp_custom_ignore = {
"      \ 'dir': '\v[\/]\.(git|hg|svn|idea)$',
"      \ 'file': '\v\.DS_Store$'
"      \ }
"
"  if executable('ag')
"    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
"  endif
"
"  nmap \ [ctrlp]
"  nnoremap [ctrlp] <Nop>
"
"  nnoremap [ctrlp]t :CtrlPBufTag<CR>
"  nnoremap [ctrlp]T :CtrlPTag<CR>
"  nnoremap [ctrlp]l :CtrlPLine<CR>
"  nnoremap [ctrlp]o :CtrlPFunky<CR>
"  nnoremap [ctrlp]b :CtrlPBuffer<CR>
""}}}
if g:navim_settings.explorer_plugin ==# 'nerdtree'
  "if g:navim_settings.encoding == 'utf-8' && has('multi_byte') && has('unix') && &encoding == 'utf-8' &&
  "    \ (empty(&termencoding) || &termencoding == 'utf-8')
  "call dein#add('scrooloose/nerdtree', {'on_cmd': ['NERDTreeToggle','NERDTreeFind']}) "{{{
  call dein#add('scrooloose/nerdtree') "{{{
    let g:NERDTreeShowHidden = 1
    let g:NERDTreeQuitOnOpen = 0
    let g:NERDTreeShowLineNumbers = 0
    let g:NERDTreeChDirMode = 0
    let g:NERDTreeShowBookmarks = 1
    let g:NERDTreeIgnore = ['\.git','\.hg','\.svn','\.DS_Store']
    let g:NERDTreeWinPos = 'right'
    let g:NERDTreeWinSize = 40
    let g:NERDTreeBookmarksFile = NavimGetCacheDir('nerdtreebookmarks')
    " close vim if the only window left open is a nerdtree
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType ==# "primary") | q | endif
  "}}}
  call dein#add('Xuyuanp/nerdtree-git-plugin') "{{{
  "}}}
  "endif
elseif g:navim_settings.explorer_plugin ==# 'defx'
  call dein#add('Shougo/defx.nvim', {'hook_done_update': function('NavimOnDoneUpdate')})
  call dein#add('kristijanhusak/defx-icons', {'depends': 'Shougo/defx.nvim', 'hook_done_update': function('NavimOnDoneUpdate')})
  call dein#add('kristijanhusak/defx-git', {'depends': 'Shougo/defx.nvim', 'hook_done_update': function('NavimOnDoneUpdate')})
  call defx#custom#column('filename', {
      \ 'min_width': 40,
      \ 'max_width': 40,
      \ })
  call defx#custom#option('_', {
      \ 'columns': 'mark:indent:git:icons:filename:type:size:time',
      \ })

  autocmd FileType defx call s:defx_my_settings()
  function! s:defx_my_settings() abort
    nnoremap <silent><buffer><expr> <CR>
        \ defx#do_action('drop')
    nnoremap <silent><buffer><expr> c
        \ defx#do_action('copy')
    nnoremap <silent><buffer><expr> m
        \ defx#do_action('move')
    nnoremap <silent><buffer><expr> p
        \ defx#do_action('paste')
    nnoremap <silent><buffer><expr> l
        \ defx#do_action('drop')
    nnoremap <silent><buffer><expr> P
        \ defx#do_action('open', 'pedit')
    nnoremap <silent><buffer><expr> o
        \ defx#do_action('open_or_close_tree')
    nnoremap <silent><buffer><expr> K
        \ defx#do_action('new_directory')
    nnoremap <silent><buffer><expr> N
        \ defx#do_action('new_file')
    nnoremap <silent><buffer><expr> M
        \ defx#do_action('new_multiple_files')
    nnoremap <silent><buffer><expr> C
        \ defx#do_action('toggle_columns',
        \                'mark:indent:icon:filename:type:size:time')
    nnoremap <silent><buffer><expr> S
        \ defx#do_action('toggle_sort', 'time')
    nnoremap <silent><buffer><expr> d
        \ defx#do_action('remove')
    nnoremap <silent><buffer><expr> r
        \ defx#do_action('rename')
    nnoremap <silent><buffer><expr> !
        \ defx#do_action('execute_command')
    nnoremap <silent><buffer><expr> x
        \ defx#do_action('execute_system')
    nnoremap <silent><buffer><expr> yy
        \ defx#do_action('yank_path')
    nnoremap <silent><buffer><expr> .
        \ defx#do_action('toggle_ignored_files')
    nnoremap <silent><buffer><expr> ;
        \ defx#do_action('repeat')
    nnoremap <silent><buffer><expr> h
        \ defx#do_action('cd', ['..'])
    nnoremap <silent><buffer><expr> ~
        \ defx#do_action('cd')
    nnoremap <silent><buffer><expr> q
        \ defx#do_action('quit')
    nnoremap <silent><buffer><expr> <Space>
        \ defx#do_action('toggle_select') . 'j'
    nnoremap <silent><buffer><expr> *
        \ defx#do_action('toggle_select_all')
    nnoremap <silent><buffer><expr> j
        \ line('.') == line('$') ? 'gg' : 'j'
    nnoremap <silent><buffer><expr> k
        \ line('.') == 1 ? 'G' : 'k'
    nnoremap <silent><buffer><expr> <C-l>
        \ defx#do_action('redraw')
    nnoremap <silent><buffer><expr> <C-g>
        \ defx#do_action('print')
    nnoremap <silent><buffer><expr> cd
        \ defx#do_action('change_vim_cwd')
  endfunction
endif
call dein#add('majutsushi/tagbar', {'on_cmd': 'TagbarToggle'}) "{{{
  let g:tagbar_left = 1
  let g:tagbar_width = 30
  let g:tagbar_autoclose = 0
"}}}
call dein#add('jeetsukumaran/vim-buffergator') "{{{
  let g:buffergator_suppress_keymaps = 1
  let g:buffergator_suppress_mru_switch_into_splits_keymaps = 1
  let g:buffergator_viewport_split_policy = "B"
  let g:buffergator_split_size = 10
  let g:buffergator_sort_regime = "mru"
  let g:buffergator_mru_cycle_loop = 0
"}}}


" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0

