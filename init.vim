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
Plug 'kyazdani42/nvim-tree.lua'
Plug 'ray-x/lsp_signature.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'
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

nnoremap <silent> <leader>tt :NvimTreeToggle<CR>
nnoremap <silent> <leader>ti :NvimTreeFindFile<CR>
nnoremap <silent> <leader>to :NvimTreeFocus<CR>

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
local on_attach = function(client, bufnr)
    local opts = { noremap=true, silent=true }

    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>F', '<cmd>lua vim.lsp.buf.formatting_sync()<CR>', opts)

    require "lsp_signature".on_attach()
end

local servers = { 'pyright', 'intelephense', 'tsserver', 'tailwindcss' }
for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    coq.lsp_ensure_capabilities {}
  }
end
vim.cmd('COQnow -s')

-- null-ls stuff start
require("null-ls").setup({
    sources = {
        require("null-ls").builtins.formatting.prettier,
    },
})

null_ls_on_attach = function(client)
    if client.resolved_capabilities.document_formatting then
        vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
    end
end
require("lspconfig")["null-ls"].setup({
    on_attach = null_ls_on_attach
})
-- null-ls stuff end

require('lualine').setup {
    options = {
        theme = 'tokyonight',
        icons_enabled = true
    }
}

require('nvim-web-devicons').setup{}
require('nvim-web-devicons').get_icons()
require('nvim-tree').setup{}
require('nvim-treesitter.configs').setup {
    ensure_installed = 'maintained',
    highlight = {
        enable = true,
    }
}
EOF
