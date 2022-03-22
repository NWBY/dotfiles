call plug#begin()
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-telescope/telescope.nvim'
Plug 'ms-jpq/coq_nvim', { 'branch': 'coq' }
Plug 'ms-jpq/coq.artifacts', { 'branch': 'artifacts' }
Plug 'ms-jpq/coq.thirdparty', { 'branch': '3p' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'neovim/nvim-lspconfig'
call plug#end()

set exrc
set guicursor=
set shiftwidth=4
set tabstop=4 softtabstop=4
set expandtab
set relativenumber
set incsearch
set nu
set clipboard+=unnamedplus
set nohlsearch
set noswapfile
set scrolloff=8

set signcolumn=yes

let mapleader=","
let g:tokyonight_style = "night"

colorscheme tokyonight

nnoremap <silent> <leader>tg :Telescope git_files<CR>

au BufEnter :COQnow --shut-up<CR>

lua << EOF
require('telescope').setup {
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case"
        }
    }
}

require('telescope').load_extension('fzf')

require('lspconfig').pyright.setup{}
-- require('nvim-treesitter.configs').setup {
--    ensure_installed = 'maintained',
--    highlight = {
--        enable = true,
--    }
-- }
EOF
