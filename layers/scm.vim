" functions {{{

"}}}

if g:navim_settings.encoding ==# 'utf-8' && has('multi_byte') && has('unix') && &encoding ==# 'utf-8' &&
    \ (empty(&termencoding) || &termencoding ==# 'utf-8')
  call dein#add('mhinz/vim-signify') "{{{
    let g:signify_update_on_bufenter = 0
  "}}}
endif
call dein#add('tpope/vim-fugitive') "{{{
  autocmd BufReadPost fugitive://* set bufhidden=delete
"}}}
call dein#add('tpope/vim-rhubarb', {'depends': 'tpope/vim-fugitive'})
call dein#add('gregsexton/gitv', {'depends': 'tpope/vim-fugitive', 'on_cmd': 'Gitv'})


" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0

