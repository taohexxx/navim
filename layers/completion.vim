" functions {{{

"}}}

call dein#add('honza/vim-snippets')

if g:navim_settings.completion_plugin ==# 'coc'
  call dein#add('neoclide/coc.nvim', {'rev': 'release'}) "{{{
    " manual run this for the first time
    " CocInstall coc-snippets coc-json coc-tsserver coc-html coc-css coc-java coc-r-lsp coc-yaml coc-python coc-highlight coc-lists coc-git coc-yank coc-svg coc-vimlsp coc-xml
    " CocList extensions
    " CocList snippets
  "}}}
elseif g:navim_settings.completion_plugin ==# 'deoplete'
  call dein#add('Shougo/deoplete.nvim', {'on_i': 1, 'hook_done_update': function('NavimOnDoneUpdate')}) "{{{
    " need to execute the `:UpdateRemotePlugins` and restart for the first time
    let g:deoplete#enable_at_startup = 1
  "}}}

  call dein#add('Shougo/neosnippet.vim') "{{{
    let g:neosnippet#data_directory = NavimGetCacheDir('neosnippet')
    let g:neosnippet#snippets_directory =
        \ NavimGetDir('bundle') . g:navim_path_separator .
        \ 'repos' . g:navim_path_separator .
        \ 'github.com' . g:navim_path_separator .
        \ 'honza' . g:navim_path_separator .
        \ 'vim-snippets' . g:navim_path_separator .
        \ 'snippets,' .
        \ NavimGetDir('snippets')
    let g:neosnippet#enable_snipmate_compatibility = 1

    imap <expr><Tab> neosnippet#expandable_or_jumpable() ?
        \ "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ? "\<C-n>" : "\<Tab>")
    smap <expr><Tab> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"
    imap <expr><S-Tab> pumvisible() ? "\<C-p>" : ""
    smap <expr><S-Tab> pumvisible() ? "\<C-p>" : ""
  "}}}
  call dein#add('Shougo/neosnippet-snippets')
elseif g:navim_settings.completion_plugin ==# 'ycm'
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
endif


" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0

