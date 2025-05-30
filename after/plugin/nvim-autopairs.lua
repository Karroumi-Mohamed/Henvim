local autopairs = require("nvim-autopairs")
local cmp = require("cmp")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")

autopairs.setup({
    check_ts = true, -- Enable treesitter integration
    ts_config = {
        lua = {'string'},
        javascript = {'template_string'},
    },
    disable_filetype = { "TelescopePrompt", "vim" },
    fast_wrap = {
        map = '<M-e>',
        chars = { '{', '[', '(', '"', "'" },
        pattern = [=[[%'%"%)%>%]%)%}%,]]=],
        end_key = '$',
        keys = 'qwertyuiopzxcvbnmasdfghjkl',
        check_comma = true,
        highlight = 'Search',
        highlight_grey='Comment'
    },
})

-- Integration with nvim-cmp
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())