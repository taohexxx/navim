" functions {{{

"}}}

call dein#add('klen/python-mode', {'on_ft': 'python'}) "{{{
  let g:pymode_rope = 0
"}}}

if g:navim_settings.completion_plugin !=# 'ycm' "{{{
  call dein#add('davidhalter/jedi-vim', {'on_ft': 'python'}) "{{{
    let g:jedi#popup_on_dot = 0
  "}}}
endif "}}}


" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0

