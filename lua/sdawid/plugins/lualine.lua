-- Bubbles config for lualine
-- Author: lokesh-krishna
-- MIT license, see LICENSE for more details.

-- stylua: ignore
local colors = {
    blue   = '#bfdaff',
    cyan   = '#eaffc0',
    black  = '#000004',
    white  = '#f8f8ff',
    red    = '#ff3600',
    violet = '#635196',
    dark_violet = '#020221',
    grey   = '#151521',
}

local bubbles_theme = {
    normal = {
        a = { fg = colors.white, bg = colors.dark_violet },
        b = { fg = colors.white, bg = colors.dark_violet },
        c = { fg = colors.white, bg = colors.grey },
    },

    insert = { a = { fg = colors.black, bg = colors.blue } },
    visual = { a = { fg = colors.black, bg = colors.cyan } },
    replace = { a = { fg = colors.black, bg = colors.red } },

    inactive = {
        a = { fg = colors.white, bg = colors.black },
        b = { fg = colors.white, bg = colors.black },
        c = { fg = colors.white, bg = colors.grey },
    },
}

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
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
            lualine_a = { { 'mode', right_padding = 2 } },
            lualine_b = {
                {
                    'filename' ,
                    cond = conditions.buffer_not_empty,
                    color = { fg = colors.magenta, gui = 'bold' }
                },
                {
                    'filesize',
                    cond = conditions.buffer_not_empty
                },
                {
                    'branch',
                    icon = '',
                    color = { fg = colors.violet, gui = 'bold' },
                },
                {
                    'diagnostics',
                    sources = { 'nvim_diagnostic' },
                    symbols = { error = ' ', warn = ' ', info = ' ' },
                    diagnostics_color = {
                        error = { fg = colors.red },
                        warn = { fg = colors.yellow },
                        info = { fg = colors.cyan },
                    },
                }
        },
            lualine_c = {
                '%=', --[[ add your center compoentnts here in place of this comment ]]
                {
                    -- Lsp server name .
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
                    color = { fg = '#ffffff', gui = 'bold', },
                }
            },
            lualine_x = {},
            lualine_y = {
                {
                    'o:encoding', -- option component same as &encoding in viml
                    fmt = string.upper, -- I'm not sure why it's upper case either ;)
                    cond = conditions.hide_in_width,
                    color = { fg = colors.green, gui = 'bold' },
                },
                {
                    'fileformat',
                    fmt = string.upper,
                    icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
                    color = { fg = colors.green, gui = 'bold' },
                },
                'filetype',
                'progress',
                {
                    'diff',
                    -- Is it me or the symbol for modified us really weird
                    symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
                    diff_color = {
                        added = { fg = colors.green },
                        modified = { fg = colors.orange },
                        removed = { fg = colors.red },
                    },
                    cond = conditions.hide_in_width,
                }
            },
            lualine_z = {
                { 'location', left_padding = 2 },
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
    }
}
