set list listchars=tab:<=>,leadmultispace:---\|,precedes:<,extends:>,nbsp:-,trail:-
set number relativenumber cursorline termguicolors showcmd
set mouse= scrolloff=3 confirm
set tabstop=4 shiftwidth=0 softtabstop=-1 expandtab smarttab autoindent shiftround
set incsearch ignorecase smartcase
set undofile hidden

filetype plugin indent on

colorscheme tokyonight-storm
highlight ColorColumn guibg=#232739

let g:loaded_netrw=1
let g:loaded_netrwPlugin=1

noremap <C-c> <ESC>
inoremap <C-c> <ESC>
noremap <Space> <NOP>
noremap <Backspace> <NOP>
let g:mapleader=" "

map <Leader>c "+y
map <Leader>v "+p


noremap <Leader>s :w<CR>

nnoremap <Leader>t :new<CR>:terminal<CR><C-w>J:res 10<CR>
tnoremap <C-t> <C-\><C-n>

nnoremap <Leader>h <C-w>h
nnoremap <Leader>j <C-w>j
nnoremap <Leader>k <C-w>k
nnoremap <Leader>l <C-w>l

nnoremap <Leader>wh <C-w>H
nnoremap <Leader>wj <C-w>J
nnoremap <Leader>wk <C-w>K
nnoremap <Leader>wl <C-w>L

nnoremap <Leader>q :q<CR>
nnoremap <Leader>n :new<CR>
nnoremap <Leader><Esc> :noh<CR>

nnoremap <Leader>b :lua require('telescope.builtin').buffers()<CR>
nnoremap <Leader>f :lua require('telescope').extensions.file_browser.file_browser()<CR>

nnoremap <Leader>gh :lua require('telescope.builtin').git_stash()<CR>
nnoremap <Leader>gs :lua require('telescope.builtin').git_status()<CR>
nnoremap <Leader>gc :lua require('telescope.builtin').git_commits()<CR>
nnoremap <Leader>gb :lua require('telescope.builtin').git_branches()<CR>

nnoremap <Leader>d :lua vim.lsp.buf.definition()<CR>
nnoremap <Leader>r :lua vim.lsp.buf.references()<CR>
nnoremap <Backspace> :lua vim.lsp.buf.format()<CR>
nnoremap <Leader><Leader> :lua for _=1,2 do vim.lsp.buf.hover() end<CR>

