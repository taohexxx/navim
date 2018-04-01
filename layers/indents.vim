" functions {{{

"}}}

call dein#add('nathanaelkane/vim-indent-guides') "{{{
  let g:indent_guides_start_level = 1
  let g:indent_guides_guide_size = 1
  let g:indent_guides_enable_on_vim_startup = 0
  let g:indent_guides_color_change_percent = 3
  "if !has('gui_running')
  "  let g:indent_guides_auto_colors=0
  "  function! s:indent_set_console_colors()
  "    hi IndentGuidesOdd ctermbg=235
  "    hi IndentGuidesEven ctermbg=236
  "  endfunction
  "  autocmd VimEnter,Colorscheme * call s:indent_set_console_colors()
  "endif
"}}}


" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0

