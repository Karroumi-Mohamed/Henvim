require("thisishemmit.set")
require("thisishemmit.remap")
local vim = vim
-- DO NOT INCLUDE THIS
vim.opt.rtp:append("~/personal/streamer-tools")
-- DO NOT INCLUDE THIS

local augroup = vim.api.nvim_create_augroup
local ThePrimeagenGroup = augroup('ThePrimeagen', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd({ "BufWritePre" }, {
    group = ThePrimeagenGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

vim.api.nvim_create_autocmd('TermOpen', {
    group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
    callback = function()
        vim.opt.number = false
        vim.opt.relativenumber = false
    end,
})

local job_id = nil

local function create_or_get_terminal()
    if job_id == nil or vim.fn.jobwait({ job_id }, 0)[1] ~= -1 then
        vim.cmd.vnew()
        vim.cmd.term('zsh')
        vim.cmd.wincmd('J')
        vim.api.nvim_win_set_height(0, 5)

        job_id = vim.bo.channel
    else
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].channel == job_id then
                vim.api.nvim_set_current_win(win)
                return
            end
        end
        -- If we didn't find the terminal window, create a new one
        vim.cmd.vnew()
        vim.cmd.term('zsh')
        vim.cmd.wincmd('J')
        vim.api.nvim_win_set_height(0, 5)

        job_id = vim.bo.channel
    end
end

vim.keymap.set('n', '<leader>st', function()
    create_or_get_terminal()
end)

vim.keymap.set('t', '<C-n>',
    '<C-\\><C-n>', { noremap = true })
