vim.g.copilot_no_tab_map = true

local map_opts = {
    expr = true,
    silent = true,
    noremap = true,
    replace_keycodes = false,
}

vim.keymap.set("i", "<C-l>", function()
    return vim.fn["copilot#Accept"]("")
end, map_opts)

vim.keymap.set("i", "<C-a>", function()
    return vim.fn["copilot#Accept"]("")
end, map_opts)
