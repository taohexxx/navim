" functions {{{

  function! s:OnDenitePostSource() abort

    " change file_rec command.
    "call denite#custom#var('file_rec', 'command',
    "    \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])

    " change mappings "{{{
      call denite#custom#map(
          \ 'insert',
          \ '<C-n>',
          \ '<denite:move_to_next_line>',
          \ 'noremap'
          \)
      call denite#custom#map(
          \ 'insert',
          \ '<C-p>',
          \ '<denite:move_to_previous_line>',
          \ 'noremap'
          \)
    "}}}

    " change grep "{{{
      " [Feature comparison of ack, ag, git-grep, GNU grep and ripgrep](https://beyondgrep.com/feature-comparison/)
      if executable('rg')
        " <https://github.com/BurntSushi/ripgrep>
        call denite#custom#var('grep', 'command', ['rg'])
        call denite#custom#var('grep', 'default_opts',
            \ ['-i', '--vimgrep', '--no-heading'])
        call denite#custom#var('grep', 'recursive_opts', [])
        call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
        call denite#custom#var('grep', 'separator', ['--'])
        call denite#custom#var('grep', 'final_opts', [])
      elseif executable('sift')
        call denite#custom#var('grep', 'command', ['sift'])
        call denite#custom#var('grep', 'default_opts',
            \ ['-i', '--no-color'])
        call denite#custom#var('grep', 'recursive_opts', [])
        call denite#custom#var('grep', 'pattern_opt', [])
        call denite#custom#var('grep', 'separator', ['--'])
        call denite#custom#var('grep', 'final_opts', [])
      elseif executable('ag')
        " <https://geoff.greer.fm/ag/>
        call denite#custom#var('grep', 'command', ['ag'])
        call denite#custom#var('grep', 'default_opts',
            \ ['-i', '--vimgrep', '--hidden',
            \ '--ignore', '''.hg''', '--ignore', '''.svn''',
            \ '--ignore', '''.git''', '--ignore', '''.bzr'''])
        call denite#custom#var('grep', 'recursive_opts', [])
        call denite#custom#var('grep', 'pattern_opt', [])
        call denite#custom#var('grep', 'separator', ['--'])
        call denite#custom#var('grep', 'final_opts', [])
      elseif executable('pt')
        call denite#custom#var('grep', 'command', ['pt'])
        call denite#custom#var('grep', 'default_opts',
            \ ['--nogroup', '--nocolor', '--smart-case'])
        call denite#custom#var('grep', 'recursive_opts', [])
        call denite#custom#var('grep', 'pattern_opt', [])
        call denite#custom#var('grep', 'separator', ['--'])
        call denite#custom#var('grep', 'final_opts', [])
      elseif executable('ack')
        " <https://beyondgrep.com>
        call denite#custom#var('grep', 'command', ['ack'])
        call denite#custom#var('grep', 'default_opts',
            \ ['-i', '--with-filename', '--nopager', '--noheading',
            \ '--nocolor', '--nogroup', '--column'])
        call denite#custom#var('grep', 'recursive_opts', [])
        call denite#custom#var('grep', 'pattern_opt', ['--match'])
        call denite#custom#var('grep', 'separator', ['--'])
        call denite#custom#var('grep', 'final_opts', [])
      endif
    "}}}

    " change default prompt
    call denite#custom#option('default', 'prompt', '')

    " change ignore_globs
    call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
        \ split(&wildignore, ','))
    "call denite#custom#filter('matcher_ignore_globs', 'ignore_globs', [
    "    \ '*~', '*.o', 'core.*', '*.exe', '.git/', '.hg/', '.svn/',
    "    \ '.DS_Store', '*.pyc', '*.sw[po]', '*.class',
    "    \ '*.tags', 'tags', 'tags-*', 'cscope.*', '*.taghl',
    "    \ '.ropeproject/', '__pycache__/', 'venv/',
    "    \ '*.min.*', 'images/', 'img/', 'fonts/'])

    " change matchers
    call denite#custom#source('file_rec,file_mru', 'matchers',
        \ ['matcher_ignore_globs'])
    call denite#custom#source('bookmark,buffer,colorscheme,grep,help,line,outline',
        \ 'matchers', ['matcher_fuzzy'])

    " change sorters
    call denite#custom#source('file_rec', 'sorters', ['sorter_rank'])
  endfunction

  function! s:OnUnitePostSource() abort

    " change grep "{{{
      if executable('rg')
        let g:unite_source_grep_command = 'rg'
        let g:unite_source_grep_default_opts = '-i --vimgrep --no-heading'
        let g:unite_source_grep_recursive_opt = ''
      elseif executable('sift')
        let g:unite_source_grep_command = 'sift'
        let g:unite_source_grep_default_opts = '-i --no-color'
        let g:unite_source_grep_recursive_opt = ''
      elseif executable('ag')
        let g:unite_source_grep_command = 'ag'
        let g:unite_source_grep_default_opts =
            \ '-i --vimgrep --hidden --ignore ''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
        let g:unite_source_grep_recursive_opt = ''
      elseif executable('pt')
        let g:unite_source_grep_command = 'pt'
        let g:unite_source_grep_default_opts = '--nogroup --nocolor --smart-case'
        let g:unite_source_grep_recursive_opt = ''
      elseif executable('ack')
        let g:unite_source_grep_command = 'ack'
        let g:unite_source_grep_default_opts =
            \ '-i -H --nopager --noheading --nocolor --nogroup --column'
        let g:unite_source_grep_recursive_opt = ''
      endif
    "}}}

    call unite#filters#matcher_default#use(['matcher_fuzzy'])
    call unite#filters#sorter_default#use(['sorter_rank'])

    " change ignore_globs
    call unite#custom#source(
        \ 'file,file/async,file_rec,file_rec/async,file_mru', 'ignore_globs',
        \ split(&wildignore, ','))
    "call unite#custom#source('file,file/async,file_rec,file_rec/async', 'ignore_pattern',
    "    \ '~$\|\.o$\|^core\.\|\.exe$\|^\.git/$\|^\.hg/$\|^\.svn/$\|' .
    "    \ '^\.DS_Store$\|\.pyc$\|\.swp$\|\.swo$\|\.class$\|' .
    "    \ '\.tags$\|^tags$\|^tags-\|^cscope\.\|\.taghl$\|' .
    "    \ '^\.ropeproject/$\|^__pycache__/$\|^venv/$\|' .
    "    \ '\.min\.\|^images/$\|^img/$\|^fonts/$')

    call unite#custom#profile('default', 'context', {
        \ 'start_insert': 1,
        \ })
        "\ 'direction': 'botright',

  endfunction

  function! s:UniteSettings()
    nmap <buffer> Q <Plug>(unite_exit)
    nmap <buffer> <Esc> <Plug>(unite_exit)
    imap <buffer> <Esc> <Plug>(unite_exit)
  endfunction

