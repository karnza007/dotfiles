" Line numbers
set number

" True color (richer colorscheme rendering; tmux already advertises Tc)
set termguicolors
colorscheme evening
" Syntax highlighting + filetype detection & indentation
syntax on
filetype plugin indent on
autocmd BufNewFile,BufRead *.v,*.vh set filetype=verilog

" Sensible indentation (good defaults for Verilog/SystemVerilog)
set expandtab        " use spaces instead of tabs
set tabstop=4        " a tab displays as 4 spaces
set shiftwidth=4     " auto-indent uses 4 spaces
set softtabstop=4    " Tab key inserts 4 spaces
set autoindent       " keep indent from previous line

" Cursor: blinking bar in insert mode, block in normal mode
let &t_SI = "\e[5 q"
let &t_EI = "\e[1 q"

" Cycle colorschemes live: F8 = next, Shift-F8 = previous
let g:my_schemes = getcompletion('', 'color')
let g:my_scheme_idx = 0
function! CycleColor(step)
  let g:my_scheme_idx = (g:my_scheme_idx + a:step + len(g:my_schemes)) % len(g:my_schemes)
  execute 'colorscheme ' . g:my_schemes[g:my_scheme_idx]
  redraw
  echo '[' . (g:my_scheme_idx+1) . '/' . len(g:my_schemes) . '] ' . g:my_schemes[g:my_scheme_idx]
endfunction
nnoremap <F8> :call CycleColor(1)<CR>
nnoremap <S-F8> :call CycleColor(-1)<CR>
