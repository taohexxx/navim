" functions {{{

"}}}

if g:navim_settings.fonts_plugin ==# 'vim-devicons'
  call dein#add('ryanoasis/vim-devicons')
  "let g:WebDevIconsOS = 'Darwin'
  call dein#add('tiagofumo/vim-nerdtree-syntax-highlight')
endif
call dein#add('xolox/vim-misc')
call dein#add('xolox/vim-session') "{{{
  let g:session_directory = NavimGetCacheDir('sessions')
  let g:session_autoload = 'no'
  let g:session_autosave = 'no'
"}}}
call dein#add('mbbill/fencview', {'on_cmd': ['FencView','FencAutoDetect']}) "{{{
  let g:fencview_autodetect = 0
  let g:fencview_checklines = 100
  let g:fencview_auto_patterns = '*'
"}}}
if exists('$TMUX')
  call dein#add('christoomey/vim-tmux-navigator')
endif
call dein#add('kana/vim-vspec')
call dein#add('tpope/vim-scriptease', {'on_ft': 'vim'})
call dein#add('jtratner/vim-flavored-markdown', {'on_ft': ['markdown','ghmarkdown']})
if executable('instant-markdown-d')
  call dein#add('suan/vim-instant-markdown', {'on_ft': ['markdown','ghmarkdown']})
endif
call dein#add('guns/xterm-color-table.vim', {'on_cmd': 'XtermColorTable'})
"call dein#add('chrisbra/vim_faq')
"call dein#add('vimwiki/vimwiki')
call dein#add('vim-scripts/bufkill.vim')
call dein#add('mhinz/vim-startify') "{{{
  let g:startify_session_dir = NavimGetCacheDir('sessions')
  let g:startify_change_to_vcs_root = 1
  let g:startify_show_sessions = 1

  let g:startify_custom_header = [
      \ ' Navim',
      \ '',
      \ ' <Space>ff   go to files',
      \ ' <Space>bb   select from buffers',
      \ ' <Space>ss   recursively search all files for matching text',
      \ ' <Space>fr   select from MRU',
      \ ' <Space>fm   go to anything (files, buffers, MRU, bookmarks)',
      \ ' <Space>jc   lists the references or definitions of a word',
      \ ' <Space>ft   toggle file explorer',
      \ ' <Space>tt   toggle tagbar',
      \ ' <Space>tl   toggle quickfix list',
      \ ' <Space>au   toggle undo tree',
      \ ' <Space>ag   gdb',
      \ '',
      \ ]
  let g:startify_custom_footer = [
      \ ]

  let g:startify_list_order = [
      \ ['   Sessions:'],
      \ 'sessions',
      \ ['   Bookmarks:'],
      \ 'bookmarks',
      \ ['   MRU:'],
      \ 'files',
      \ ['   MRU within this dir:'],
      \ 'dir',
      \ ]
"}}}
if g:navim_settings.syntaxcheck_plugin ==# 'ale' "{{{
  call dein#add('w0rp/ale')
"}}}
elseif g:navim_settings.syntaxcheck_plugin ==# 'syntastic' "{{{
  call dein#add('vim-syntastic/syntastic') "{{{
    " run `:SyntasticCheck` to check syntax
  "}}}
endif "}}}
call dein#add('mattn/gist-vim', {'depends': 'mattn/webapi-vim', 'on_cmd': 'Gist'}) "{{{
  let g:gist_post_private = 1
  let g:gist_show_privates = 1
"}}}
call dein#add('Shougo/vimshell.vim', {'on_cmd': ['VimShell','VimShellInteractive']}) "{{{
  if g:navim_platform_macvim
    let g:vimshell_editor_command = 'mvim'
  else
    let g:vimshell_editor_command = 'vim'
  endif
  let g:vimshell_right_prompt = 'getcwd()'
  let g:vimshell_data_directory = NavimGetCacheDir('vimshell')
  let g:vimshell_vimshrc_path = '~/.config/nvim/vimshrc'
"}}}
call dein#add('zhaocai/GoldenView.Vim', {'on_map': '<Plug>ToggleGoldenViewAutoResize'}) "{{{
  let g:goldenview__enable_default_mapping = 0
"}}}
" do not use conque-shell together with conque-gdb
"call dein#add('oplatek/Conque-Shell')
call dein#add('vim-scripts/Conque-GDB', {'on_cmd': ['ConqueGdb','ConqueGdbTab',
    \ 'ConqueGdbVSplit','ConqueGdbSplit','ConqueTerm','ConqueTermTab',
    \ 'ConqueTermVSplit','ConqueTermSplit']}) "{{{
  let g:ConqueGdb_Leader = '\'
"}}}
"call dein#add('edkolev/tmuxline.vim')


" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0

