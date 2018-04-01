augroup navim_edit
  autocmd!

  " go back to previous position of cursor if any
  autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe 'normal! g`"zvzz' |
      \ endif

  " quickfix window always on the bottom taking the whole horizontal space
  autocmd FileType qf wincmd J
augroup end


augroup navim_map
  autocmd!

  " a.vim
  autocmd FileType c,cpp silent! unmap <Leader>ih
  autocmd FileType c,cpp silent! unmap <Leader>is
  autocmd FileType c,cpp silent! unmap <Leader>ihn
augroup end


augroup navim_filetype
  autocmd!

  autocmd BufRead,BufNewFile *.md,*.markdown set filetype=ghmarkdown
  autocmd BufRead,BufNewFile *.editorconfig set filetype=dosini
augroup end


augroup navim_format
  autocmd!

  autocmd FileType js,scss,css autocmd BufWritePre <buffer> call NavimStripTrailingWhitespace()
  autocmd FileType css,scss setlocal foldmethod=marker foldmarker={,}
  autocmd FileType css,scss nnoremap <silent> <SID>sort vi{:sort<CR>
  autocmd FileType css,scss nmap <LocalLeader>s <SID>sort
  autocmd FileType python autocmd BufWritePre <buffer> call NavimStripTrailingWhitespace()
  autocmd FileType python setlocal foldmethod=indent
  autocmd FileType php autocmd BufWritePre <buffer> call NavimStripTrailingWhitespace()
  autocmd FileType coffee autocmd BufWritePre <buffer> call NavimStripTrailingWhitespace()
  autocmd FileType vim setlocal foldmethod=indent keywordprg=:help

  " vim-jsbeautify
  if dein#is_sourced('vim-jsbeautify')
    autocmd FileType javascript nnoremap <silent> <SID>js-beautify :call JsBeautify()<CR>
    autocmd FileType javascript nmap <LocalLeader>j <SID>js-beautify
  endif
augroup end


" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0

