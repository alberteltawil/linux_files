local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
    -- self managing plugin manager
    use 'wbthomason/packer.nvim'

    -- themes / colorschemes
    use 'catppuccin/nvim'
    use 'ellisonleao/gruvbox.nvim'

    -- plugins
    use 'stevearc/aerial.nvim' -- class and variable outliner
    use 'emmanueltouzery/decisive.nvim' -- csv formatter
    use 'nvim-tree/nvim-tree.lua' -- fancy file explorer
    use 'nvim-tree/nvim-web-devicons' -- icon support
    use 'nvim-lualine/lualine.nvim' -- bottom status line
    use 'nvim-treesitter/nvim-treesitter'
    use { -- open files, find text globally
        'nvim-telescope/telescope.nvim',
        tag = '0.1.7',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use { -- top tab bar
        'akinsho/bufferline.nvim',
        tag = "*",
        requires = 'nvim-tree/nvim-web-devicons'
  }
    if packer_bootstrap then
        require('packer').sync()
    end
end)
