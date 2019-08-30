" init {{{

  let s:nvim_dir = get(g:navim_settings, 'nvim_dir',
      \ fnamemodify(resolve(expand('<sfile>')), ':p:h:h'))
  let s:cache_dir = s:nvim_dir . g:navim_path_separator . '.cache'

"}}}

" functions {{{

  function! NavimGetDir(suffix) "{{{
    return resolve(expand(s:nvim_dir . g:navim_path_separator . a:suffix))
  endfunction "}}}

  function! NavimGetCacheDir(suffix) "{{{
    return resolve(expand(s:cache_dir . g:navim_path_separator . a:suffix))
  endfunction "}}}

  function! NavimOnDoneUpdate() "{{{
    if exists('g:navim_updated_rplugins')
      return
    endif
    call dein#remote_plugins()
    let g:navim_updated_rplugins = 1
  endfunction "}}}

  function! NavimPreserve(command) "{{{
    " preparation: save last search and cursor position
    let l:_s = @/
    let l:l = line(".")
    let l:c = col(".")
    " do the business
    execute a:command
    " clean up: restore previous search history, and cursor position
    let @/ = l:_s
    call cursor(l:l, l:c)
  endfunction "}}}

  function! NavimStripTrailingWhitespace() "{{{
    call NavimPreserve("%s/\\s\\+$//e")
  endfunction "}}}

  function! s:EnsureExists(path) "{{{
    if !isdirectory(expand(a:path))
      call mkdir(expand(a:path))
    endif
  endfunction "}}}

  function! s:InsertIfNotExists(map, key, value) "{{{
    if !has_key(a:map, a:key)
      let a:map[a:key] = a:value
    endif
  endfunction "}}}

  function! s:SourceLayers(path) "{{{
    for f in split(glob(a:path . g:navim_path_separator . '*.nvim\|*.vim'), '\n')
      let l:layer_name = fnamemodify(f, ':t:r')
      if count(g:navim_settings.layers, l:layer_name)
        execute 'source ' . f
      endif
    endfor
  endfunction "}}}

  function! s:AddTags(path) "{{{
    for f in split(glob(a:path . g:navim_path_separator . '*.tags'), '\n')
      execute 'set tags+=' . f
    endfor
  endfunction "}}}

"}}}

