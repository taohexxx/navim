" functions {{{

"}}}

call dein#add('groenewege/vim-less', {'on_ft': 'less'})
call dein#add('cakebaker/scss-syntax.vim', {'on_ft': ['scss','sass']})
call dein#add('hail2u/vim-css3-syntax', {'on_ft': ['css','scss','sass']})
call dein#add('ap/vim-css-color',
    \ {'on_ft': ['css','scss','sass','less','styl']})
call dein#add('othree/html5.vim', {'on_ft': 'html'})
call dein#add('wavded/vim-stylus', {'on_ft': 'styl'})
call dein#add('digitaltoad/vim-jade', {'on_ft': 'jade'})
call dein#add('mustache/vim-mustache-handlebars',
    \ {'on_ft': ['mustache','handlebars']})
call dein#add('gregsexton/MatchTag', {'on_ft': ['html','xml']})
call dein#add('mattn/emmet-vim', {'on_ft': ['html','xml','xsl','xslt',
    \ 'xsd','css','sass','scss','less', 'mustache','handlebars']}) "{{{
  function! s:zen_html_tab()
    if !emmet#isExpandable()
      return "\<plug>(emmet-move-next)"
    endif
    return "\<plug>(emmet-expand-abbr)"
  endfunction
  autocmd FileType xml,xsl,xslt,xsd,css,sass,scss,less,mustache imap <buffer><Tab> <C-y>,
  autocmd FileType html imap <buffer><expr><Tab> s:zen_html_tab()
"}}}


" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0

