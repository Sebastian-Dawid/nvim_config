require("sdawid")
vim.filetype.add({ extension = { hip = 'cpp' } })
vim.filetype.add({ extension = { vert = 'glsl' } })
vim.filetype.add({ extension = { frag = 'glsl' } })
vim.filetype.add({ extension = { comp = 'glsl' } })
vim.filetype.add({ extension = { slang = 'shaderslang' } })

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.loop or vim.uv).fs_stat(lazypath) then
	vim.fn.system {
		'git',
		'clone', '--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', -- latest stable release
		lazypath,
	}
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require('lazy').setup({
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
	},

	require 'sdawid.plugins.lazydev',

	{ 'j-hui/fidget.nvim',           opts = {} },
	{ 'danilo-augusto/vim-afterglow' },

	require 'sdawid.plugins.gitsigns',
	require 'sdawid.plugins.lualine',

	-- "gc" to comment visual regions/lines
	{ 'numToStr/Comment.nvim', opts = {} },

	-- Fuzzy Finder (files, lsp, etc)
	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			-- Fuzzy Finder Algorithm which requires local dependencies to be built.
			-- Only load if `make` is available. Make sure you have the system
			-- requirements installed.
			{
				'nvim-telescope/telescope-fzf-native.nvim',
				-- NOTE: If you are having trouble with this installation,
				--       refer to the README for telescope-fzf-native for more instructions.
				build = 'make',
				cond = function()
					return vim.fn.executable 'make' == 1
				end,
			},
			{ "nvim-tree/nvim-web-devicons", opts = {} },
		},
	},

	{
		-- Highlight, edit, and navigate code
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		build = ':TSUpdate',
	},

	-- Not sure if I want to keep this one...
	{
		-- Add indentation guides even on blank lines
		'lukas-reineke/indent-blankline.nvim',
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help ibl`
		main = 'ibl',
		opts = {},
	},

	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		}
	},

	{
		"kdheepak/lazygit.nvim",
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	require 'sdawid.plugins.debug'
}, {})

vim.keymap.set('n', '<C-p>', require('telescope.builtin').find_files, {})
vim.keymap.set('n', '<leader>pf', require('telescope.builtin').git_files, {})
vim.keymap.set('n', '<leader>pb', require('telescope.builtin').buffers, {})
vim.keymap.set('n', '<leader>pg', require('telescope.builtin').live_grep, {})

vim.defer_fn(function()
	require('nvim-treesitter.configs').setup {
		ensure_installed = { "c", "lua", "zig", "asm", "julia" },

		sync_install = false,

		auto_install = false,

		ignore_install = {},

		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		modules = {},
	}
end, 0)

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
		local nmap = function(keys, func, desc)
			if desc then
				desc = 'LSP: ' .. desc
			end

			vim.keymap.set('n', keys, func, { buffer = args.buf, desc = desc })
		end

		nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
		nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

		nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
		nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
		nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
		nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
		nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
		nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

		-- NOTE: (SD) No longer needed as these are now the default in NeoVim
		-- nmap(']d', vim.diagnostic.goto_next, 'Next [D]iagnostic')
		-- nmap('[d', vim.diagnostic.goto_prev, 'Prev [D]iagnostic')

		nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
		nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
		-- use <C-s> for signature help in insert mode, that is the default and makes more sense than <C-h>
		-- vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, { buffer = args.buf, desc = 'Signature Documentation' })


		vim.api.nvim_buf_create_user_command(args.buf, 'Format', function(_)
			vim.lsp.buf.format()
		end, { desc = 'Format current buffer with LSP' })
	end,
})


local servers = {
	clangd = {},
	rust_analyzer = {},
	julials = {},
	lua_ls = {},
	texlab = {},
	ltex = {},
	zls = {}
}

local mason_lspconfig = require 'mason-lspconfig'
mason_lspconfig.setup {
	ensure_installed = vim.tbl_keys(servers),
	automatic_enable = true,
}

local lspconfig = require('lspconfig')
lspconfig.glsl_analyzer.setup {}
lspconfig.slangd.setup {
	settings = {
		slang = {
			cmd = { "slangd" },
			filetypes = { "shaderslang", "hlsl" },
			single_file_support = true,
		}
	}
}

vim.lsp.config('clangd', {
	-- use the clangd version distributed with clang
	cmd = { "/usr/bin/clangd", "--header-insertion=never" },
})

vim.lsp.config('lua_ls', {
	Lua = {
		workspace = { checkThirdParty = false },
		telemetry = { enable = false }
	}
})

vim.lsp.inlay_hint.enable()

vim.cmd.colorscheme('afterglow')
