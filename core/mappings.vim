" functions {{{

  function! <SID>EvalVimscript(begin, end)
    let lines = getline(a:begin, a:end)
    for line in lines
      execute line
    endfor
  endfunction

  function! <SID>CloseWindowOrKillBuffer()
    " never bdelete a nerd tree
    if matchstr(expand("%"), 'NERD') ==# 'NERD'
      wincmd c
      return
    endif

    let number_of_windows_to_this_buffer =
        \ len(filter(range(1, winnr('$')), "winbufnr(v:val) == bufnr('%')"))

    if number_of_windows_to_this_buffer > 1
      wincmd c
    else
      bdelete
    endif
  endfunction

  " highlight all instances of word under cursor, when idle.
  " useful when studying strange source code.
  function! <SID>AutoHighlightToggle()
    let @/ = ''
    if exists('#auto_highlight')
      autocmd! auto_highlight
      augroup! auto_highlight
      setlocal updatetime=4000
      "echo 'Highlight current word: off'
      return 0
    else
      augroup auto_highlight
        autocmd!
        if dein#is_sourced('coc.nvim')
          " highlight link CocHighlightText CursorColumn by default
          highlight link CocHighlightText WarningMsg
          autocmd CursorHold * silent call CocActionAsync('highlight')
        else
          " 3match conflicts with airline
          autocmd CursorHold * silent! execute printf('2match WarningMsg /\<%s\>/', expand('<cword>'))
        endif
      augroup end
      setlocal updatetime=20
      "echo 'Highlight current word: on'
      return 1
    endif
  endfunction

  function! <SID>ListToggle(bufname, pfx)
    let buflist = GetBufferList()
    for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "' . a:bufname . '"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
      if bufwinnr(bufnum) != -1
        execute a:pfx . 'close'
        return
      endif
    endfor
    if a:pfx ==# 'l' && len(getloclist(0)) == 0
      echohl ErrorMsg
      echo "Location List is Empty."
      return
    endif
    let winnr = winnr()
    execute a:pfx . 'window'
    if winnr() != winnr
      wincmd p
    endif
  endfunction

  " toggle just text
  function! <SID>JustTextToggle()
    if !exists('b:just_text')
      let b:just_text = 0
    endif
    if b:just_text == 0
      setlocal paste
      setlocal nolist
      setlocal nonumber
      let b:just_text = 1
      if exists('g:loaded_signify')
        execute 'silent! SignifyDisable<CR>'
      endif
      echo 'Just text: on'
      sign unplace *
      return 0
    else
      setlocal nopaste
      setlocal list
      setlocal number
      let b:just_text = 0
      if exists('g:loaded_signify')
        execute 'silent! SignifyEnable<CR>'
      endif
      echo 'Just text: off'
      return 1
    endif
  endfunction

  " maximize or restore current window in split structure
  " <http://vim.wikia.com/wiki/Maximize_window_and_return_to_previous_split_structure>
  function! <SID>MaximizeToggle()
    if exists('s:maximize_session')
      exec "source " . s:maximize_session
      call delete(s:maximize_session)
      unlet s:maximize_session
      let &hidden = s:maximize_hidden_save
      unlet s:maximize_hidden_save
    else
      let s:maximize_hidden_save = &hidden
      let s:maximize_session = tempname()
      set hidden
      exec "mksession! " . s:maximize_session
      only
    endif
  endfunction

  function! s:WriteCmdLine(str)
    execute "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
  endfunction

  function! <SID>VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction ==# 'backward'
      execute "normal ?" . l:pattern . "^M"
    elseif a:direction ==# 'forward'
      execute "normal /" . l:pattern . "^M"
    elseif a:direction ==# 'file'
      call s:WriteCmdLine("vimgrep " . '/' . l:pattern . '/j' . ' %')
    elseif a:direction ==# 'directory'
      call s:WriteCmdLine("vimgrep " . '/' . l:pattern . '/j' . ' **/*')
    elseif a:direction ==# 'replace'
      call s:WriteCmdLine("%s" . '/' . l:pattern . '/' . l:pattern . '/g')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
  endfunction

  function! <SID>GetVisualSelection()
    let [s:lnum1, s:col1] = getpos("'<")[1:2]
    let [s:lnum2, s:col2] = getpos("'>")[1:2]
    let s:lines = getline(s:lnum1, s:lnum2)
    let s:lines[-1] = s:lines[-1][: s:col2 - (&selection == 'inclusive' ? 1 : 2)]
    let s:lines[0] = s:lines[0][s:col1 - 1:]
    return join(s:lines, ' ')
  endfunction

"}}}

