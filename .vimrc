" Load plugins from the bundle directory
call pathogen#infect() 
call pathogen#helptags() 

" Use Vim settings, rather than Vi
set nocompatible

" Allow backgrounding buffers without writing them, and remember marks/undo
" for backgrounded buffers
set hidden

" Remember 1000 commands and search history
set history=1000

" Use a recursive path (for :find)
set path=**

" When :find-ing, search for files with this suffix
set suffixesadd=.py,.pyx,.java,.c,.cpp,.rb,.html,.jinja2,.js,.less,.css,.styl

" Make tab completion for files/buffers act like bash
set wildmenu
set wildmode=full
set wildignore+=*.png,*.jpg,*.jpeg,*.gif

" Make searches case-sensitive only if they contain upper-case characters
set ignorecase
set smartcase

" Show the row, column of the cursor
set ruler

" Display incomplete commands
set showcmd

" When a bracket is inserted, briefly jump to the matching one
set showmatch

" Begin searching as soon as you start typing
set incsearch

" Highlight search matches
set hls

" Auto-indent on line wrap
set showbreak=--->

" Highlight the cursor line only in the active window
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

" Don't reopen buffers
set switchbuf=useopen

" Always show tab line
set showtabline=2

" Size of tabs
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set laststatus=2

" Detect filetypes
au BufRead,BufNewFile *.sls set ft=yaml
au BufRead,BufNewFile *.jinja2 set ft=jinja2
au BufRead,BufNewFile *.snippets set ft=snippets
au BufRead,BufNewFile *.js set ft=javascript
au BufRead,BufNewFile *.md set ft=markdown
au BufRead,BufNewFile *.go set ft=go

" Use 2-space tabs for certain file types
au FileType jinja2,yaml,html,json,javascript,coffee,css,less,stylus setlocal shiftwidth=2 tabstop=2 softtabstop=2
" Trim trailing whitespace
autocmd BufWrite *.js,*.coffee,*.css,*.less,*.styl,*.py,*.rb,*.go if ! &bin | silent! %s/\s\+$//ge | endif

" use the :help command for 'K' in .vim files
autocmd FileType vim set keywordprg=":help"

" SOLARIZED
syntax enable
syntax on
set t_Co=256
let g:solarized_termcolors=256
let g:solarized_contrast="high"
let g:solarized_visibility="high"
set background=light
colorscheme solarized

" Return to last edit position when opening files
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
map N Nzz
map n nzz

" Set fileformat to Unix
set ff=unix

" Set encoding to UTF
set enc=utf-8

" Line numbers on
set nu

" Enable use of mouse
set mouse=a

" Use 'g' flag by default with :s/foo/bar
set gdefault

" allow cursor to wrap to next/prev line
set whichwrap=h,l

filetype plugin on
filetype plugin indent on

" Add bash shortcuts for command line
:cnoremap <C-a>  <Home>
:cnoremap <C-b>  <Left>
:cnoremap <C-f>  <Right>
:cnoremap <C-d>  <Delete>
:cnoremap <M-b>  <S-Left>
:cnoremap <M-f>  <S-Right>
:cnoremap <M-d>  <S-right><Delete>
:cnoremap <Esc>b <S-Left>
:cnoremap <Esc>f <S-Right>
:cnoremap <Esc>d <S-right><Delete>
:cnoremap <C-g>  <C-c>

" Function to rename the current file
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>

" Execute current file
function! SmartRun()
    :w
    :silent !clear
    if match(expand("%"), '.py$') != -1
        exec ":!python " . @%
    elseif match(expand("%"), '.sh$') != -1
        exec ":!bash " . @%
    elseif match(expand("%"), '.rb$') != -1
        exec ":!ruby " . @%
    elseif match(expand("%"), '.go$') != -1
        GoRun
    elseif match(expand("%"), '.coffee$') != -1
        exec ":!coffee " . @%
    end
endfunction
map <leader>e :call SmartRun()<cr>

" remap leader-leader to go back one file
nnoremap <leader><leader> <c-^>

" Map leader-r to do a global replace of a word
map <leader>r :%s/<C-R>=expand("<cword>")<CR>/<C-R>=expand("<cword>")<CR>

" Map leader-g to grep the hovered word in the current workspace
map <leader>g :grep -IR <cword> * <CR><CR> :copen <CR> <C-w><C-k>

" Fast tab navigation
map <leader>1 1gt
map <leader>2 2gt
map <leader>3 3gt
map <leader>4 4gt
map <leader>5 5gt
map <leader>6 6gt
map <leader>7 7gt
map <leader>8 8gt
map <leader>9 9gt

