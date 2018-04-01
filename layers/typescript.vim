" functions {{{

"}}}

if g:navim_platform_neovim && g:navim_has_python3 "{{{

call dein#add('mhartington/nvim-typescript', {'on_ft': 'typescript', 'hook_done_update': function('NavimOnDoneUpdate')})

endif "}}}


" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0

