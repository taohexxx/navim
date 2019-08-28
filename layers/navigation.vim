" functions {{{

"}}}

"call dein#add('yonchu/accelerated-smooth-scroll')
call dein#add('mileszs/ack.vim') "{{{
  if executable('ag')
    let g:ackprg = "ag --nogroup --column --smart-case --follow"
  endif
"}}}
call dein#add('mbbill/undotree', {'on_cmd': 'UndotreeToggle'}) "{{{
  let g:undotree_WindowLayout = 2
  let g:undotree_SetFocusWhenToggle = 1
"}}}
call dein#add('vim-scripts/EasyGrep', {'on_cmd': 'GrepOptions'}) "{{{
  let g:EasyGrepRecursive = 1
  let g:EasyGrepAllOptionsInExplorer = 1
  let g:EasyGrepCommand = 1
"}}}
"call dein#add('ctrlpvim/ctrlp.vim', {'on_cmd': 'CtrlP'}) "{{{
"  call dein#add('tacahiroy/ctrlp-funky', {'depends': 'ctrlpvim/ctrlp.vim', 'on_cmd': 'CtrlP'})
"  let g:ctrlp_clear_cache_on_exit = 1
"  let g:ctrlp_max_height = 40
"  let g:ctrlp_show_hidden = 0
"  let g:ctrlp_follow_symlinks = 1
"  let g:ctrlp_max_files = 20000
"  let g:ctrlp_cache_dir = NavimGetCacheDir('ctrlp')
"  let g:ctrlp_reuse_window = 'startify'
"  let g:ctrlp_extensions = ['funky']
"  let g:ctrlp_custom_ignore = {
"      \ 'dir': '\v[\/]\.(git|hg|svn|idea)$',
"      \ 'file': '\v\.DS_Store$'
"      \ }
"
"  if executable('ag')
"    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
"  endif
"
"  nmap \ [ctrlp]
"  nnoremap [ctrlp] <Nop>
"
"  nnoremap [ctrlp]t :CtrlPBufTag<CR>
"  nnoremap [ctrlp]T :CtrlPTag<CR>
"  nnoremap [ctrlp]l :CtrlPLine<CR>
"  nnoremap [ctrlp]o :CtrlPFunky<CR>
"  nnoremap [ctrlp]b :CtrlPBuffer<CR>
""}}}
if g:navim_settings.explorer_plugin ==# 'nerdtree' "{{{
  "if g:navim_settings.encoding == 'utf-8' && has('multi_byte') && has('unix') && &encoding == 'utf-8' &&
  "    \ (empty(&termencoding) || &termencoding == 'utf-8') "{{{
  "call dein#add('scrooloose/nerdtree', {'on_cmd': ['NERDTreeToggle','NERDTreeFind']}) "{{{
  call dein#add('scrooloose/nerdtree') "{{{
    let g:NERDTreeShowHidden = 1
    let g:NERDTreeQuitOnOpen = 0
    let g:NERDTreeShowLineNumbers = 0
    let g:NERDTreeChDirMode = 0
    let g:NERDTreeShowBookmarks = 1
    let g:NERDTreeIgnore = ['\.git','\.hg','\.svn','\.DS_Store']
    let g:NERDTreeWinPos = 'right'
    let g:NERDTreeWinSize = 40
    let g:NERDTreeBookmarksFile = NavimGetCacheDir('nerdtreebookmarks')
    " close vim if the only window left open is a nerdtree
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType ==# "primary") | q | endif
  "}}}
  call dein#add('Xuyuanp/nerdtree-git-plugin') "{{{
  "}}}
  "endif "}}}
"}}}
elseif g:navim_settings.explorer_plugin ==# 'defx' "{{{
  call dein#add('Shougo/defx.nvim')
  if !g:navim_platform_neovim && g:navim_has_python3
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif
  call dein#add('kristijanhusak/defx-icons', {'depends': 'Shougo/defx.nvim'})
  call dein#add('kristijanhusak/defx-git', {'depends': 'Shougo/defx.nvim'})
  call defx#custom#column('filename', {
      \ 'min_width': 40,
      \ 'max_width': 40,
      \ })
  call defx#custom#option('_', {
      \ 'columns': 'mark:indent:git:icons:filename:type:size:time',
      \ })

  autocmd FileType defx call s:defx_my_settings()
  function! s:defx_my_settings() abort
    nnoremap <silent><buffer><expr> <CR>
        \ defx#do_action('drop')
    nnoremap <silent><buffer><expr> c
        \ defx#do_action('copy')
    nnoremap <silent><buffer><expr> m
        \ defx#do_action('move')
    nnoremap <silent><buffer><expr> p
        \ defx#do_action('paste')
    nnoremap <silent><buffer><expr> l
        \ defx#do_action('drop')
    nnoremap <silent><buffer><expr> P
        \ defx#do_action('open', 'pedit')
    nnoremap <silent><buffer><expr> o
        \ defx#do_action('open_or_close_tree')
    nnoremap <silent><buffer><expr> K
        \ defx#do_action('new_directory')
    nnoremap <silent><buffer><expr> N
        \ defx#do_action('new_file')
    nnoremap <silent><buffer><expr> M
        \ defx#do_action('new_multiple_files')
    nnoremap <silent><buffer><expr> C
        \ defx#do_action('toggle_columns',
        \                'mark:indent:icon:filename:type:size:time')
    nnoremap <silent><buffer><expr> S
        \ defx#do_action('toggle_sort', 'time')
    nnoremap <silent><buffer><expr> d
        \ defx#do_action('remove')
    nnoremap <silent><buffer><expr> r
        \ defx#do_action('rename')
    nnoremap <silent><buffer><expr> !
        \ defx#do_action('execute_command')
    nnoremap <silent><buffer><expr> x
        \ defx#do_action('execute_system')
    nnoremap <silent><buffer><expr> yy
        \ defx#do_action('yank_path')
    nnoremap <silent><buffer><expr> .
        \ defx#do_action('toggle_ignored_files')
    nnoremap <silent><buffer><expr> ;
        \ defx#do_action('repeat')
    nnoremap <silent><buffer><expr> h
        \ defx#do_action('cd', ['..'])
    nnoremap <silent><buffer><expr> ~
        \ defx#do_action('cd')
    nnoremap <silent><buffer><expr> q
        \ defx#do_action('quit')
    nnoremap <silent><buffer><expr> <Space>
        \ defx#do_action('toggle_select') . 'j'
    nnoremap <silent><buffer><expr> *
        \ defx#do_action('toggle_select_all')
    nnoremap <silent><buffer><expr> j
        \ line('.') == line('$') ? 'gg' : 'j'
    nnoremap <silent><buffer><expr> k
        \ line('.') == 1 ? 'G' : 'k'
    nnoremap <silent><buffer><expr> <C-l>
        \ defx#do_action('redraw')
    nnoremap <silent><buffer><expr> <C-g>
        \ defx#do_action('print')
    nnoremap <silent><buffer><expr> cd
        \ defx#do_action('change_vim_cwd')
  endfunction
