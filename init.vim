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
Plug 'nvim-telescope/telescope-file-browser.nvim'
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
set hidden

set signcolumn=yes

let mapleader=","
let g:tokyonight_style = "night"

colorscheme tokyonight

nnoremap <silent> <leader>tg :Telescope git_files<CR>
nnoremap <silent> <leader>tf :Telescope file_browser<CR>

au BufEnter :COQnow --shut-up<CR>

lua << EOF
require('telescope').setup {
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case"
        },
        file_browsr = {
            theme = 'tokyonight',
        }
    }
}

require('telescope').load_extension('fzf')
require('telescope').load_extension('file_browser')

local servers = { 'pyright', 'intelephense' }
for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
    }
  }
end
-- require('lspconfig').pyright.setup{}
-- require('nvim-treesitter.configs').setup {
--    ensure_installed = 'maintained',
--    highlight = {
--        enable = true,
--    }
-- }
EOF
