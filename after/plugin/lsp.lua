require("luasnip.loaders.from_vscode").lazy_load()

-- Setup mason first
require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
        'tailwindcss',
        'html',
        'lua_ls',
        'clangd',
        'ts_ls',
    },
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(event)
        local bufnr = event.buf
        local opts = { buffer = bufnr, silent = true, remap = false }

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
        vim.keymap.set("n", "<leader>vv", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
    end,
})

local function setup_server(name, opts)
    local config = vim.tbl_deep_extend("force", {
        capabilities = capabilities,
    }, opts or {})

    vim.lsp.config(name, config)
    vim.lsp.enable(name)
end

setup_server('clangd')
setup_server('lua_ls')
setup_server('tailwindcss')
setup_server('html')
setup_server('ts_ls')
--[[ setup_server('gleam', {
    cmd = { "gleam", "lsp" },
}) ]]

-- Configure completion
local cmp = require('cmp')
cmp.setup({
    preselect = cmp.PreselectMode.Item,
    completion = {
        completeopt = "menu,menuone,preview",
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<Tab>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'luasnip' },
    },
})

-- SQL completion
cmp.setup.filetype({'sql', 'mysql'}, {
    sources = {
        { name = 'vim-dadbod-completion' },
        { name = 'buffer' },
    }
})

vim.diagnostic.config({
    virtual_text = true
})