"}}}

if (g:navim_platform_neovim || (v:version >= 800)) && g:navim_has_python3

  call dein#add('Shougo/denite.nvim', {
      \ 'hook_post_source': function('s:OnDenitePostSource'),
      \ 'hook_done_update': function('NavimOnDoneUpdate')}) "{{{
    " need to execute the `:UpdateRemotePlugins` and restart for the first time
  "}}}

endif

"{{{

  "call dein#add('Shougo/unite.vim', {'on_cmd': ['Unite','UniteWithCurrentDir','UniteWithBufferDir',
  "    \ 'UniteWithProjectDir','UniteWithInput','UniteWithInputDirectory','UniteWithCursorWord']})
  call dein#add('Shougo/vimproc.vim', {'build': 'make'})
  call dein#add('Shougo/unite.vim', {'depends': 'Shougo/vimproc.vim',
      \ 'hook_post_source': function('s:OnUnitePostSource')}) "{{{
    let g:unite_data_directory = NavimGetCacheDir('unite')

    autocmd FileType unite call s:UniteSettings()
  "}}}

  call dein#add('osyo-manga/unite-airline_themes', {'depends': 'Shougo/unite.vim'})
  call dein#add('ujihisa/unite-colorscheme', {'depends': 'Shougo/unite.vim'})
  call dein#add('tsukkee/unite-tag', {'depends': 'Shougo/unite.vim'})
  call dein#add('hewes/unite-gtags', {'depends': 'Shougo/unite.vim'})
  call dein#add('Shougo/unite-outline', {'depends': 'Shougo/unite.vim'})
  call dein#add('Shougo/unite-help', {'depends': 'Shougo/unite.vim'})
  call dein#add('Shougo/junkfile.vim', {'depends': 'Shougo/unite.vim', 'on_cmd': 'JunkfileOpen'}) "{{{
    let g:junkfile#directory = NavimGetCacheDir('junk')
  "}}}

"}}}

call dein#add('Shougo/neomru.vim', {
    \ 'hook_done_update': function('NavimOnDoneUpdate')}) "{{{
  " need to execute the `:UpdateRemotePlugins` and restart for the first time
  let g:neomru#file_mru_path = NavimGetCacheDir('neomru') .
      \ g:navim_path_separator . 'file'
  let g:neomru#directory_mru_path = NavimGetCacheDir('neomru') .
      \ g:navim_path_separator . 'directory'
"}}}
call dein#add('Shougo/neoyank.vim', {
    \ 'hook_done_update': function('NavimOnDoneUpdate')}) "{{{
  " need to execute the `:UpdateRemotePlugins` and restart for the first time
  let g:neoyank#file = NavimGetCacheDir('neoyank') .
      \ g:navim_path_separator . 'history_yank'
"}}}


" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0

