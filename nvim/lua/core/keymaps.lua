vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- vim.opt.backspace = '4'
vim.opt.scroll = 5
vim.opt.scrolloff = 10
vim.opt.number = true
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.autoread = true
vim.opt.wrap = false
vim.opt.shell = 'bash'

-- spaces for tabs and whatnot
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.expandtab = true

vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')
vim.keymap.set('n', '<leader>t', ':botright split | terminal<CR>')
vim.keymap.set('n', '<leader>cc', ":lua require('decisive').align_csv({})<CR>", {desc="align CSV", silent=true})
-- vim.keymap.set('n', '<leader>ccA', ":lua require('decisive').align_csv_clear({})<cr>", {desc="align CSV clear", silent=true})
vim.keymap.set('n', '[c', ":lua require('decisive').align_csv_prev_col()<CR>", {desc="align CSV prev col", silent=true})
vim.keymap.set('n', ']c', ":lua require('decisive').align_csv_next_col()<CR>", {desc="align CSV next col", silent=true})
vim.keymap.set("n", "<F8>", "<cmd>AerialToggle!<CR>")