" init settings {{{

  " core
  call s:InsertIfNotExists(g:navim_settings, 'encoding', 'utf-8')
  call s:InsertIfNotExists(g:navim_settings, 'default_indent', 2)
  call s:InsertIfNotExists(g:navim_settings, 'bin_dir', '')
  call s:InsertIfNotExists(g:navim_settings, 'cscopeprg', 'gtags-cscope')

  " plugins
  call s:InsertIfNotExists(g:navim_settings, 'completion_plugin', '')
  call s:InsertIfNotExists(g:navim_settings, 'syntaxcheck_plugin', '')
  call s:InsertIfNotExists(g:navim_settings, 'explorer_plugin', 'nerdtree')
  call s:InsertIfNotExists(g:navim_settings, 'statusline_plugin', 'airline')
  call s:InsertIfNotExists(g:navim_settings, 'fonts_plugin', '')

  " user interface
  call s:InsertIfNotExists(g:navim_settings, 'colorscheme', 'jellybeans')
  call s:InsertIfNotExists(g:navim_settings, 'force256', 0)
  call s:InsertIfNotExists(g:navim_settings, 'termtrans', 0)
  call s:InsertIfNotExists(g:navim_settings, 'enable_cursorcolumn', 0)
  call s:InsertIfNotExists(g:navim_settings, 'max_column', 80)
  call s:InsertIfNotExists(g:navim_settings, 'nerd_fonts', 0)
  call s:InsertIfNotExists(g:navim_settings, 'powerline_fonts', 0)

  " layers
  if !exists('g:navim_settings.layers')
    let g:navim_settings.layers = []
    call add(g:navim_settings.layers, 'c')
    call add(g:navim_settings.layers, 'completion')
    call add(g:navim_settings.layers, 'core')
    call add(g:navim_settings.layers, 'editing')
    call add(g:navim_settings.layers, 'go')
    call add(g:navim_settings.layers, 'indents')
    call add(g:navim_settings.layers, 'javascript')
    call add(g:navim_settings.layers, 'language')
    call add(g:navim_settings.layers, 'misc')
    call add(g:navim_settings.layers, 'navigation')
    call add(g:navim_settings.layers, 'python')
    call add(g:navim_settings.layers, 'ruby')
    call add(g:navim_settings.layers, 'scala')
    call add(g:navim_settings.layers, 'scm')
    call add(g:navim_settings.layers, 'textobj')
    call add(g:navim_settings.layers, 'typescript')
    call add(g:navim_settings.layers, 'unite')
    call add(g:navim_settings.layers, 'web')
    if g:navim_platform_windows
      call add(g:navim_settings.layers, 'windows')
    endif
  endif

  " excluded layers
  if exists('g:navim_settings.excluded_layers')
    for layer in g:navim_settings.excluded_layers
      let s:i = index(g:navim_settings.layers, layer)
      if s:i != -1
        call remove(g:navim_settings.layers, s:i)
      endif
    endfor
  endif

  " additional plugins
  if !exists('g:navim_settings.additional_plugins')
    let g:navim_settings.additional_plugins = []
  endif

  " disabled plugins
  if !exists('g:navim_settings.disabled_plugins')
    let g:navim_settings.disabled_plugins = []
    call add(g:navim_settings.disabled_plugins, 'junkfile.vim')
    call add(g:navim_settings.disabled_plugins, 'unite-airline_themes')
    call add(g:navim_settings.disabled_plugins, 'unite-colorscheme')
    call add(g:navim_settings.disabled_plugins, 'unite-help')
    call add(g:navim_settings.disabled_plugins, 'unite-tag')
  endif

  " plugin auto select "{{{

    if empty(g:navim_settings.completion_plugin)
      if g:navim_platform_neovim && g:navim_has_python3
        let g:navim_settings.completion_plugin = 'deoplete'
      else
        let g:navim_settings.completion_plugin = 'coc'
      "elseif g:navim_has_python3 || g:navim_has_python2
      "  let s:ycmd_path = NavimGetDir('bundle') . g:navim_path_separator .
      "      \ 'repos' . g:navim_path_separator .
      "      \ 'github.com' . g:navim_path_separator .
      "      \ 'Valloric' . g:navim_path_separator .
      "      \ 'YouCompleteMe' . g:navim_path_separator .
      "      \ 'third_party' . g:navim_path_separator . 'ycmd'
      "  if filereadable(expand(s:ycmd_path . g:navim_path_separator .
      "      \ 'ycm_core.so'))
      "    let g:navim_settings.completion_plugin = 'ycm'
      "  endif
      endif
    endif

    if empty(g:navim_settings.syntaxcheck_plugin)
      let g:navim_settings.syntaxcheck_plugin = 'ale'
    endif

    if g:navim_settings.nerd_fonts != 0 &&
        \ g:navim_settings.encoding ==# 'utf-8' &&
        \ has('multi_byte') && has('unix') && &encoding ==# 'utf-8' &&
        \ (empty(&termencoding) || &termencoding ==# 'utf-8') "{{{
        let g:navim_settings.fonts_plugin = 'vim-devicons'
    endif "}}}

  "}}}

"}}}

" setup & dein {{{

  set nocompatible
  set all&  " reset everything to their defaults
  let s:github_path = NavimGetDir('bundle') . g:navim_path_separator .
      \ 'repos' . g:navim_path_separator . 'github.com'
  let s:dein_path = s:github_path . g:navim_path_separator .
      \ 'Shougo' . g:navim_path_separator . 'dein.vim'
  let s:ale_path = s:github_path . g:navim_path_separator .
      \ 'w0rp' . g:navim_path_separator . 'ale'
  execute 'set runtimepath+=' . s:dein_path
  if g:navim_settings.syntaxcheck_plugin ==# 'ale'
    execute 'set runtimepath+=' . s:ale_path
  endif

  if !empty(g:navim_settings.bin_dir) &&
      \ isdirectory(expand(g:navim_settings.bin_dir))
    " cscopeprg
    if g:navim_settings.cscopeprg ==# 'gtags-cscope' &&
        \ filereadable(expand(g:navim_settings.bin_dir . '/gtags-cscope'))
      execute 'set cscopeprg=' . g:navim_settings.bin_dir . '/gtags-cscope'
    elseif g:navim_settings.cscopeprg ==# 'cscope' &&
        \ filereadable(expand(g:navim_settings.bin_dir . '/cscope'))
      execute 'set cscopeprg=' . g:navim_settings.bin_dir . '/cscope'
    endif

    " ctags
    if filereadable(expand(g:navim_settings.bin_dir . '/ctags'))
      let g:tagbar_ctags_bin = g:navim_settings.bin_dir . '/ctags'
    endif
  else
    " cscopeprg
    if g:navim_settings.cscopeprg ==# 'gtags-cscope'
      set cscopeprg=gtags-cscope
    elseif g:navim_settings.cscopeprg ==# 'cscope'
      set cscopeprg=cscope
    endif
  endif

  "if dein#load_state(NavimGetDir('bundle'))
  call dein#begin(NavimGetDir('bundle'))
  call dein#add('Shougo/dein.vim')

  if !g:navim_platform_neovim && g:navim_has_python3
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif

  call dein#local(NavimGetDir('private_bundle'))

"}}}

" base configuration {{{

  set timeoutlen=300  " mapping timeout
  set ttimeoutlen=50  " keycode timeout

  " mouse
  "set mouse&
  set mouse=a  " enable mouse
  if !g:navim_platform_neovim
    if has("mouse_sgr")
      set ttymouse=sgr
    else
      set ttymouse=xterm2
    endif
  endif
  set mousehide  " hide when characters are typed
  set history=1000  " number of command lines to remember
  set ttyfast  " assume fast terminal connection
  set viewoptions=folds,options,cursor,unix,slash  " unix/windows compatibility
  if exists('$TMUX')
    set clipboard=
  else
    set clipboard=unnamed  " sync with OS clipboard
  endif
  set hidden  " allow buffer switching without saving
  set autoread  " auto reload if file saved externally
  set fileformats+=mac  " add mac to auto-detection of file format line endings
  set nrformats-=octal  " always assume decimal numbers
  set showcmd

  " tags
  set tags=./tags,tags

  " add all tags, which should be done before set wildignore
  call s:AddTags(NavimGetDir('tags'))

  set showfulltag
  set modeline
  set modelines=5

  if g:navim_platform_windows && !g:navim_platform_cygwin
    " ensure correct shell in gvim
    set shell=c:\windows\system32\cmd.exe
  endif

  if $SHELL =~ '/fish$'
    " vim expects to be run from a POSIX shell.
    set shell=sh
  endif

  set noshelltemp  " use pipes

  " whitespace
  set backspace=indent,eol,start  " allow backspacing everything in insert mode

  " <http://vim.wikia.com/wiki/Indenting_source_code>
  " number of spaces when indenting
  let &shiftwidth = g:navim_settings.default_indent
  " number of spaces per tab for display
  let &tabstop = g:navim_settings.default_indent
  " number of spaces per tab in insert mode
  let &softtabstop = g:navim_settings.default_indent
  "set expandtab  " use spaces instead of tabs
  set smarttab  " use shiftwidth to enter tabs
  set autoindent  " automatically indent to match adjacent lines
  " the amount of indent for a continuation line for vim script
  let g:vim_indent_cont = &shiftwidth * 2

  set list  "highlight whitespace
  set shiftround
  set linebreak

  set scrolloff=10  " minimum number of lines above and below cursor
  set scrolljump=1  "minimum number of lines to scroll
  set sidescrolloff=5  " minimum number of columns to left and right of cursor
  set display+=lastline
  set wildmenu  "show list for autocomplete
  set wildmode=list:full
  set wildignore+=*~,*.o,core.*,*.exe,.git/,.hg/,.svn/,.DS_Store,*.pyc
  set wildignore+=*.swp,*.swo,*.class,*.tags,tags,tags-*,cscope.*,*.taghl
  set wildignore+=.ropeproject/,__pycache__/,venv/,*.min.*,images/,img/,fonts/
  set wildignorecase

  set splitbelow
  set splitright

  " disable sounds
  set noerrorbells
  set novisualbell
  set t_vb=

  " searching
  set hlsearch  " highlight searches
  set incsearch  " incremental searching
  set ignorecase  " ignore case for searching
  set smartcase  " do case-sensitive if there's a capital letter
  " [Feature comparison of ack, ag, git-grep, GNU grep and ripgrep](https://beyondgrep.com/feature-comparison/)
  if executable('rg')
    " <https://github.com/BurntSushi/ripgrep>
    set grepprg=rg\ --no-heading\ --column\ --smart-case\ --color=never\ --follow
    set grepformat=%f:%l:%c:%m
  elseif executable('ag')
    " <https://geoff.greer.fm/ag/>
    set grepprg=ag\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow
    set grepformat=%f:%l:%c:%m
  elseif executable('ack')
    " <https://beyondgrep.com>
    set grepprg=ack\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow
    set grepformat=%f:%l:%c:%m
  endif

  " directory management {{{

    " persistent undo
    if exists('+undofile')
      set undofile
      let &undodir = NavimGetCacheDir('undo')
    endif

    " backups
    set backup
    let &backupdir = NavimGetCacheDir('backup')

    " swap files
    let &directory = NavimGetCacheDir('swap')
    set noswapfile

    call s:EnsureExists(s:cache_dir)
    call s:EnsureExists(&undodir)
    call s:EnsureExists(&backupdir)
    call s:EnsureExists(&directory)

  "}}}

"}}}

" ui configuration {{{

  set showmatch  " automatically highlight matching braces/brackets/etc.
  set matchtime=2  " tens of a second to show matching parentheses
  set number
  set lazyredraw
  set laststatus=2
  set noshowmode
  set foldenable  " enable folds by default
  set foldmethod=syntax  " fold via syntax of files
  set foldlevelstart=99  " open all folds by default
  let g:xml_syntax_folding = 1  " enable xml folding

  set cursorline
  autocmd WinLeave * setlocal nocursorline
  autocmd WinEnter * setlocal cursorline
  let &colorcolumn = g:navim_settings.max_column
  if g:navim_settings.enable_cursorcolumn
    set cursorcolumn
    autocmd WinLeave * setlocal nocursorcolumn
    autocmd WinEnter * setlocal cursorcolumn
  endif

  if has('gui_running')
    " open maximized
    set lines=999 columns=9999
    if g:navim_platform_windows
      autocmd GUIEnter * simalt ~x
    endif

    set guioptions+=t  " tear off menu items
    set guioptions-=T  " toolbar icons

    if g:navim_platform_macvim
      set gfn=Ubuntu_Mono:h14
      set transparency=2
    endif

    if g:navim_platform_windows
      set gfn=Ubuntu_Mono:h10
    endif

    if has('gui_gtk')
      set gfn=Ubuntu\ Mono\ 11
    endif
  else
    if $COLORTERM ==# 'gnome-terminal'
      set t_Co=256  " why you no tell me correct colors?!?!
    endif
    if $TERM_PROGRAM ==# 'iTerm.app'
      " different cursors for insert vs normal mode
      if exists('$TMUX')
        let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
        let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
      else
        let &t_SI = "\<Esc>]50;CursorShape=1\x7"
        let &t_EI = "\<Esc>]50;CursorShape=0\x7"
      endif
    endif
  endif

"}}}

" layers configuration {{{

  if count(g:navim_settings.layers, 'core')
    call dein#add('taohexxx/vim-leader-guide')
    if g:navim_settings.statusline_plugin ==# 'airline'
      "if g:navim_settings.encoding ==# 'utf-8' &&
      "    \ has('multi_byte') && has('unix') && &encoding ==# 'utf-8' &&
      "    \ (empty(&termencoding) || &termencoding ==# 'utf-8')
        call dein#add('vim-airline/vim-airline') "{{{
          let g:airline_powerline_fonts = g:navim_settings.powerline_fonts
          let g:airline_section_b = ''
          let g:airline_section_warning = ''
          let g:airline_mode_map = {
              \ '__' : '-',
              \ 'n'  : 'N',
              \ 'i'  : 'I',
              \ 'R'  : 'R',
              \ 'c'  : 'C',
              \ 'v'  : 'V',
              \ 'V'  : 'V',
              \ '^V' : 'V',
              \ 's'  : 'S',
              \ 'S'  : 'S',
              \ '^S' : 'S',
              \ }
          let g:airline#extensions#bufferline#enabled = 0
          let g:airline#extensions#bufferline#overwrite_variables = 1
          let g:airline#extensions#tabline#enabled = 1
          let g:airline#extensions#tabline#buffers_label = 'b'
          let g:airline#extensions#tabline#tabs_label = 't'
          let g:airline#extensions#tabline#buffer_nr_show = 1
          let g:airline#extensions#tabline#buffer_nr_format = '%s '
          let g:airline#extensions#tabline#fnamecollapse = 1
          let g:airline#extensions#tabline#fnametruncate = 12
          if g:navim_settings.syntaxcheck_plugin ==# 'syntastic'
            let g:airline#extensions#syntastic#enabled = 1
          endif
        "}}}
        call dein#add('vim-airline/vim-airline-themes')
      "endif
    elseif g:navim_settings.statusline_plugin ==# 'lightline'
      "call dein#add('zefei/vim-wintabs')
      "call dein#add('bling/vim-bufferline') "{{{
      "  function! LightlineBufferline()
      "    "if !empty(glob("lightline.vim"))
      "    if exists('*bufferline#refresh_status')
      "      call bufferline#refresh_status()
      "    endif
      "    let b = g:lightline_buffer_status_info.before
      "    let c = g:lightline_buffer_status_info.current
      "    let a = g:lightline_buffer_status_info.after
      "    return b . c . a
      "  endfunction
      ""}}}
      call dein#add('itchyny/lightline.vim') "{{{
        set showtabline=2  " always show tabline

        function! LightlineTag()
          " :help tagbar-statusline
          let line = tagbar#currenttag('%s', '')
          return line
        endfunction

        function! LightlineSyntaxcheck()
          if exists('*ALEGetStatusLine')
            return ALEGetStatusLine()
          elseif exists('*SyntasticStatuslineFlag')
            return SyntasticStatuslineFlag()
          endif
          return ''
        endfunction

        function! LightlineModified()
          return &ft =~? 'help' ? '' : &modified ?
              \ g:lightline_buffer_modified_icon : &modifiable ? '' : '-'
        endfunction

        function! LightlineReadonly()
          return &ft !~? 'help' && &readonly ? g:lightline_buffer_readonly_icon : ''
        endfunction

        function! LightlineFugitive()
          if exists('*fugitive#head')
            let _ = fugitive#head()
            return strlen(_) ? g:lightline_buffer_git_icon . _ : ''
          endif
          return ''
        endfunction

        function! LightlineFileinfo()
          return winwidth(0) > 70 ?
              \ (LightlineFileencoding() . ' ' . LightlineFileformat()) : ''
        endfunction

        function! LightlineFilename()
          let fname = expand('%:.')
          return fname ==# 'ControlP' ? g:lightline.ctrlp_item :
              \ fname ==# '__Tagbar__' ? g:lightline.fname :
              \ fname =~# '__Gundo\|NERD_tree' ? '' :
              \ &ft ==# 'vimfiler' ? vimfiler#get_status_string() :
              \ &ft ==# 'unite' ? unite#get_status_string() :
              \ &ft ==# 'vimshell' ? vimshell#get_status_string() :
              \ ('' !=# LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
              \ ('' !=# fname ? fname : '[No Name]') .
              \ ('' !=# LightlineModified() ? ' ' . LightlineModified() : '')
        endfunction

        function! LightlineFileformat()
          if exists('*WebDevIconsGetFileFormatSymbol')  " support for vim-devicons
            return WebDevIconsGetFileFormatSymbol()
          endif
          return &fileformat
        endfunction

        function! LightlineFiletype()
          if exists('*WebDevIconsGetFileTypeSymbol')  " support for vim-devicons
            return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' .
                \ WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
          endif
          return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
        endfunction

        function! LightlineFileencoding()
          return strlen(&fenc) ? &fenc : &enc
        endfunction

        function! LightlineMode()
          let fname = expand('%:t')
          return fname ==# '__Tagbar__' ? 'Tagbar' :
              \ fname ==# 'ControlP' ? 'CtrlP' :
              \ fname ==# '__Gundo__' ? 'Gundo' :
              \ fname ==# '__Gundo_Preview__' ? 'Gundo Preview' :
              \ fname =~# 'NERD_tree' ? 'NERDTree' :
              \ &ft ==# 'unite' ? 'Unite' :
              \ &ft ==# 'vimfiler' ? 'VimFiler' :
              \ &ft ==# 'vimshell' ? 'VimShell' :
              \ winwidth(0) > 60 ? lightline#mode() : ''
        endfunction

        function! CocCurrentFunction()
          return get(b:, 'coc_current_function', '')
        endfunction

        function! CtrlPMark()
          if expand('%:t') =~# 'ControlP'
            call lightline#link('iR'[g:lightline.ctrlp_regex])
            return lightline#concatenate([g:lightline.ctrlp_prev,
                \ g:lightline.ctrlp_item, g:lightline.ctrlp_next], 0)
          else
            return ''
          endif
        endfunction

        let g:ctrlp_status_func = {
            \ 'main': 'CtrlPStatusFunc_1',
            \ 'prog': 'CtrlPStatusFunc_2',
            \ }

        function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
          let g:lightline.ctrlp_regex = a:regex
          let g:lightline.ctrlp_prev = a:prev
          let g:lightline.ctrlp_item = a:item
          let g:lightline.ctrlp_next = a:next
          return lightline#statusline(0)
        endfunction

        function! CtrlPStatusFunc_2(str)
          return lightline#statusline(0)
        endfunction

        let g:tagbar_status_func = 'TagbarStatusFunc'

        function! TagbarStatusFunc(current, sort, fname, ...) abort
          let g:lightline.fname = a:fname
          return lightline#statusline(0)
        endfunction

        augroup AutoSyntastic
          autocmd!
          autocmd BufWritePost *.c,*.cpp call s:syntastic()
        augroup END
        function! s:syntastic()
          if g:navim_settings.syntaxcheck_plugin ==# 'syntastic'
            SyntasticCheck
          endif
          if g:navim_settings.statusline_plugin ==# 'lightline'
            call lightline#update()
          endif
        endfunction

        " disable overwriting the statusline forcibly by other plugins
        let g:unite_force_overwrite_statusline = 0
        let g:vimfiler_force_overwrite_statusline = 0
        let g:vimshell_force_overwrite_statusline = 0

      "}}}
      call dein#add('taohexxx/lightline-buffer', {'depends': 'itchyny/lightline.vim'})
      if g:navim_settings.colorscheme ==# 'solarized'
        call dein#add('taohexxx/lightline-solarized', {'depends': 'itchyny/lightline.vim'})
      endif
    endif
    call dein#add('skywind3000/asyncrun.vim')
    call dein#add('tpope/vim-surround')
    call dein#add('tpope/vim-repeat')
    call dein#add('tpope/vim-eunuch')
    call dein#add('tpope/vim-unimpaired') "{{{
      nmap <C-Up> [e
      nmap <C-Down> ]e
      vmap <C-Up> [egv
      vmap <C-Down> ]egv
    "}}}
  endif

  call s:SourceLayers(NavimGetDir('layers'))
  call s:SourceLayers(NavimGetDir('private_layers'))

"}}}

" color schemes {{{

  call dein#add('nanotech/jellybeans.vim')
  if g:navim_settings.colorscheme ==# 'solarized'
    call dein#add('taohexxx/vim-colors-solarized')
    let g:solarized_termcolors = 256
    let g:solarized_termtrans = 1
  elseif g:navim_settings.colorscheme ==# 'molokai'
    call dein#add('justinmk/molokai')
  endif

"}}}

" finish loading {{{

  if exists('g:navim_settings.additional_plugins')
    for plugin in g:navim_settings.additional_plugins
      call dein#add(plugin)
    endfor
  endif

  if exists('g:navim_settings.disabled_plugins')
    for plugin in g:navim_settings.disabled_plugins
      call dein#disable(plugin)
    endfor
  endif

  call dein#end()
  "call dein#save_state()
  "endif
  if dein#check_install()
    call dein#install()
  endif

  autocmd VimEnter * call dein#call_hook('post_source')

  filetype plugin indent on
  syntax enable
  execute 'colorscheme ' . g:navim_settings.colorscheme

"}}}

" user interface {{{

  " color
  set t_Co=256
  try
    " run `:syntax` to view highlight
    if g:navim_settings.colorscheme ==# 'molokai'
      let g:molokai_original = 1
      colorscheme molokai
      set background=dark
      highlight NonText ctermfg=235 guifg=#262626
      highlight SpecialKey ctermfg=235 guifg=#262626
      "highlight PmenuSel ctermfg=231 guifg=#FFFFFF
      highlight CTagsClass ctermfg=81 guifg=#66D9EF
    elseif g:navim_settings.colorscheme ==# 'solarized'
      " 16 color palette is recommended
      " <https://github.com/altercation/vim-colors-solarized>
      if g:navim_settings.force256 == 1
        let g:solarized_termcolors = 256
      else
        let g:solarized_termcolors = 16
      endif
      let g:solarized_termtrans = g:navim_settings.termtrans
      let g:solarized_degrade = 0
      set background=dark
      " <https://github.com/seanbell/term-tools/issues/2>
      " run `:help signify` to view signify highlight
      " run `:help highlight-groups` to view vim highlight
      colorscheme solarized
      if g:navim_settings.force256 == 1
        highlight NonText ctermfg=236 ctermbg=none
        highlight SpecialKey ctermfg=236 ctermbg=none
        highlight LineNr ctermfg=240 ctermbg=0
        highlight CursorLine ctermbg=0
        "highlight CursorLineNr
        highlight CTagsClass ctermfg=125
      else
        execute 'highlight! CTagsClass' . g:solarized_vars['fmt_none'] .
            \ g:solarized_vars['fg_magenta'] . g:solarized_vars['bg_none']

        " highlight lines in signify and vimdiff etc.
        "execute 'highlight! DiffAdd' . g:solarized_vars['fmt_none'] .
        "    \ g:solarized_vars['fg_green'] . g:solarized_vars['bg_base02']
        "execute 'highlight! DiffDelete' . g:solarized_vars['fmt_none'] .
        "    \ g:solarized_vars['fg_red']  . g:solarized_vars['bg_base02']
        "execute 'highlight! DiffChange' . g:solarized_vars['fmt_none'] .
        "    \ g:solarized_vars['fg_yellow'] . g:solarized_vars['bg_base02']

        " highlight signs in signify
        "execute 'highlight! SignifySignAdd' . g:solarized_vars['fmt_none'] .
        "    \ g:solarized_vars['fg_green'] . g:solarized_vars['bg_base02']
        "execute 'highlight! SignifySignDelete' .
        "    \ g:solarized_vars['fmt_none'] .
        "    \ g:solarized_vars['fg_red'] . g:solarized_vars['bg_base02']
        "execute 'highlight! SignifySignChange' .
        "    \ g:solarized_vars['fmt_none'] .
        "    \ g:solarized_vars['fg_yellow'] . g:solarized_vars['bg_base02']

        " indent guides
        let g:indent_guides_auto_colors = 0
        " bg_cyan
        execute 'autocmd VimEnter,Colorscheme * :highlight! IndentGuidesOdd' .
            \ g:solarized_vars['fmt_none'] . g:solarized_vars['fg_base03'] .
            \ g:solarized_vars['bg_base02']
        execute 'autocmd VimEnter,Colorscheme * :highlight! IndentGuidesEven' .
            \ g:solarized_vars['fmt_none'] . g:solarized_vars['fg_base03'] .
            \ g:solarized_vars['bg_base02']
      endif
    endif
  catch
    set background=dark
    colorscheme default
  endtry

"}}}

" load other scripts {{{

  execute 'source ' . NavimGetDir('core') . g:navim_path_separator .
      \ 'autocmds.vim'
  execute 'source ' . NavimGetDir('core') . g:navim_path_separator .
      \ 'commands.vim'
  execute 'source ' . NavimGetDir('core') . g:navim_path_separator .
      \ 'mappings.vim'

  if g:navim_settings.encoding ==# 'utf-8'
    execute 'source ' . NavimGetDir('encoding') . g:navim_path_separator .
        \ 'utf-8.vim'
  elseif g:navim_settings.encoding ==# 'gbk'
    execute 'source ' . NavimGetDir('encoding') . g:navim_path_separator .
        \ 'gbk.vim'
  else
    execute 'source ' . NavimGetDir('encoding') . g:navim_path_separator .
        \ 'latin1.vim'
  endif

  execute 'helptags ' .  NavimGetDir('doc')

"}}}


" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0

