call plug#begin()
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-telescope/telescope.nvim'
Plug 'ms-jpq/coq_nvim', { 'branch': 'coq' }
Plug 'ms-jpq/coq.artifacts', { 'branch': 'artifacts' }
Plug 'ms-jpq/coq.thirdparty', { 'branch': '3p' }
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
call plug#end()

set guifont=FiraCode\ Nerd\ Font:h19
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
set smartindent

set signcolumn=yes

let mapleader=","
let g:tokyonight_style = "night"

colorscheme tokyonight

nnoremap <silent> <leader>tg :Telescope git_files<CR>
nnoremap <silent> <leader>tf :Telescope file_browser<CR>
nnoremap <silent> <leader>tb :Telescope buffers<CR>
nnoremap <silent> <leader>tr :Telescope live_grep<CR>

nnoremap p p=`]

lua << EOF
require('telescope').setup {
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case"
        },
        file_browser = {
            hidden = true
        }
    }
}

require('telescope').load_extension('fzf')
require('telescope').load_extension('file_browser')

local coq = require "coq"
local servers = { 'pyright', 'intelephense' }
for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
    },
    coq.lsp_ensure_capabilities {}
  }
end
vim.cmd('COQnow -s')

require('lualine').setup {
    options = {
        theme = 'tokyonight',
        icons_enabled = true
    }
}

require('nvim-web-devicons').setup{}
require('nvim-web-devicons').get_icons()
-- require('lspconfig').pyright.setup{}
-- require('nvim-treesitter.configs').setup {
--    ensure_installed = 'maintained',
--    highlight = {
--        enable = true,
--    }
-- }
EOF
