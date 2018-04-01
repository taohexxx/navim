" functions {{{

  " toggle quickfix list and location list
  function! GetBufferList()
    redir =>buflist
    silent! ls
    redir END
    return buflist
  endfunction

  function! s:BufInfo()
    echo "\n----- buffer info -----"
    echo "bufnr('%')=" . bufnr('%') . " // current buffer number"
    echo "bufnr('$')=" . bufnr('$') . " // tail buffer number"
    echo "bufnr('#')=" . bufnr('#') . " // previous buffer number"
    for i in range(1, bufnr('$'))
      echo "bufexists(" . i . ")=" . bufexists(i)
      echon " buflisted(" . i . ")=" . buflisted(i)
      echon " bufloaded(" . i . ")=" . bufloaded(i)
      echon " bufname(" . i . ")=" . bufname(i)
    endfor
    echo "// bufexists(n)= buffer n exists"
    echo "// buflisted(n)= buffer n listed"
    echo "// bufloaded(n)= buffer n loaded"
    echo "// bufname(n)= buffer name"

    echo "\n----- window info -----"
    echo "winnr()="    . winnr()    . " // current window number"
    echo "winnr('$')=" . winnr('$') . " // tail window number"
    echo "winnr('#')=" . winnr('#') . " // previous window number"
    for i in range(1, winnr('$'))
      echo "winbufnr(" . i . ")=" . winbufnr(i) . " // window " . i . "'s buffer number"
    endfor

    echo "\n----- tab info -----"
    echo "tabpagenr()="    . tabpagenr()    . ' // current tab number'
    echo "tabpagenr('$')=" . tabpagenr('$') . ' // tail tab number'
    for i in range(1, tabpagenr('$'))
      echo 'tabpagebuflist(' . i . ')='
      echon tabpagebuflist(i)
      echon " // tab " . i . "'s buffer list"
    endfor
    for i in range(1, tabpagenr('$'))
      echo "tabpagewinnr(" . i . ")=" . tabpagewinnr(i)
      echon " tabpagewinnr(" . i . ", '$')=" . tabpagewinnr(i, '$')
      echon " tabpagewinnr(" . i . ", '#')=" . tabpagewinnr(i, '#')
    endfor
    echo "// tabpagewinnr(n)     = tab n's current window number"
    echo "// tabpagewinnr(n, '$')= tab n's tail window number"
    echo "// tabpagewinnr(n, '#')= tab n's previous window number"

  endfunction

  function! s:Indent4Space()
    set expandtab
    set tabstop=4
    set softtabstop=4
    set shiftwidth=4
  endfunction

  function! s:Indent2Space()
    set expandtab
    set tabstop=2
    set softtabstop=2
    set shiftwidth=2
  endfunction

  function! s:Indent4Tab()
    set noexpandtab
    set tabstop=4
    set softtabstop=4
    set shiftwidth=4
  endfunction

  function! s:Indent2Tab()
    set noexpandtab
    set tabstop=2
    set softtabstop=2
    set shiftwidth=2
  endfunction

"}}}

" commands {{{

  command! -bang Q q<bang>
  command! -bang QA qa<bang>
  command! -bang Qa qa<bang>

  command! -nargs=0 BufInfo call s:BufInfo()

  command! -nargs=0 Indent4Space call s:Indent4Space()
  command! -nargs=0 Indent2Space call s:Indent2Space()
  command! -nargs=0 Indent4Tab call s:Indent4Tab()
  command! -nargs=0 Indent2Tab call s:Indent2Tab()

" }}}


" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0

