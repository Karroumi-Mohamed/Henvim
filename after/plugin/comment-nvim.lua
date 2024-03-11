require('Comment').setup({
    ignore = '^$', -- ignore empty lines
    toggler = {
        line = '<leader>cc',
        block = '<leader>bc',
    }, -- toggler keymap

    opleader = {
        line = '<leader>c',
        block = '<leader>b',
    } -- operator keymap

    -- toggler is a table with 2 keys, line and block, which are the keymaps for toggling comments
    -- opleader is a table with 2 keys, line and block, which are the keymaps for commenting operators/
})