endif "}}}
"elseif g:navim_settings.explorer_plugin ==# 'vimfiler' "{{{
"  " vimfiler require unite
"  call dein#add('Shougo/vimproc.vim', {'build': 'make'})
"  call dein#add('Shougo/unite.vim', {'depends': 'Shougo/vimproc.vim'})
"  call dein#add('Shougo/vimfiler.vim', {'depends': 'Shougo/unite.vim'}) "{{{
"    let g:vimfiler_as_default_explorer = 1
"    let g:vimfiler_ignore_pattern = '^\%(\.git\|\.hg\|\.svn\|\.DS_Store\)$'
"    let g:vimfiler_no_default_key_mappings = 1
"    let g:vimfiler_expand_jump_to_first_child = 0
"    let g:vimfiler_data_directory = NavimGetCacheDir('vimfiler')
"
"    function! s:vimfiler_settings() "{{{
"      set nonumber
"
"      execute s:nowait_nmap() 'j' '<Plug>(vimfiler_loop_cursor_down)'
"      execute s:nowait_nmap() 'k' '<Plug>(vimfiler_loop_cursor_up)'
"
"      " Toggle mark.
"      execute s:nowait_nmap() '<Space>' '<Plug>(vimfiler_toggle_mark_current_line)'
"      execute s:nowait_nmap() '<S-LeftMouse>' '<Plug>(vimfiler_toggle_mark_current_line)'
"      execute s:nowait_nmap() '<S-Space>' '<Plug>(vimfiler_toggle_mark_current_line_up)'
"      vmap <buffer> <Space> <Plug>(vimfiler_toggle_mark_selected_lines)
"
"      " Toggle marks in all lines.
"      execute s:nowait_nmap() '*' '<Plug>(vimfiler_toggle_mark_all_lines)'
"      execute s:nowait_nmap() '#' '<Plug>(vimfiler_mark_similar_lines)'
"      " Clear marks in all lines.
"      execute s:nowait_nmap() 'U' '<Plug>(vimfiler_clear_mark_all_lines)'
"
"      " Copy files.
"      execute s:nowait_nmap() 'c' '<Plug>(vimfiler_copy_file)'
"      execute s:nowait_nmap() 'Cc' '<Plug>(vimfiler_clipboard_copy_file)'
"
"      " Move files.
"      execute s:nowait_nmap() 'm' '<Plug>(vimfiler_move_file)'
"      execute s:nowait_nmap() 'Cm' '<Plug>(vimfiler_clipboard_move_file)'
"
"      " Delete files.
"      execute s:nowait_nmap() 'd' '<Plug>(vimfiler_delete_file)'
"
"      " Rename.
"      execute s:nowait_nmap() 'r' '<Plug>(vimfiler_rename_file)'
"
"      " Make directory.
"      execute s:nowait_nmap() 'K' '<Plug>(vimfiler_make_directory)'
"
"      " New file.
"      execute s:nowait_nmap() 'N' '<Plug>(vimfiler_new_file)'
"
"      " Paste.
"      execute s:nowait_nmap() 'Cp' '<Plug>(vimfiler_clipboard_paste)'
"
"      " Execute or change directory.
"      execute s:nowait_nmap() '<Enter>' '<Plug>(vimfiler_cd_or_edit)'
"      execute s:nowait_nmap() 'o' '<Plug>(vimfiler_expand_or_edit)'
"      execute s:nowait_nmap() 'l' '<Plug>(vimfiler_smart_l)'
"
"      execute s:nowait_nmap() 'x' '<Plug>(vimfiler_execute_system_associated)'
"
"      " Move to directory.
"      execute s:nowait_nmap() 'h' '<Plug>(vimfiler_smart_h)'
"      execute s:nowait_nmap() 'L' '<Plug>(vimfiler_switch_to_drive)'
"      execute s:nowait_nmap() '~' '<Plug>(vimfiler_switch_to_home_directory)'
"      execute s:nowait_nmap() '\' '<Plug>(vimfiler_switch_to_root_directory)'
"      execute s:nowait_nmap() '&' '<Plug>(vimfiler_switch_to_project_directory)'
"      execute s:nowait_nmap() '<C-j>' '<Plug>(vimfiler_switch_to_history_directory)'
"      execute s:nowait_nmap() '<BS>' '<Plug>(vimfiler_switch_to_parent_directory)'
"
"      execute s:nowait_nmap() 'gv' '<Plug>(vimfiler_execute_new_gvim)'
"      execute s:nowait_nmap() '.' '<Plug>(vimfiler_toggle_visible_ignore_files)'
"      execute s:nowait_nmap() 'H' '<Plug>(vimfiler_popup_shell)'
"
"      " Edit file.
"      execute s:nowait_nmap() 'e' '<Plug>(vimfiler_edit_file)'
"      execute s:nowait_nmap() 'E' '<Plug>(vimfiler_split_edit_file)'
"      execute s:nowait_nmap() 'B' '<Plug>(vimfiler_edit_binary_file)'
"
"      " Choose action.
"      execute s:nowait_nmap() 'a' '<Plug>(vimfiler_choose_action)'
"
"      " Hide vimfiler.
"      execute s:nowait_nmap() 'q' '<Plug>(vimfiler_hide)'
"      " Exit vimfiler.
"      execute s:nowait_nmap() 'Q' '<Plug>(vimfiler_exit)'
"      " Close vimfiler.
"      execute s:nowait_nmap() '-' '<Plug>(vimfiler_close)'
"
"      execute s:nowait_nmap() 'ge' '<Plug>(vimfiler_execute_external_filer)'
"      execute s:nowait_nmap() '<RightMouse>' '<Plug>(vimfiler_execute_external_filer)'
"
"      execute s:nowait_nmap() '!' '<Plug>(vimfiler_execute_shell_command)'
"      execute s:nowait_nmap() 'g?' '<Plug>(vimfiler_help)'
"      execute s:nowait_nmap() 'v' '<Plug>(vimfiler_preview_file)'
"      execute s:nowait_nmap() 'O' '<Plug>(vimfiler_sync_with_current_vimfiler)'
"      execute s:nowait_nmap() 'go' '<Plug>(vimfiler_open_file_in_another_vimfiler)'
"      execute s:nowait_nmap() '<C-g>' '<Plug>(vimfiler_print_filename)'
"      execute s:nowait_nmap() 'g<C-g>' '<Plug>(vimfiler_toggle_maximize_window)'
"      execute s:nowait_nmap() 'yy' '<Plug>(vimfiler_yank_full_path)'
"      execute s:nowait_nmap() 'M' '<Plug>(vimfiler_set_current_mask)'
"      execute s:nowait_nmap() 'gr' '<Plug>(vimfiler_grep)'
"      execute s:nowait_nmap() 'gf' '<Plug>(vimfiler_find)'
"      execute s:nowait_nmap() 'S' '<Plug>(vimfiler_select_sort_type)'
"      execute s:nowait_nmap() '<C-v>' '<Plug>(vimfiler_switch_vim_buffer_mode)'
"      execute s:nowait_nmap() 'gc' '<Plug>(vimfiler_cd_vim_current_dir)'
"      execute s:nowait_nmap() 'gs' '<Plug>(vimfiler_toggle_safe_mode)'
"      execute s:nowait_nmap() 'gS' '<Plug>(vimfiler_toggle_simple_mode)'
"      execute s:nowait_nmap() 'gg' '<Plug>(vimfiler_cursor_top)'
"      execute s:nowait_nmap() 'G' '<Plug>(vimfiler_cursor_bottom)'
"      execute s:nowait_nmap() 't' '<Plug>(vimfiler_expand_tree)'
"      execute s:nowait_nmap() 'T' '<Plug>(vimfiler_expand_tree_recursive)'
"      execute s:nowait_nmap() 'I' '<Plug>(vimfiler_cd_input_directory)'
"      execute s:nowait_nmap() '<2-LeftMouse>' '<Plug>(vimfiler_double_click)'
"
"      " pushd/popd
"      execute s:nowait_nmap() 'Y' '<Plug>(vimfiler_pushd)'
"      execute s:nowait_nmap() 'P' '<Plug>(vimfiler_popd)'
"
"      execute s:nowait_nmap() 'gj' '<Plug>(vimfiler_jump_last_child)'
"      execute s:nowait_nmap() 'gk' '<Plug>(vimfiler_jump_first_child)'
"
"    endfunction "}}}
"
"    function! s:nowait_nmap() "{{{
"      return 'nmap <buffer>'
"          \ . ((v:version > 703 || (v:version == 703 && has('patch1261'))) ?
"          \ '<nowait>' : '')
"    endfunction "}}}
"
"    autocmd FileType vimfiler call s:vimfiler_settings()
"  "}}}
"endif "}}}
call dein#add('majutsushi/tagbar', {'on_cmd': 'TagbarToggle'}) "{{{
  let g:tagbar_left = 1
  let g:tagbar_width = 30
  let g:tagbar_autoclose = 0
"}}}
call dein#add('jeetsukumaran/vim-buffergator') "{{{
  let g:buffergator_suppress_keymaps = 1
  let g:buffergator_suppress_mru_switch_into_splits_keymaps = 1
  let g:buffergator_viewport_split_policy = "B"
  let g:buffergator_split_size = 10
  let g:buffergator_sort_regime = "mru"
  let g:buffergator_mru_cycle_loop = 0
"}}}


" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0

