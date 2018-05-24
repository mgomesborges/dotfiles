" Rebind ultisnips to something never used. We use CleverTab :)
let g:UltiSnipsExpandTrigger="<f12>"
let g:UltiSnipsJumpForwardTrigger="<f12>"
let g:UltiSnipsJumpBackwardTrigger="<f12>"

" Put all my useful ultisnips globals in here
py import sys, os; sys.path.append(os.environ['HOME'] + '/.vim/UltiSnips/mods')

snoremap <Tab> <Esc>:call UltiSnips#ExpandSnippetOrJump()<cr>
xnoremap <Tab> :call UltiSnips#SaveLastVisualSelection()<cr>gvs
snoremap <C-k> <Esc>:call UltiSnips#JumpBackwards()<cr>
inoremap <C-k> <Esc>:call UltiSnips#JumpBackwards()<cr>
snoremap <C-j> <Esc>:call UltiSnips#JumpForwards()<cr>
inoremap <C-j> <Esc>:call UltiSnips#JumpForwards()<cr>
