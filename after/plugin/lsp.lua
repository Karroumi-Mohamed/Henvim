local lsp = require("lsp-zero")
local lspconfig = require("lspconfig")
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

-- Configure individual servers
lspconfig.clangd.setup({})
lspconfig.lua_ls.setup({})
lspconfig.gleam.setup({
    cmd = { "gleam", "lsp" },
    filetypes = { "gleam" },
    root_dir = lspconfig.util.root_pattern("gleam.toml"),
    on_attach = function(client, bufnr)
        vim.keymap.set("n", "<leader>vv", function() vim.diagnostic.open_float() end, { buffer = bufnr, remap = false })
    end,
    settings = {
        gleam = {}
    }
})

-- Setup lsp-zero v3
lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vv", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

-- Configure completion
local cmp = require('cmp')
cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'luasnip' },
    },
mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Add this line
    ['<C-Space>'] = cmp.mapping.complete(),
}),
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