" Window size settings
set winwidth=88 " minimum width of current window (includes gutter)
set winheight=20 " minimal height of current window
let g:wequality = 1
function! ResizeWindows()
    if( g:wequality == 1 )
        exe ":normal \<C-w>="
    endif
endfunction
function! ToggleWinEqual()
    if( g:wequality == 0 )
        let g:wequality = 1
    else
        let g:wequality = 0
    endif
endfunction
augroup WinWidth
  au!
  " Keep window sizes roughly equal
  au VimEnter,WinEnter,BufWinEnter * :call ResizeWindows()
augroup END
nmap <C-w>+ :call ToggleWinEqual()<CR>

" Go to next/prev result with <Ctrl> + n/p
nmap <silent> <C-N> :cn<CR>zv
nmap <silent> <C-P> :cp<CR>zv

" Keep cursor in the vertical center of the editor
noremap <C-d> <C-d>zz
noremap <C-u> <C-u>zz
noremap G Gzz

" j and k navigate line-wraps in a sane way (also vertical center)
noremap j gjzz
noremap k gkzz

" Remap q: to just go to commandline.  To open the commandline window,
" do <C-r> from the commandline
:set cedit=<C-r>
nnoremap q: :

" Navigate tabs with <S-Tab>
map <S-Tab> gt

" Enter paste mode with <leader>p
nmap <leader>p :set paste<CR>a
nmap <leader>P :set paste<CR>i
vmap <leader>p s<C-o>:set paste<CR>
" Exit paste mode when leaving insert mode
au InsertLeave * set nopaste

" Smart folding
au BufEnter * if !exists('b:all_folded') | let b:all_folded = 1 | endif
function! ToggleFold()
    if( b:all_folded == 0 )
        exec "normal! zM"
        let b:all_folded = 1
    else
        exec "normal! zR"
        let b:all_folded = 0
    endif
endfunction
nmap <Space> za
nmap <leader><Space> :call ToggleFold()<CR>

" Quickly toggle the quickfix window
au BufEnter * if !exists('b:showing_quickfix') | let b:showing_quickfix = 0 | endif
function! ToggleQuickfix()
    if( b:showing_quickfix == 0 )
        exec "copen"
        let b:showing_quickfix = 1
    else
        exec "cclose"
        let b:showing_quickfix = 0
    endif
endfunction
map <leader>q :call ToggleQuickfix()<CR>

function! UpdateQuickfixStatus()
    let b:showing_quickfix = len(getqflist())
endfunction
au QuickfixCmdPost * call UpdateQuickfixStatus()

" Close the scratch preview automatically
autocmd CursorMovedI,InsertLeave * if pumvisible() == 0|pclose|endif

" Close quickfix if it's the only visible buffer
aug QFClose
  au!
  au WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix"|q|endif
aug END

" Attempt to expand a snippet. If no snippet exists, either autocomplete or
" insert a tab
let g:ulti_expand_or_jump_res = 0 "default value, just set once
let g:autocomplete_cmd = "\<C-P>"
function! CleverTab()
    call UltiSnips#ExpandSnippetOrJump()
    if g:ulti_expand_or_jump_res == 0
      if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
          return "\<Tab>"
      else
          return g:autocomplete_cmd
      endif
    else
      return ''
    endif
endfunction
inoremap <Tab> <C-R>=CleverTab()<CR>
snoremap <Tab> <Esc>:call UltiSnips#ExpandSnippetOrJump()<cr>


" Do syntax checking on file open
let g:syntastic_check_on_open=1
" Don't use syntastic on python, use python-mode instead
let g:syntastic_mode_map = { 'mode': 'active',
                               \ 'passive_filetypes': ['python'] }

" Useful for removing whitespace after abbreviations
function! Eatchar(pat)
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunc

" BASH-style movement in insert mode
inoremap <C-a> <C-o>0
inoremap <C-e> <C-o>$

" Rebind ultisnips to something never used. We use CleverTab :)
let g:UltiSnipsExpandTrigger="<f12>"
let g:UltiSnipsJumpForwardTrigger="<f12>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"


" Put all my useful ultisnips globals in here
py import sys, os; sys.path.append(os.environ['HOME'] + '/.vim/UltiSnips/mods')

" Toggle nerdtree
:nmap <leader>w :NERDTreeToggle<CR>

" EasyMotion
let g:EasyMotion_do_mapping = 0 " Disable default mappings

let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <C-j> <Plug>(easymotion-j)
map <C-k> <Plug>(easymotion-k)

map f <Plug>(easymotion-s)
