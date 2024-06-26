local opts = { noremap = true, silent = true }

-- Custom function to move cursor up 5 lines
function _G.move_cursor_up()
    local current_line = vim.fn.line(".")
    if current_line > 5 then
        vim.cmd(":normal! 5k")
    else
        vim.cmd(":normal! " .. (current_line - 1) .. "k")
    end
end

-- Custom function to move cursor down 5 lines
function _G.move_cursor_down()
    local current_line = vim.fn.line(".")
    local last_line = vim.fn.line("$")
    if current_line < last_line - 5 then
        vim.cmd(":normal! 5j")
    else
        vim.cmd(":normal! " .. (last_line - current_line) .. "j")
    end
end

-- Remove whitespaces
function trim_whitespace()
    -- Save cursor position and view
    local save_cursor = vim.fn.getpos(".")
    local save_view = vim.fn.winsaveview()
    -- Remove trailing whitespace
    vim.cmd([[silent! %s/\s\+$//e]])
    -- Remove spaces from empty lines but keep single empty lines
    vim.cmd([[silent! %s/^\s*$//e]])
    -- Restore cursor position and view
    vim.fn.setpos(".", save_cursor)
    vim.fn.winrestview(save_view)
    -- Remove highlighting
    vim.cmd("nohlsearch")
end

-- nvim global configurations and option settings
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- vim.opt.backspace = '4'
vim.opt.clipboard:append("unnamedplus")
vim.opt.scroll = 5
vim.opt.scrolloff = 999
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

-- Set GIT_PAGER environment variable to ensure color support in Neovim terminal
vim.cmd('let $GIT_PAGER="less -R"')
-- Create a custom command or key mapping for git diff with color
-- vim.keymap.set('n', '<leader>gd', ':!git diff --color=always<CR>', opts)

-- keymap to clear word highlighting after searching or replacing text
vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')

-- keymap to remove whitespaces
vim.keymap.set('n', '<Leader>w', ':lua trim_whitespace()<CR>', opts)

-- keymap for opening bash terminal bottom right of window
vim.keymap.set('n', '<leader>t', ':botright split | terminal<CR>')

-- keymaps for decisive to format csv files into tabular views and navigating columns
vim.keymap.set('n', '<leader>cc', ":lua require('decisive').align_csv({})<CR>", {desc="align CSV", silent=true})
vim.keymap.set('n', '[c', ":lua require('decisive').align_csv_prev_col()<CR>", {desc="align CSV prev col", silent=true})
vim.keymap.set('n', ']c', ":lua require('decisive').align_csv_next_col()<CR>", {desc="align CSV next col", silent=true})
-- vim.keymap.set('n', '<leader>ccA', ":lua require('decisive').align_csv_clear({})<cr>", {desc="align CSV clear", silent=true})

-- toggle the opening of Aerial; class, function, variable outline
vim.keymap.set("n", "<F8>", "<cmd>AerialToggle!<CR>")

-- Ctrl + Up/Down to move cursor up/down a number of lines
vim.keymap.set('n', '<C-Up>',   '<Cmd>lua _G.move_cursor_up()<CR>', opts)
vim.keymap.set('n', '<C-Down>', '<Cmd>lua _G.move_cursor_down()<CR>', opts)
vim.keymap.set('i', '<C-Up>', '<Esc>:lua _G.move_cursor_up()<CR>i', { noremap = true })
vim.keymap.set('i', '<C-Down>', '<Esc>:lua _G.move_cursor_down()<CR>i', { noremap = true })

-- formatter keymaps
-- vim.keymap.set('n', '<leader>f', ':Format<CR>', opts)
