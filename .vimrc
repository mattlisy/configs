
syntax enable
set backspace=indent,eol,start
set number

call plug#begin()
	Plug 'junegunn/goyo.vim'
	Plug 'frazrepo/vim-rainbow'
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'scrooloose/syntastic'
	Plug 'nanotech/jellybeans.vim'
	Plug 'wakatime/vim-wakatime'
	Plug 'thaerkh/vim-workspace'
call plug#end()

" workspace enable
let g:workspace_autocreate = 1

" Set theme
colorscheme jellybeans 
        
" rainbow parathesis
let g:rainbow_active = 1

" Goyo enter
function! s:goyo_enter()
    let g:goyo_width='70%'
    let g:goyo_height='95%'
    let b:quitting = 0
    let b:quitting_bang = 0
    autocmd QuitPre <buffer> let b:quitting = 1
    cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
    cabbrev <buffer> wq <bar> x
    cabbrev <buffer> x <bar> wq

endfunction

" Goyo leave
function! s:goyo_leave()
    " Quit Vim if this is the only remaining buffer
    if exists('b:quitting') && b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
        if exists('b:quitting_bang') && b:quitting_bang
            qa!
        else
            qa
        endif
    endif
endfunction

autocmd! User GoyoEnter call <SID>goyo_enter()
autocmd! User GoyoLeave call <SID>goyo_leave()

" Enable Goyo 
autocmd VimEnter * Goyo


" use enter to trigger completion and navigate to the next complete item

function! CheckBackspace() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <Tab> 
			\ coc#pum#visible() ? coc#pum#next(1) :
			\ CheckBackspace() ? "\<Tab>" :
			\ coc#refresh()


noremap <expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
inoremap <expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
			\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
