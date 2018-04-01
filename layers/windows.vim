" functions {{{

"}}}

call dein#add('PProvost/vim-ps1', {'on_ft': 'ps1'}) "{{{
  autocmd BufNewFile,BufRead *.ps1,*.psd1,*.psm1 setlocal ft=ps1
"}}}
call dein#add('nosami/Omnisharp', {'on_ft': 'cs'})


" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0

