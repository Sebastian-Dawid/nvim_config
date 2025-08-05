-- Bubbles config for lualine
-- Author: lokesh-krishna
-- MIT license, see LICENSE for more details.

-- stylua: ignore
local colors = {
	blue   = '#80a0ff',
	cyan   = '#79dac8',
	black  = '#080808',
	white  = '#c6c6c6',
	red    = '#ff5189',
	violet = '#d183e8',
	grey   = '#303030',
}

local bubbles_theme = {
	normal = {
		a = { fg = colors.black, bg = colors.violet },
		b = { fg = colors.white, bg = colors.grey },
		c = { fg = colors.white },
	},

	insert = { a = { fg = colors.black, bg = colors.blue } },
	visual = { a = { fg = colors.black, bg = colors.cyan } },
	replace = { a = { fg = colors.black, bg = colors.red } },

	inactive = {
		a = { fg = colors.white, bg = colors.black },
		b = { fg = colors.white, bg = colors.black },
		c = { fg = colors.white },
	},
}

return {
	'nvim-lualine/lualine.nvim',
	opts = {
		options = {
			theme = bubbles_theme,
			component_separators = '',
			section_separators = { left = '', right = '' },
		},
		sections = {
			lualine_a = { { 'mode', separator = { left = '', right = '' }, right_padding = 2 } },
			lualine_b = { 'filesize', 'filename', 'branch', 'diff', 'diagnostics' },
			lualine_c = {
				'%=', --[[ add your center components here in place of this comment ]]
				{
					function()
						local msg = 'No Active Lsp'
						local buf_ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
						local clients = vim.lsp.get_clients()
						if next(clients) == nil then
							return msg
						end
						for _, client in ipairs(clients) do
							local filetypes = client.config.filetypes
							if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
								return client.name
							end
						end
						return msg
					end,
					icon = ' LSP:',
				}
			},
			lualine_x = {},
			lualine_y = { 'o:encoding', 'filetype', 'progress' },
			lualine_z = {
				{ 'location', separator = { right = '', left = '' }, left_padding = 2 },
			},
		},
		inactive_sections = {
			lualine_a = { 'filename' },
			lualine_b = {},
			lualine_c = {},
			lualine_x = {},
			lualine_y = {},
			lualine_z = { 'location' },
		},
		tabline = {},
		extensions = {},
	},
}
