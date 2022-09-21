call plug#begin()
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-telescope/telescope.nvim'

" cmp and vsnip end
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
" cmp and vsnip end

" Plug 'ms-jpq/coq_nvim', { 'branch': 'coq' }
" Plug 'ms-jpq/coq.artifacts', { 'branch': 'artifacts' }
" Plug 'ms-jpq/coq.thirdparty', { 'branch': '3p' }
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
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>F', '<cmd>lua vim.lsp.buf.formatting_sync()<CR>', opts)

    require "lsp_signature".on_attach()
end

-- cmp start
local cmp = require'cmp'

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        end,
    },
    mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif vim.fn["vsnip#available"](1) == 1 then
                feedkey("<Plug>(vsnip-expand-or-jump)", "")
            elseif has_words_before() then
                cmp.complete()
            else
                fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_prev_item()
            elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                feedkey("<Plug>(vsnip-jump-prev)", "")
            end
        end, { "i", "s" }),
        ['<CR>'] = cmp.mapping.confirm({ select = true })
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' }, -- For vsnip users.
    }, {
        { name = 'buffer' },
    })
})

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

local servers = { 'pyright', 'intelephense', 'tsserver', 'tailwindcss', 'gopls', 'html' }
for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities
  }
end

require('lspconfig')['volar'].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    init_options = {
        typescript = {
            serverPath = '/usr/local/lib/node_modules/typescript/lib/tsserverlibrary.js'
        }
    }
}
-- vim.cmd('COQnow -s')

-- null-ls stuff start
null_ls_on_attach = function(client)
    if client.server_capabilities.document_formatting then
        vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.format()")
    end
end

require("null-ls").setup({
    on_attach = null_ls_on_attach,
    sources = {
        require("null-ls").builtins.formatting.prettier,
        require("null-ls").builtins.formatting.black
    },
})

-- null-ls stuff end

require('lualine').setup {
    options = {
        theme = 'tokyonight',
        icons_enabled = true
    },
    sections = {
        lualine_c = {
            {
                'filename',
                path = 1
            }
        }
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
