vim.pack.add {
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/nvim-lualine/lualine.nvim',
}

local custom_theme = require 'lualine.themes.dracula'

local mocha_base = '#1e1e2e'
local mocha_surface = '#1d1d2b'
local light_blue = '#86daeb'

custom_theme.normal.b.bg = mocha_surface
custom_theme.insert.b.bg = mocha_surface
custom_theme.visual.b.bg = mocha_surface
custom_theme.replace.b.bg = mocha_surface
custom_theme.command.b.bg = mocha_surface

-- Changing only the normal mode in section 'C' affects all modes.
custom_theme.normal.c.bg = mocha_base

custom_theme.command.a.bg = light_blue
custom_theme.command.b.fg = light_blue

local function active_lsps()
  local clients = vim.lsp.get_clients { bufnr = 0 }

  if #clients == 0 then return ' No LSP' end

  local names = {}
  for _, client in pairs(clients) do
    table.insert(names, client.name)
  end

  return '  LSP: ' .. table.concat(names, ', ')
end

require('lualine').setup {
  -- Global configurations
  options = {
    icons_enabled = true,
    theme = custom_theme,
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = { 'neo-tree' },
      winbar = { 'neo-tree', 'snacks_terminal' },
    },
    ignore_focus = { 'neo-tree' },
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = true,
  },
  -- Active window configurations
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      {
        'branch',
        icon = { '', align = 'left', color = { fg = '#e1392c' } },
        draw_empty = 'false',
        color = { fg = { custom_theme.normal.c.fg, gui = '' } },
      },
      'diff',
    },
    lualine_c = { 'diagnostics' },
    lualine_x = { 'searchcount' },
    lualine_y = { 'progress', 'location' },
    lualine_z = { active_lsps },
  },
  -- Inactive windows configurations
  inactive_sections = {},

  tabline = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        'buffers',
        show_filename_only = true, -- Shows shortened relative path when set to false.
        hide_filename_extension = false,
        show_modified_status = false,

        mode = 0, -- 0: Shows buffer name
        -- 1: Shows buffer index
        -- 2: Shows buffer name + buffer index
        -- 3: Shows buffer number
        -- 4: Shows buffer name + buffer number
        symbols = {
          directory = ' ',
          alternate_file = '󰩌 ',
        },
      },
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },

  winbar = {
    lualine_a = {},
    lualine_b = {
      {
        'filename',
        file_status = true,
        newfile_status = true,
        symbols = {
          modified = '●',
          readonly = '󰷋',
          unnamed = '[No Name]',
          newfile = '[New]',
        },
        path = 3, -- 0: Just the filename
        -- 1: Relative path
        -- 2: Absolute path
        -- 3: Absolute path, with tilde as the home directory
        -- 4: Filename and parent dir, with tilde as the home directory
      },
    },
    lualine_c = {},
    lualine_x = {
      'fileformat',
      {
        'filetype',
        colored = true,
        icon_only = true,
        padding = { left = 1, right = 0 },
      },
      'encoding',
    },
    lualine_y = { 'filesize' },
    lualine_z = {},
  },

  inactive_winbar = {
    lualine_a = {},
    lualine_b = {
      {
        'filename',
        file_status = true,
        newfile_status = true,
        symbols = {
          modified = '●',
          readonly = '󰷋',
          unnamed = '[No Name]',
          newfile = '[New]',
        },
        path = 3,
      },
    },
    lualine_c = {},
    lualine_x = {
      'fileformat',
      {
        'filetype',
        colored = false,
        icon_only = true,
        padding = { left = 1, right = 0 },
      },
      'encoding',
    },
    lualine_y = { 'filesize' },
    lualine_z = {},
  },

  extensions = {},
}
