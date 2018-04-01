" functions {{{

"}}}

call dein#add('honza/vim-snippets')

if g:navim_settings.completion_plugin ==# 'ycm' "{{{
  call dein#add('Valloric/YouCompleteMe') "{{{
    "let g:ycm_path_to_python_interpreter='~/local/bin/python'
    let g:ycm_complete_in_comments_and_strings = 1
    let g:ycm_key_list_select_completion = ['<C-n>','<Down>']
    let g:ycm_key_list_previous_completion = ['<C-p>','<Up>']
    let g:ycm_filetype_blacklist = {'unite': 1}
  "}}}
  call dein#add('SirVer/ultisnips') "{{{
    let g:UltiSnipsExpandTrigger = "<Tab>"
    let g:UltiSnipsJumpForwardTrigger = "<Tab>"
    let g:UltiSnipsJumpBackwardTrigger = "<S-Tab>"
    let g:UltiSnipsSnippetsDir = NavimGetDir('snippets')
  "}}}
else
  call dein#add('Shougo/neosnippet-snippets')
  call dein#add('Shougo/neosnippet.vim') "{{{
    let g:neosnippet#data_directory = NavimGetCacheDir('neosnippet')
    let g:neosnippet#snippets_directory =
        \ '~/.config/nvim/bundle/vim-snippets/snippets,' .
        \ NavimGetDir('snippets')
    let g:neosnippet#enable_snipmate_compatibility = 1

    imap <expr><Tab> neosnippet#expandable_or_jumpable() ?
        \ "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ? "\<C-n>" : "\<Tab>")
    smap <expr><Tab> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"
    imap <expr><S-Tab> pumvisible() ? "\<C-p>" : ""
    smap <expr><S-Tab> pumvisible() ? "\<C-p>" : ""
  "}}}
endif "}}}

if g:navim_settings.completion_plugin ==# 'deoplete' "{{{
  call dein#add('Shougo/deoplete.nvim', {'on_i': 1, 'hook_done_update': function('NavimOnDoneUpdate')}) "{{{
    " need to execute the `:UpdateRemotePlugins` and restart for the first time
    let g:deoplete#enable_at_startup = 1
  "}}}
elseif g:navim_settings.completion_plugin ==# 'neocomplete' "{{{
  call dein#add('Shougo/neocomplete.vim', {'on_i': 1}) "{{{
    let g:neocomplete#enable_at_startup = 1
    let g:neocomplete#data_directory = NavimGetCacheDir('neocomplete')
  "}}}
elseif g:navim_settings.completion_plugin ==# 'neocomplcache' "{{{
  call dein#add('Shougo/neocomplcache.vim', {'on_i': 1}) "{{{
    let g:neocomplcache_enable_at_startup = 1
    let g:neocomplcache_temporary_dir = NavimGetCacheDir('neocomplcache')
    let g:neocomplcache_enable_fuzzy_completion = 1
  "}}}
endif "}}}

if g:navim_settings.completion_plugin ==# 'neocomplete' ||
    \ g:navim_settings.completion_plugin ==# 'neocomplcache' "{{{
  call dein#add('osyo-manga/vim-marching', {'on_i': 1}) "{{{
    " path to clang command
    "let g:marching_clang_command = "clang"
    let g:marching_enable_neocomplete = 1
  "}}}
  call dein#add('Konfekt/FastFold', {'on_i': 1})
endif "}}}


" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0

