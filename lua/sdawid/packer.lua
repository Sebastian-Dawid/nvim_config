-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.2',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    use({
        "neanias/everforest-nvim",
        -- Optional; default configuration will be used if setup isn't called.
        config = function()
            require("everforest").setup({
                background = "hard",
                transparent_background_level=1,
                italics=true,
                disable_italic_comments=true,
                sign_column_background="none",
                ui_contrast="low",
                dim_inactive_windows=false,
                diagnostic_text_highlight=false,
                diagnostic_virtual_text="coloured",
                diagnostic_line_highlight=false,
                spell_foreground=false,
                on_highlights=function(highlight_groups, palette) end
            })
        end,
    })

    use {
        'williamboman/mason.nvim',
        config = function ()
            require('mason').setup()
        end
    }
    use {
        'mfussenegger/nvim-dap',
    }
    use {
        'jay-babu/mason-nvim-dap.nvim',
        requires = {
            'williamboman/mason.nvim',
            'mfussenegger/nvim-dap'
        },
        config = function ()
            require('mason-nvim-dap').setup({
                ensure_installed = { 'codelldb' },
                handlers = {}
            })
        end
    }

    use {
        "rcarriga/nvim-dap-ui",
        requires = {"mfussenegger/nvim-dap"},
        config = function ()
            local dap, dapui = require("dap"), require("dapui")
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end
    }

    use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
    use('nvim-treesitter/playground')
    use('theprimeagen/harpoon')
    use('mbbill/undotree')
    use('tpope/vim-fugitive')

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},             -- Required
            {                                      -- Optional
                'williamboman/mason.nvim',
                run = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            {'williamboman/mason-lspconfig.nvim'}, -- Optional

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},     -- Required
            {'hrsh7th/cmp-nvim-lsp'}, -- Required
            {'L3MON4D3/LuaSnip'},     -- Required
        }
    }

    use {"akinsho/toggleterm.nvim", tag = '*'}
end)
