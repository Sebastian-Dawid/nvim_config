return {
    'mfussenegger/nvim-dap',
    -- NOTE: And you can specify dependencies as well
    dependencies = {
        -- Creates a beautiful debugger UI
        'rcarriga/nvim-dap-ui',

        -- Installs the debug adapters for you
        'williamboman/mason.nvim',
        'jay-babu/mason-nvim-dap.nvim',

        -- Add your own debuggers here
        'leoluz/nvim-dap-go',
    },
    config = function()
        local dap = require('dap')
        local dapui = require('dapui')

        require('mason-nvim-dap').setup({
            automatic_setup = true,
            handlers = {},
            ensure_installed = { 'codelldb' }
        })

        vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
        vim.keymap.set('n', '<F10>', dap.step_into, { desc = 'Debug: Step Into' })
        vim.keymap.set('n', '<F11>', dap.step_over, { desc = 'Debug: Step Over' })
        vim.keymap.set('n', '<F12>', dap.step_out, { desc = 'Debug: Step Out' })
        vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })

        vim.keymap.set('n', '<F9>', dapui.toggle, { desc = "Debug: See last session result." })
    end
}
