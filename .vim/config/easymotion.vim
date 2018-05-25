let s:numbermap = {
\ 'a': 1,
\ 's': 2,
\ 'd': 3,
\ 'f': 4,
\ 'g': 5,
\ 'h': 6,
\ 'j': 7,
\ 'k': 8,
\ 'l': 9,
\ ';': 0,
\}
function RelativeJump(motion)
    setlocal relativenumber
    redraw!
    let numInput = input('Jump to: ')
    let num = ''
    for char in split(numInput, '\zs')
        let num .= get(s:numbermap, char, char)
    endfor
    setlocal norelativenumber
    exec "normal! " . num . a:motion
endfunction

nnoremap <C-j> :call RelativeJump("j")<CR>
nnoremap <C-k> :call RelativeJump("k")<CR>
