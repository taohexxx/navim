" functions {{{

"}}}

call dein#add('ternjs/tern_for_vim', {'on_ft': 'javascript', 'build': 'npm install'})
call dein#add('pangloss/vim-javascript', {'on_ft': 'javascript'})
call dein#add('mxw/vim-jsx', {'on_ft': 'javascript'}) "{{{
  let g:jsx_ext_required = 0
  "let g:jsx_pragma_required = 1
"}}}
call dein#add('maksimr/vim-jsbeautify', {'on_ft': 'javascript'})
call dein#add('leafgarland/typescript-vim', {'on_ft': 'typescript'})
call dein#add('kchmck/vim-coffee-script', {'on_ft': 'coffee'})
call dein#add('mmalecki/vim-node.js', {'on_ft': 'javascript'})
call dein#add('leshill/vim-json', {'on_ft': ['javascript','json']})
call dein#add('othree/javascript-libraries-syntax.vim', {'on_ft': ['javascript','coffee','ls','typescript']})


" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0

