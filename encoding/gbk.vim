" <http://vimdoc.sourceforge.net/htmldoc/mbyte.html>
set encoding=gbk
set fileencoding=gbk
set fileencodings=ucs-bom,utf-8,gb2312,gbk,gb18030,big5,latin1
set fileformats=unix,mac,dos
set termencoding=gbk

" characters for displaying in list mode
set listchars=extends:>,precedes:<,tab:>\ ,trail:~

set showbreak&

" airline
"if !empty(glob("vim-airline"))
let g:airline_left_sep = '>'
let g:airline_left_alt_sep = '>'
let g:airline_right_sep = '<'
let g:airline_right_alt_sep = '<'
let g:airline#extensions#tabline#left_sep = '>'
"let g:airline#extensions#tabline#left_alt_sep = '>'
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = '<'
"let g:airline#extensions#tabline#right_alt_sep = '<'
let g:airline#extensions#tabline#right_alt_sep = ''
"endif

" lightline
let g:lightline_buffer_logo = ''
let g:lightline_buffer_readonly_icon = 'RO'
let g:lightline_buffer_modified_icon = '*'
let g:lightline_buffer_git_icon = ''
let g:lightline_buffer_ellipsis_icon = '..'
let g:lightline_buffer_expand_left_icon = '< '
let g:lightline_buffer_expand_right_icon = ' >'

" :help tabline
" tabline use "%1T" for the first label, "%2T" for the second one, etc. use "%T" for ending. use "%X" items for closing labels
" use %X after the label, e.g. %3Xclose%X. use %999X for a "close current tab"
" mouse left-click between "%1T" and "%2T" go to tab 1, between "%2T" and "%3T" go to tab 2, etc.
" mouse double-click anywhere new a tab
let g:lightline = {
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'fugitive', 'filename' ],
    \             [ 'buffertag' ], ],
    \   'right': [ [ 'lineinfo', 'syntaxcheck' ],
    \              [ 'fileinfo' ],
    \              [ 'filetype' ], ],
    \ },
    \ 'inactive': {
    \   'left': [ [ 'filename' ], ],
    \   'right': [ [ 'lineinfo' ], ],
    \ },
    \ 'tabline': {
    \   'left': [ [ 'bufferinfo' ],
    \             [ 'separator' ],
    \             [ 'bufferbefore', 'buffercurrent', 'bufferafter' ], ],
    \   'right': [ [ 'close' ], ],
    \ },
    \ 'component_expand': {
    \   'buffercurrent': 'lightline#buffer#buffercurrent',
    \   'bufferbefore': 'lightline#buffer#bufferbefore',
    \   'bufferafter': 'lightline#buffer#bufferafter',
    \   'bufferall': 'lightline#buffer#bufferall',
    \ },
    \ 'component_type': {
    \   'buffercurrent': 'tabsel',
    \   'bufferbefore': 'raw',
    \   'bufferafter': 'raw',
    \   'bufferall': 'tabsel',
    \ },
    \ 'component_function': {
    \   'bufferinfo': 'lightline#buffer#bufferinfo',
    \   'buffertag': 'LightlineTag',
    \   'fugitive': 'LightlineFugitive',
    \   'fileinfo': 'LightlineFileinfo',
    \   'filename': 'LightlineFilename',
    \   'fileformat': 'LightlineFileformat',
    \   'filetype': 'LightlineFiletype',
    \   'fileencoding': 'LightlineFileencoding',
    \   'mode': 'LightlineMode',
    \   'syntaxcheck': 'LightlineSyntaxcheck',
    \ },
    \ 'component': {
    \   'separator': '',
    \   'lineinfo': '%3p%% %3l:%-2v',
    \   'readonly': '%{&readonly?"RO":""}',
    \   'modified': '%{&filetype=="help"?"":&modified?"*":&modifiable?"":"-"}',
    \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}',
    \ },
    \ 'component_visible_condition': {
    \   'readonly': '(&filetype!="help"&& &readonly)',
    \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
    \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())',
    \ },
    \ 'separator': { 'left': '>', 'right': '<' },
    \ 'subseparator': { 'left': '>', 'right': '<' },
    \ 'tabline_separator': { 'left': '>', 'right': '<' },
    \ 'tabline_subseparator': { 'left': '>', 'right': '<' },
    \ }
    "\ 'left': [ [ 'bufferline' ] ],
    "\ 'right': [ [ 'close' ] ],

if g:navim_settings.colorscheme ==# 'solarized'
  let g:lightline.colorscheme = 'lightline_solarized'
endif

"let g:lightline.enable = {
"    \ 'statusline': 1,
"    \ 'tabline': 1,
"    \ }

let g:lightline.mode_map = {
    \ 'n' : 'N',
    \ 'i' : 'I',
    \ 'R' : 'R',
    \ 'v' : 'V',
    \ 'V' : 'V',
    \ 'c' : 'C',
    \ "\<C-v>": 'V',
    \ 's' : 'S',
    \ 'S' : 'S',
    \ "\<C-s>": 'S',
    \ '?': ' ',
    \ }

" coc
if dein#is_sourced('coc.nvim')
  let g:lightline.active.left = [ [ 'mode', 'paste' ],
      \ [ 'fugitive', 'filename' ],
      \ [ 'cocstatus', 'coctag' ], ]
  let g:lightline.component_function.cocstatus = 'coc#status'
  let g:lightline.component_function.coctag = 'CocCurrentFunction'
endif

" defx
if dein#is_sourced('defx.nvim')
  call defx#custom#column('icon', {
      \ 'directory_icon': '>',
      \ 'opened_icon': 'v',
      \ 'root_icon': ' ',
      \ })
  call defx#custom#column('mark', {
      \ 'readonly_icon': 'RO',
      \ 'selected_icon': '*',
      \ })
endif

" nerdtree
let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable = '>'
let g:NERDTreeDirArrowCollapsible = 'v'

" nerdtree-git-plugin
"if !empty(glob("nerdtree-git-plugin"))
let g:NERDTreeIndicatorMapCustom = {
    \ 'Modified'  : '~',
    \ 'Staged'    : '+',
    \ 'Untracked' : '*',
    \ 'Renamed'   : '>',
    \ 'Unmerged'  : '=',
    \ 'Deleted'   : 'x',
    \ 'Dirty'     : '!',
    \ 'Clean'     : 'v',
    \ 'Unknown'   : '?'
    \ }
"endif

" vimfiler
"if !empty(glob("vimfiler"))
let g:vimfiler_tree_leaf_icon = ' '
let g:vimfiler_tree_opened_icon = 'v'
let g:vimfiler_tree_closed_icon = '>'
let g:vimfiler_file_icon = ' '
let g:vimfiler_marked_file_icon = '*'
"endif

" ale
let g:ale_statusline_format = ['x %d', '! %d', 'ok']
let g:ale_sign_error = 'x'
let g:ale_sign_warning = '!'

" syntastic
let g:syntastic_error_symbol = 'x'
let g:syntastic_style_error_symbol = '*'
let g:syntastic_warning_symbol = '!'
let g:syntastic_style_warning_symbol = '~'

" signify
let g:signify_sign_add               = '+'
let g:signify_sign_delete            = '_'
let g:signify_sign_delete_first_line = '_'
let g:signify_sign_change            = '!'
let g:signify_sign_changedelete      = g:signify_sign_change


" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0

