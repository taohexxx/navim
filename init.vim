" platform {{{

  let g:navim_platform_macos = 0
  let g:navim_platform_unix = 0
  let g:navim_platform_cygwin = 0
  let g:navim_platform_windows = 0
  if has('unix')
    if has('macunix')
      let g:navim_platform_macos = 1
    elseif has('win32unix')
      let g:navim_platform_cygwin = 1
    else
      let g:navim_platform_unix = 1
    endif
  elseif has('win64') || has('win32')
    let g:navim_platform_windows = 1
  endif
  let g:navim_platform_macvim = has('gui_macvim')
  let g:navim_platform_neovim = has('nvim')
  let g:navim_has_python3 = (has('pythonx') && &pyxversion == 3) || has('python3')
  let g:navim_has_python2 = (has('pythonx') && &pyxversion == 2) || has('python2')
  let g:navim_path_separator = '/'

  let maplocalleader = ','
  let mapleader = ' '
  let g:mapleader = ' '

  if !exists('g:navim_settings')
    let g:navim_settings = {}
  endif

"}}}

" user settings {{{

  if has('win64') || has('win32')
    if filereadable(expand('~\_navimrc'))
      source ~\_navimrc
    endif
  else
    if filereadable(expand('~/.navimrc'))
      source ~/.navimrc
    endif
  endif

" }}}

" before all {{{

  if exists('*BeforeAll')
    call BeforeAll()
  endif

" }}}

" main {{{

  if (v:version < 800)
    echoerr "navim requires Neovim (or Vim 8). INSTALL IT! You'll thank me later!"
    finish
  endif

  "execute 'set runtimepath+=' . fnamemodify(resolve(expand('<sfile>')), ':p:h') .
  "    \ g:navim_path_separator . 'core'
  execute 'source ' . fnamemodify(resolve(expand('<sfile>')), ':p:h') .
      \ g:navim_path_separator . 'core' . g:navim_path_separator . 'main.vim'

" }}}

" after all {{{

  if exists('*AfterAll')
    call AfterAll()
  endif

" }}}


" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0