" mappings {{{

  " maximize or restore current window in split structure
  noremap <C-w>O :call <SID>MaximizeToggle()<CR>
  noremap <C-w>o :call <SID>MaximizeToggle()<CR>
  noremap <C-w><C-o> :call <SID>MaximizeToggle()<CR>

  " remap arrow keys
  nnoremap <Left> :bprev<CR>
  " :call LightLineBufferline()<CR>:call lightline#update()<CR>
  nnoremap <Right> :bnext<CR>
  " :call LightLineBufferline()<CR>:call lightline#update()<CR>
  "nnoremap <Up> :tabnext<CR>
  "nnoremap <Down> :tabprev<CR>

  " smash escape
  inoremap jk <Esc>
  inoremap kj <Esc>

  " change cursor position in insert mode
  " use S-BS instead of BS to delete in insert mode in some terminal
  inoremap <C-h> <Left>
  inoremap <C-l> <Right>

  inoremap <C-u> <C-g>u<C-u>

  " sane regex {{{
    nnoremap / /\v
    vnoremap / /\v
    nnoremap ? ?\v
    vnoremap ? ?\v
    nnoremap :s/ :s/\v
  " }}}

  " command-line window {{{
    nnoremap q: q:i
    nnoremap q/ q/i
    nnoremap q? q?i
  " }}}

  " folds {{{
    nnoremap zr zr:echo &foldlevel<CR>
    nnoremap zm zm:echo &foldlevel<CR>
    nnoremap zR zR:echo &foldlevel<CR>
    nnoremap zM zM:echo &foldlevel<CR>
  " }}}

  " screen line scroll {{{
    nnoremap <silent> j gj
    nnoremap <silent> k gk
  " }}}

  " auto center {{{
    nnoremap <silent> n nzz
    nnoremap <silent> N Nzz
    nnoremap <silent> * *zz
    nnoremap <silent> # #zz
    nnoremap <silent> g* g*zz
    nnoremap <silent> g# g#zz
    nnoremap <silent> <C-o> <C-o>zz
    nnoremap <silent> <C-i> <C-i>zz
  "}}}

  " reselect visual block after indent {{{
    vnoremap < <gv
    vnoremap > >gv
  "}}}

  " shortcuts for windows {{{
    " <http://stackoverflow.com/questions/9092982/mapping-c-j-to-something-in-vim>
    let g:C_Ctrl_j = 'off'
    let g:BASH_Ctrl_j = 'off'
    nnoremap <C-h> <C-w>h
    nnoremap <C-j> <C-w>j
    nnoremap <C-k> <C-w>k
    nnoremap <C-l> <C-w>l
  "}}}

  " make Y consistent with C and D. See :help Y.
  nnoremap Y y$

  " hide annoying quit message
  nnoremap <C-c> <C-c>:echo<CR>

  " window killer
  nnoremap <silent> Q :call <SID>CloseWindowOrKillBuffer()<CR>

  " map
  let g:lmap =  {}
  let g:llmap = {}

  nnoremap <silent> <SID>key-mappings :<C-u>Unite -toggle -auto-resize -buffer-name=mappings mapping<CR>
  nmap <Leader>? <SID>key-mappings

  nnoremap <silent> <SID>last-buffer :buffer#<CR>
  nmap <Leader><Tab> <SID>last-buffer

  " applications {{{

    let g:lmap.a = { 'name' : '+applications' }

    nnoremap <silent> <SID>undotree-toggle :UndotreeToggle<CR>
    nmap <Leader>au <SID>undotree-toggle

    nnoremap <SID>gdb :NeoDebug<CR>
    nmap <Leader>ag <SID>gdb

    nnoremap <SID>deol :Deol -split=horizontal<CR>
    nmap <Leader>as <SID>deol

  "}}}

  " buffers {{{

    let g:lmap.b = { 'name' : '+buffers' }

    nnoremap <silent> <SID>unite-quick-match-buffer :<C-u>Unite -toggle -auto-resize -quick-match buffer<CR>
    nmap <Leader>bm <SID>unite-quick-match-buffer

    if dein#is_sourced('denite.nvim')
      nnoremap <silent> <SID>denite-buffer :<C-u>Denite -auto-resize -buffer-name=buffers buffer file_mru<CR>
      nmap <Leader>bb <SID>denite-buffer
    elseif dein#is_sourced('unite.vim')
      nnoremap <silent> <SID>unite-buffer :<C-u>Unite -toggle -auto-resize -buffer-name=buffers buffer file_mru<CR>
      nmap <Leader>bb <SID>unite-buffer
    endif

    let g:lmap.b.k = { 'name' : '+buffer-kill' }

    let g:lmap.b.k['!'] = { 'name' : '+!' }
    nmap <silent> <SID>buffer-kill-back <Plug>BufKillBack
    nmap <Leader>bkb <SID>buffer-kill-back
    nmap <silent> <SID>buffer-kill-forward <Plug>BufKillForward
    nmap <Leader>bkf <SID>buffer-kill-forward
    nmap <silent> <SID>buffer-kill-bun <Plug>BufKillBun
    nmap <Leader>bku <SID>buffer-kill-bun
    nmap <silent> <SID>buffer-kill-bangbun <Plug>BufKillBangBun
    nmap <Leader>bk!u <SID>buffer-kill-bangbun
    nmap <silent> <SID>buffer-kill-bd <Plug>BufKillBd
    nmap <Leader>bkd <SID>buffer-kill-bd
    nmap <silent> <SID>buffer-kill-bangbd <Plug>BufKillBangBd
    nmap <Leader>bk!d <SID>buffer-kill-bangbd
    nmap <silent> <SID>buffer-kill-bw <Plug>BufKillBw
    nmap <Leader>bkw <SID>buffer-kill-bw
    nmap <silent> <SID>buffer-kill-bangbw <Plug>BufKillBangBw
    nmap <Leader>bk!w <SID>buffer-kill-bangbw
    nmap <silent> <SID>buffer-kill-undo <Plug>BufKillUndo
    nmap <Leader>bko <SID>buffer-kill-undo
    nmap <silent> <SID>buffer-kill-alt <Plug>BufKillAlt
    nmap <Leader>bka <SID>buffer-kill-alt

    if dein#is_sourced('vim-buffergator')

      " buffergator
      nnoremap <silent> <SID>buffer-preview :BuffergatorOpen<CR>
      nmap <Leader>bp <SID>buffer-preview
      nnoremap <silent> <M-b> :BuffergatorMruCyclePrev<CR>
      nnoremap <silent> <M-S-b> :BuffergatorMruCycleNext<CR>
      nnoremap <silent> [b :BuffergatorMruCyclePrev<CR>
      nnoremap <silent> ]b :BuffergatorMruCycleNext<CR>

    endif

  "}}}

  " clang {{{

    if dein#is_sourced('coc.nvim')

      let g:lmap.c = { 'name' : '+clang' }

      " gotos
      nmap <silent> <Leader>cd <Plug>(coc-definition)
      nmap <silent> <Leader>cy <Plug>(coc-type-definition)
      nmap <silent> <Leader>ci <Plug>(coc-implementation)
      nmap <silent> <Leader>cr <Plug>(coc-references)

      " rename current word
      nmap <Leader>cn <Plug>(coc-rename)

      " format selected region
      xmap <Leader>cf <Plug>(coc-format-selected)
      nmap <Leader>cf <Plug>(coc-format-selected)
      nmap <silent> <Leader>cm <Plug>(coc-format)

      " show documentation in preview window
      nnoremap <silent> <SID>show-doc :call <SID>ShowDoc()<CR>
      nmap <Leader>ch <SID>show-doc
      function! <SID>ShowDoc()
        if (index(['vim', 'help'], &filetype) >= 0)
          execute 'h '.expand('<cword>')
        else
          call CocAction('doHover')
        endif
      endfunction

    endif

  "}}}

  " debug {{{

    let g:lmap.d = { 'name' : '+debug' }

    nnoremap <silent> <SID>debug-start :exe ":profile start profile.log"<CR>:exe ":profile func *"<CR>:exe ":profile file *"<CR>
    nmap <Leader>ds <SID>debug-start
    nnoremap <silent> <SID>profile-pause :exe ":profile pause"<CR>
    nmap <Leader>dp <SID>profile-pause
    nnoremap <silent> <SID>profile-continue :exe ":profile continue"<CR>
    nmap <Leader>dc <SID>profile-continue
    nnoremap <silent> <SID>profile-quit :exe ":profile pause"<CR>:noautocmd qall!<CR>
    nmap <Leader>dq <SID>profile-quit

  "}}}

  " files {{{

    let g:lmap.f = { 'name' : '+files' }

    if dein#is_sourced('denite.nvim')
      nnoremap <silent> <SID>denite-file :<C-u>Denite -auto-resize -buffer-name=files file_rec<CR><C-u>
      nmap <Leader>ff <SID>denite-file
    elseif dein#is_sourced('unite.vim')
      if g:navim_platform_windows
        nnoremap <silent> <SID>unite-file :<C-u>Unite -toggle -auto-resize -buffer-name=files file:!<CR><C-u>
      else
        nnoremap <silent> <SID>unite-file :<C-u>Unite -toggle -auto-resize -buffer-name=files file/async:!<CR><C-u>
      endif
      nmap <Leader>ff <SID>unite-file
    endif

    if dein#is_sourced('neomru.vim')
      " -auto-preview
      if dein#is_sourced('denite.nvim')
        nnoremap <silent> <SID>denite-mixed :<C-u>Denite -auto-resize -buffer-name=mixed buffer file_rec file_mru bookmark<CR><C-u>
        nmap <Leader>fm <SID>denite-mixed
      elseif dein#is_sourced('unite.vim')
        if g:navim_platform_windows
          nnoremap <silent> <SID>unite-mixed :<C-u>Unite -toggle -auto-resize -buffer-name=mixed buffer file:! file_mru bookmark<CR><C-u>
        else
          nnoremap <silent> <SID>unite-mixed :<C-u>Unite -toggle -auto-resize -buffer-name=mixed buffer file/async:! file_mru bookmark<CR><C-u>
        endif
        nmap <Leader>fm <SID>unite-mixed
      endif
    endif

    if dein#is_sourced('neomru.vim')
      if dein#is_sourced('denite.nvim')
        nnoremap <silent> <SID>denite-mru :<C-u>Denite -auto-resize -buffer-name=recent file_mru<CR>
        nmap <Leader>fr <SID>denite-mru
      elseif dein#is_sourced('unite.vim')
        nnoremap <silent> <SID>unite-mru :<C-u>Unite -toggle -auto-resize -buffer-name=recent file_mru<CR>
        nmap <Leader>fr <SID>unite-mru
      endif
    endif

    if dein#is_sourced('nerdtree')
      nnoremap <silent> <SID>nerdtree-toggle :NERDTreeToggle<CR>
      nmap <Leader>ft <SID>nerdtree-toggle
      nnoremap <silent> <SID>nerdtree-find :NERDTreeFind<CR>
      nmap <Leader>fT <SID>nerdtree-find
    elseif dein#is_sourced('defx.nvim')
      nnoremap <silent> <SID>defx-toggle :Defx -split=vertical -toggle -winwidth=40 -direction=botright<CR>
      nmap <Leader>ft <SID>defx-toggle
      nnoremap <silent> <SID>defx-find :Defx `expand('%:p:h')` -search=`expand('%:p')` -split=vertical -winwidth=40 -direction=botright<CR>
      nmap <Leader>fT <SID>defx-find
    elseif dein#is_sourced('vimfiler.vim')
      nnoremap <silent> <SID>vimfiler-toggle :VimFilerExplorer -toggle -winwidth=40 -direction=botright<CR>
      nmap <Leader>ft <SID>vimfiler-toggle
      nnoremap <silent> <SID>vimfiler-find :VimFilerExplorer -find -winwidth=40 -direction=botright<CR>
      nmap <Leader>fT <SID>vimfiler-find
      "nnoremap <silent> <Leader>n :VimFiler -toggle -split -buffer-name=explorer -winwidth=40 -no-quit -direction=botright<CR>
      "nnoremap <silent> <Leader>nf :VimFiler -find -toggle -split -buffer-name=explorer -winwidth=40 -no-quit -direction=botright<CR>
    endif

    let g:lmap.f.v = { 'name' : '+vim' }

    let g:lmap.f.a = ['A', 'alternate-file']
    let g:lmap.f.s = ['w', 'save-buffer']
    let g:lmap.f.v.d = ['e ~/.unvimrc', 'edit-dotfile']
    let g:lmap.f.v.i = ['e $MYVIMRC', 'edit-init-file']
    "let g:lmap.f.v.R = ['source $MYVIMRC', 'reload-configuration']

  "}}}

  " git/versions-control {{{

    let g:lmap.g = { 'name' : '+git/versions-control' }

    nnoremap <silent> <SID>git-blame :Gblame<CR>
    nmap <Leader>gb <SID>git-blame
    nnoremap <silent> <SID>git-commit :Gcommit<CR>
    nmap <Leader>gc <SID>git-commit
    nnoremap <silent> <SID>git-diff :Gdiff<CR>
    nmap <Leader>gd <SID>git-diff
    nnoremap <silent> <SID>git-log :Glog<CR>
    nmap <Leader>gl <SID>git-log
    nnoremap <silent> <SID>git-push :Git push<CR>
    nmap <Leader>gp <SID>git-push
    nnoremap <silent> <SID>git-remove :Gremove<CR>
    nmap <Leader>gr <SID>git-remove
    nnoremap <silent> <SID>git-status :Gstatus<CR>
    nmap <Leader>gs <SID>git-status
    nnoremap <silent> <SID>git-v :Gitv<CR>
    nmap <Leader>gv <SID>git-v
    nnoremap <silent> <SID>git-v! :Gitv!<CR>
    nmap <Leader>gV <SID>git-v!
    nnoremap <silent> <SID>git-write :Gwrite<CR>
    nmap <Leader>gw <SID>git-write

  "}}}

  " search/symbol {{{

    let g:lmap.s = { 'name' : '+search/symbol' }

    " search current word in current directory
    nnoremap <SID>grep-word-in-directory :execute "vimgrep /" .
        \ expand("<cword>") . "/j **/*"<CR>:copen<CR>
    nmap <Leader>sd <SID>grep-word-in-directory

    " search the selected text in current directory
    vnoremap <SID>grep-in-directory :call <SID>VisualSelection('directory')<CR>
    vmap <Leader>sd <SID>grep-in-directory

    " search current word in current file
    nnoremap <SID>grep-word-in-file :execute "vimgrep /" .
        \ expand("<cword>") . "/j %"<CR>:copen<CR>
    nmap <Leader>sf <SID>grep-word-in-file

    " search the selected text in current directory
    vnoremap <SID>grep-in-file :call <SID>VisualSelection('file')<CR>
    vmap <Leader>sf <SID>grep-in-file

    let g:lmap.s.g = { 'name' : '+grep' }

    " search specific content in current directory
    nnoremap <SID>grep-in-directory :vimgrep /\<<C-r>=expand("<cword>")<CR>\>/j **/*<Left><Left><Left><Left><Left><Left><Left><Left><Left>
    nmap <Leader>sgd <SID>grep-in-directory

    let g:lmap.s.g.e = ['GrepOptions', 'easygrep-options']

    " search specific content in current file
    nnoremap <SID>grep-in-file :vimgrep /\<<C-r>=expand("<cword>")<CR>\>/j <C-r>%
    nmap <Leader>sgf <SID>grep-in-file

    " repeat last search
    nnoremap <SID>grep-last :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>
    nmap <Leader>sl <SID>grep-last

    " replace specific content
    nnoremap <SID>replace-in-file :%s/\<<C-r>=expand("<cword>")<CR>\>/<C-r>=expand("<cword>")<CR>/g<Left><Left>
    nmap <Leader>sr <SID>replace-in-file

    " replace the selected text
    vnoremap <SID>replace-in-file :call <SID>VisualSelection('replace')<CR>
    vmap <Leader>sr <SID>replace-in-file

    if dein#is_sourced('denite.nvim')
      nnoremap <silent> <SID>denite-cursorword :<C-u>DeniteCursorWord -no-quit -auto-resize -buffer-name=search grep:.<CR>
      nmap <Leader>ss <SID>denite-cursorword
    elseif dein#is_sourced('unite.vim')
      nnoremap <silent> <SID>unite-cursorword :<C-u>UniteWithCursorWord -no-quit -toggle -auto-resize -buffer-name=search grep:.<CR>
      nmap <Leader>ss <SID>unite-cursorword
    endif

    let g:lmap.s.t = { 'name' : '+tags' }

    if dein#is_sourced('asyncrun.vim')
      nnoremap <SID>create-tags :AsyncRun! gtags;cscope -Rbq;ctags -R<CR>
      nnoremap <SID>remove-tags :AsyncRun! rm tags;rm cscope.in.out;rm cscope.out;rm cscope.po.out;rm GTAGS;rm GRTAGS;rm GPATH<CR>
    elseif dein#is_sourced('vim-dispatch')
      nnoremap <SID>create-tags :Dispatch gtags;cscope -Rbq;ctags -R<CR>
      nnoremap <SID>remove-tags :Dispatch rm tags;rm cscope.in.out;rm cscope.out;rm cscope.po.out;rm GTAGS;rm GRTAGS;rm GPATH<CR>
    endif
    nmap <Leader>sta <SID>create-tags
    nmap <Leader>stv <SID>remove-tags

    " cscope
    if has("cscope")
      if g:navim_settings.cscopeprg ==# 'gtags-cscope'  " global

        " go to definition
        nnoremap <SID>gtags-definition :Gtags -d <C-r>=expand("<cword>")<CR>
        "vnoremap <SID>gtags-definition <Esc>:execute 'Gtags ' . <SID>GetVisualSelection()
        nmap <Leader>std <SID>gtags-definition

        " locate strings
        nnoremap [cscope]e :Gtags -g <C-r>=expand("<cword>")<CR>
        "nnoremap <SID>gtags-strings :execute 'Gtags -g ' . expand('<cword>')
        "vnoremap <SID>gtags-strings <Esc>:execute 'Gtags -g ' . <SID>GetVisualSelection()
        nmap <Leader>ste <SID>gtags-strings

        " get a list of tags in specified files
        nnoremap <SID>gtags-files :Gtags -f %<CR>
        "vnoremap <SID>gtags-files <Esc>:execute 'Gtags -f ' . <SID>GetVisualSelection()
        nmap <Leader>stf <SID>gtags-files

        " go to definition or reference
        nnoremap <SID>gtags-cursor :GtagsCursor<CR>
        nmap <Leader>stg <SID>gtags-cursor

        " find reference
        nnoremap <SID>gtags-reference :Gtags -r <C-r>=expand("<cword>")<CR>
        "vnoremap <SID>gtags-reference <Esc>:execute 'Gtags -r ' . <SID>GetVisualSelection()
        nmap <Leader>str <SID>gtags-reference

        " locate symbols which are not defined in `GTAGS`
        nnoremap <SID>gtags-symbols :Gtags -s <C-r>=expand("<cword>")<CR>
        "vnoremap <SID>gtags-symbols <Esc>:execute 'Gtags -s ' . <SID>GetVisualSelection()
        nmap <Leader>sts <SID>gtags-symbols

      elseif g:navim_settings.cscopeprg ==# 'cscope'  " cscope

        " calls: find all calls to the function name under cursor
        nnoremap <SID>cscope-calls :cscope find c <C-r>=expand("<cword>")<CR>
        "vnoremap <SID>cscope-calls <Esc>:execute 'cscope find c ' . <SID>GetVisualSelection()
        nmap <Leader>stc <SID>cscope-calls

        " called: find functions that function under cursor calls
        nnoremap <SID>cscope-called :cscope find d <C-r>=expand("<cword>")<CR>
        "vnoremap <SID>cscope-called <Esc>:execute 'cscope find d ' . <SID>GetVisualSelection()
        nmap <Leader>std <SID>cscope-called

        " egrep:  egrep search for the word under cursor
        nnoremap <SID>cscope-egrep :cscope find e <C-r>=expand("<cword>")<CR>
        "vnoremap <SID>cscope-egrep <Esc>:execute 'cscope find e ' . <SID>GetVisualSelection()
        nmap <Leader>ste <SID>cscope-egrep

        " file: open the filename under cursor
        nnoremap <SID>cscope-file :cscope find f <C-r>=expand("<cword>")<CR>
        "vnoremap <SID>cscope-file <Esc>:execute 'cscope find f ' . <SID>GetVisualSelection()
        nmap <Leader>stf <SID>cscope-file

        " global: find global definition(s) of the token under cursor
        nnoremap <SID>cscope-global :cscope find g <C-r>=expand("<cword>")<CR>
        "vnoremap <SID>cscope-global <Esc>:execute 'cscope find g ' . <SID>GetVisualSelection()
        nmap <Leader>stg <SID>cscope-global

        " symbol: find all references to the token under cursor
        nnoremap <SID>cscope-symbol :cscope find s <C-r>=expand("<cword>")<CR>
        "vnoremap <SID>cscope-symbol <Esc>:execute 'cscope find s ' . <SID>GetVisualSelection()
        nmap <Leader>sts <SID>cscope-symbol

        " text: find all instances of the text under cursor
        nnoremap <SID>cscope-text :cscope find t <C-r>=expand("<cword>")<CR>
        "vnoremap <SID>cscope-text <Esc>:execute 'cscope find t ' . <SID>GetVisualSelection()
        nmap <Leader>stt <SID>cscope-text

        " includes: find files that include the filename under cursor
        nnoremap <SID>cscope-includes :cscope find i <C-r>=expand("<cfile>")<CR>
        "vnoremap <SID>cscope-includes <Esc>:execute 'cscope find i ' . <SID>GetVisualSelection()
        "nnoremap <SID>cscope-includes :execute 'cscope find i ' . expand('<cword>')
        "nnoremap <SID>cscope-includes :cscope find i ^<C-r>=expand("<cfile>")<CR>$
        "nnoremap <SID>cscope-includes :tab split<CR>:execute "cscope find i " . expand("<cword>")
        "nnoremap <SID>cscope-includes :tab split<CR>:execute "cscope find i ^" . expand("<cword>") . "$"
        nmap <Leader>sti <SID>cscope-includes

      endif
    endif

  "}}}

  " toggles {{{

    let g:lmap.t = { 'name' : '+toggles' }

    let g:lmap.t.h = { 'name' : '+highlight' }

    "nnoremap <SID>automatic-symbol-highlight :if <SID>AutoHighlightToggle()<Bar>set hlsearch<Bar>endif<CR>
    nnoremap <SID>automatic-symbol-highlight :call <SID>AutoHighlightToggle()<CR>
    nmap <Leader>tha <SID>automatic-symbol-highlight
    call <SID>AutoHighlightToggle()

    nmap <silent> <SID>indent-guides <Plug>IndentGuidesToggle
    nmap <Leader>ti <SID>indent-guides

    nnoremap <silent> <SID>tabbar :TagbarToggle<CR>
    nmap <Leader>tt <SID>tabbar

    nmap <silent> <SID>golden-ratio <Plug>ToggleGoldenViewAutoResize
    nmap <Leader>tg <SID>golden-ratio

    "let g:lmap.t.j = ['call <SID>JustTextToggle()', 'just-text']

    nnoremap <silent> <SID>just-text :call <SID>JustTextToggle()<CR>
    nmap <Leader>tj <SID>just-text

    nnoremap <silent> <SID>location :call <SID>ListToggle("Location List", 'l')<CR>
    nmap <Leader>tl <SID>location

    nnoremap <silent> <SID>line-numbers :set number!<CR>
    nmap <Leader>tn <SID>line-numbers

    nnoremap <silent> <SID>quickfix :call <SID>ListToggle("Quickfix List", 'c')<CR>
    nmap <Leader>tq <SID>quickfix

    nnoremap <silent> <SID>whitespace :set list!<CR>
    nmap <Leader>tw <SID>whitespace

  "}}}

  " jump {{{

    let g:lmap.j = { 'name' : '+jump' }

    if dein#is_sourced('denite.nvim')
      nnoremap <silent> <SID>denite-line :<C-u>Denite -auto-resize -buffer-name=line line<CR>
      nmap <Leader>jl <SID>denite-line

      nnoremap <silent> <SID>denite-outline :<C-u>Denite -auto-resize -buffer-name=outline outline<CR>
      nmap <Leader>jo <SID>denite-outline
    elseif dein#is_sourced('unite.vim')
      nnoremap <silent> <SID>unite-line :<C-u>Unite -toggle -auto-resize -buffer-name=line line<CR>
      nmap <Leader>jl <SID>unite-line

      nnoremap <silent> <SID>unite-outline :<C-u>Unite -toggle -auto-resize -buffer-name=outline outline<CR>
      nmap <Leader>jo <SID>unite-outline
    endif

    if dein#is_sourced('unite-gtags')

      " lists the references or definitions of a word
      " `global --from-here=<location of cursor> -qe <word on cursor>`
      nnoremap <silent> <SID>unite-gtags-context :execute 'Unite gtags/context'<CR>
      nmap <Leader>jc <SID>unite-gtags-context

      " lists definitions of a word
      " `global -qd -e <pattern>`
      nnoremap <silent> <SID>unite-gtags-def :execute 'Unite gtags/def:'.expand('<cword>')<CR>
      nmap <Leader>jd <SID>unite-gtags-def
      vnoremap <silent> <SID>unite-gtags-def <ESC>:execute 'Unite gtags/def:'.<SID>GetVisualSelection()<CR>
      vmap <Leader>jd <SID>unite-gtags-def

      " lists current file's tokens in GTAGS
      " `global -f`
      nnoremap <silent> <SID>unite-gtags-file :execute 'Unite gtags/file'<CR>
      nmap <Leader>jf <SID>unite-gtags-file

      " lists grep result of a word
      " `global -qg -e <pattern>`
      nnoremap <silent> <SID>unite-gtags-grep :execute 'Unite gtags/grep:'.expand('<cword>')<CR>
      nmap <Leader>jg <SID>unite-gtags-grep
      vnoremap <silent> <SID>unite-gtags-grep <ESC>:execute 'Unite gtags/grep:'.<SID>GetVisualSelection()<CR>
      vmap <Leader>jg <SID>unite-gtags-grep

      " lists all tokens in GTAGS
      " `global -c`
      nnoremap <silent> <SID>unite-gtags-completion :execute 'Unite gtags/completion'<CR>
      nmap <Leader>jm <SID>unite-gtags-completion

      " lists references of a word
      " `global -qrs -e <pattern>`
      nnoremap <silent> <SID>unite-gtags-ref :execute 'Unite gtags/ref:'.expand('<cword>')<CR>
      nmap <Leader>jr <SID>unite-gtags-ref
      vnoremap <silent> <SID>unite-gtags-ref <ESC>:execute 'Unite gtags/ref:'.<SID>GetVisualSelection()<CR>
      vmap <Leader>jr <SID>unite-gtags-ref

    endif

    if dein#is_sourced('unite-airline_themes') && dein#is_sourced('vim-airline')
      nnoremap <silent> <SID>unite-airline-themes :<C-u>Unite -toggle -winheight=10 -auto-preview -buffer-name=airline_themes airline_themes<CR>
      nmap <Leader>ja <SID>unite-airline-themes
    endif

    if dein#is_sourced('denite.nvim')
      nnoremap <silent> <SID>denite-help :<C-u>Denite -auto-resize -buffer-name=help help<CR>
      nmap <Leader>jh <SID>denite-help
    elseif dein#is_sourced('unite-help')
      nnoremap <silent> <SID>unite-help :<C-u>Unite -toggle -auto-resize -buffer-name=help help<CR>
      nmap <Leader>jh <SID>unite-help
    endif

    if dein#is_sourced('denite.nvim')
      nnoremap <silent> <SID>denite-colorschemes :<C-u>Denite -winheight=10 -auto-preview -buffer-name=colorschemes colorscheme<CR>
      nmap <Leader>js <SID>denite-colorschemes
    elseif dein#is_sourced('unite-colorscheme')
      nnoremap <silent> <SID>unite-colorschemes :<C-u>Unite -toggle -winheight=10 -auto-preview -buffer-name=colorschemes colorscheme<CR>
      nmap <Leader>js <SID>unite-colorschemes
    endif

    if dein#is_sourced('junkfile.vim')
      nnoremap <silent> <SID>unite-junkfile :<C-u>Unite -toggle -auto-resize -buffer-name=junk junkfile junkfile/new<CR>
      nmap <Leader>jj <SID>unite-junkfile
    endif

    if dein#is_sourced('unite-tag')
      nnoremap <silent> <SID>unite-tag :<C-u>Unite -toggle -auto-resize -buffer-name=tag tag tag/file<CR>
      nmap <Leader>jt <SID>unite-tag
    endif

    if dein#is_sourced('neoyank.vim')
      if dein#is_sourced('denite.nvim')
        nnoremap <silent> <SID>unite-history :<C-u>Denite -auto-resize -buffer-name=yanks history/yank<CR>
        nmap <Leader>jy <SID>unite-history
      elseif dein#is_sourced('unite.vim')
        nnoremap <silent> <SID>unite-history :<C-u>Unite -toggle -auto-resize -buffer-name=yanks history/yank<CR>
        nmap <Leader>jy <SID>unite-history
      endif
    endif

  "}}}

  " windows {{{

    let g:lmap.w = { 'name' : '+windows' }

    nnoremap <silent> <SID>balance-windows <C-w>=
    nmap <Leader>w= <SID>balance-windows

    let g:lmap.w.a = ['vert sba', 'show-all-buffer']

    let g:lmap.w.e = { 'name' : '+sessions' }

    let g:lmap.w.e.s = ['SaveSession!', 'save-session']

    let g:lmap.w.e.r = ['OpenSession!', 'restore-session']

    let g:lmap.w.p = { 'name' : '+postion' }

    " cecutil
    map <SID>save-cursor-position <Plug>SaveWinPosn
    map <Leader>wps <SID>save-cursor-position

    map <SID>restore-cursor-position <Plug>RestoreWinPosn
    map <Leader>wpr <SID>restore-cursor-position

    let g:lmap.w.r = { 'name' : '+resize' }

    " increase the window size by a factor
    nnoremap <silent> <SID>increase-width :exe 'vertical resize ' . (winwidth(0) * 5/4)<CR>
    nmap <Leader>wr= <SID>increase-width

    " decrease the window size by a factor
    nnoremap <silent> <SID>decrease-width :exe 'vertical resize ' . (winwidth(0) * 3/4)<CR>
    nmap <Leader>wr- <SID>decrease-width

    nnoremap <SID>maximize-toggle :call <SID>MaximizeToggle()<CR>
    nmap <Leader>wrm <SID>maximize-toggle

    let g:lmap.w.s = ['split', 'split-window-below']

    let g:lmap.w.t = { 'name' : '+tabs' }

    let g:lmap.w.v = ['vsplit', 'split-window-right']

    " tab
    nnoremap <SID>tab-new :tabnew<CR>
    nmap <Leader>wtn <SID>tab-new

    nnoremap <SID>tab-close :tabclose<CR>
    nmap <Leader>wtc <SID>tab-close

    " tabular
    "nmap <Leader>a& :Tabularize /&<CR>
    "vmap <Leader>a& :Tabularize /&<CR>
    "nmap <Leader>a= :Tabularize /=<CR>
    "vmap <Leader>a= :Tabularize /=<CR>
    "nmap <Leader>a: :Tabularize /:<CR>
    "vmap <Leader>a: :Tabularize /:<CR>
    "nmap <Leader>a:: :Tabularize /:\zs<CR>
    "vmap <Leader>a:: :Tabularize /:\zs<CR>
    "nmap <Leader>a, :Tabularize /,<CR>
    "vmap <Leader>a, :Tabularize /,<CR>
    "nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
    "vmap <Leader>a<Bar> :Tabularize /<Bar><CR>

  "}}}

  " text {{{

    let g:lmap.x = { 'name' : '+text' }

    let g:lmap.x.l = { 'name' : '+lines' }

    " <https://vi.stackexchange.com/questions/7149/mapping-a-command-in-visual-mode-results-in-error-e481-no-range-alllowed>
    noremap <SID>clang-format :<C-u>exe 'py3f ' .
        \ g:navim_settings.clang_dir . g:navim_path_separator .
        \ 'share' . g:navim_path_separator . 'clang' .
        \ g:navim_path_separator . 'clang-format.py'<CR>
    map <Leader>xc <SID>clang-format

    nnoremap <SID>format-file :call <SID>Preserve("normal gg=G")<CR>
    nmap <Leader>xf <SID>format-file

    " repeatable copy and paste. fake the behavior in windows
    nnoremap <SID>repeatable-paste viw"zp
    nmap <Leader>xp <SID>repeatable-paste

    nnoremap <SID>repeatable-copy "zyiw
    nmap <Leader>xy <SID>repeatable-copy

    vnoremap <SID>repeatable-paste "zp
    vmap <Leader>xp <SID>repeatable-paste

    vnoremap <SID>repeatable-copy "zy
    vmap <Leader>xy <SID>repeatable-copy

    " reselect last paste
    nnoremap <expr> <SID>reselect-last-paste '`[' . strpart(getregtype(), 0, 1) . '`]'
    nmap <Leader>xr <SID>reselect-last-paste

    " formatting

    " remove the windows ^M when the encodings gets messed up
    noremap <SID>remove-windows-endl mmHmt:%s/<C-V><CR>//ge<CR>'tzt'm
    nmap <Leader>xm <SID>remove-windows-endl

    nnoremap <SID>remove-trailing-whitespace :call NavimStripTrailingWhitespace()<CR>
    nmap <Leader>xt <SID>remove-trailing-whitespace

    " eval vimscript by line or visual selection
    nnoremap <silent> <SID>eval-vimscript :call <SID>EvalVimscript(line('.'), line('.'))<CR>
    nmap <Leader>xe <SID>eval-vimscript
    vnoremap <silent> <SID>eval-vimscript :call <SID>EvalVimscript(line('v'), line('.'))<CR>
    vmap <Leader>xe <SID>eval-vimscript

    vnoremap <SID>sort-lines :sort<CR>
    vmap <Leader>xls <SID>sort-lines

  "}}}

  function! s:my_displayfunc()
    let g:leaderGuide#displayname =
        \ substitute(g:leaderGuide#displayname, '\c<CR>$', '', '')
    let g:leaderGuide#displayname =
        \ substitute(g:leaderGuide#displayname, '^<Plug>', '', '')
    let g:leaderGuide#displayname =
        \ substitute(g:leaderGuide#displayname, '^<SID>', '', '')
  endfunction
  let g:leaderGuide_displayfunc = [function("s:my_displayfunc")]

  let g:topdict = {}
  let g:topdict[' '] = g:lmap
  let g:topdict[' ']['name'] = '<Leader>'
  let g:topdict[','] = g:llmap
  let g:topdict[',']['name'] = '<LocalLeader>'
  call leaderGuide#register_prefix_descriptions("", "g:topdict")

  nnoremap <silent><nowait> <Leader> :<C-u>LeaderGuide '<Space>'<CR>
  vnoremap <silent><nowait> <Leader> :<C-u>LeaderGuideVisual '<Space>'<CR>
  map <Leader>. <Plug>leaderguide-global

  nnoremap <silent><nowait> <LocalLeader> :<C-u>LeaderGuide  ','<CR>
  vnoremap <silent><nowait> <LocalLeader> :<C-u>LeaderGuideVisual  ','<CR>
  map <LocalLeader>. <Plug>leaderguide-buffer

"}}}


" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0

