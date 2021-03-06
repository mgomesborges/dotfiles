" Abbreviations
iabbr <buffer> inn is not None
iabbr <buffer> ipmort import
iabbr <buffer> improt import

" Foxdot
nnoremap <buffer> <CR> :call system('nc localhost 7088', getline('.'))<CR>
vnoremap <buffer> <CR> y:call system('nc localhost 7088', @")<CR>

setlocal shiftwidth=4 tabstop=4 softtabstop=4 tw=88

let b:neoformat_enabled_python = ['isort', 'black']
let b:neoformat_run_all_formatters = 1
augroup pyfmt
  autocmd! * <buffer>
  autocmd BufWritePre <buffer> call smartformat#Format('python', 'Neoformat')
augroup END

nnoremap <leader>e :call execute#Run('python')<cr>
