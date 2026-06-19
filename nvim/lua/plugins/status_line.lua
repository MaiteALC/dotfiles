vim.pack.add {
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/nvim-lualine/lualine.nvim',
}

local custom_theme = require 'lualine.themes.dracula'

local mocha_base = '#1e1e2e'
local mocha_surface = '#1d1d2b'

custom_theme.normal.b.bg = mocha_surface
custom_theme.insert.b.bg = mocha_surface
custom_theme.visual.b.bg = mocha_surface
custom_theme.replace.b.bg = mocha_surface
custom_theme.command.b.bg = mocha_surface

-- Changing only the normal mode in section 'C' affects all modes.
custom_theme.normal.c.bg = mocha_base

require('lualine').setup {
  -- Global configurations
  options = {
    icons_enabled = true,
    theme = custom_theme,
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = { 'neo-tree' },
    always_divide_middle = true,
    always_show_tabline = false,
    globalstatus = false,
  },
  -- Active window configurations
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      'diagnostics',
      { 'branch', icon = { '', align = 'left' }, draw_empty = 'false' },
      'diff',
    },
    lualine_c = {
      {
        'buffers',
        show_filename_only = true, -- Shows shortened relative path when set to false.
        hide_filename_extension = false,
        show_modified_status = true,

        mode = 0, -- 0: Shows buffer name
        -- 1: Shows buffer index
        -- 2: Shows buffer name + buffer index
        -- 3: Shows buffer number
        -- 4: Shows buffer name + buffer number
        symbols = {
          modified = ' ●',
          directory = '',
          alternate_file = '󰩌',
        },
      },
    },
    lualine_x = {
      'encoding',
      'fileformat',
      'filesize',
      { 'filetype', colored = true, icon_only = true },
    },
    lualine_y = { 'searchcount', 'location' },
    lualine_z = {
      {
        'lsp_status',
        icon = ' LSP:',
        symbols = {
          spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
          done = '✓',
          separator = ' ',
        },
        ignore_lsp = {},
        show_name = true,
      },
    },
  },
  -- Inactive windows configurations
  inactive_sections = {
    lualine_a = {
      {
        'filename',
        file_status = true,
        newfile_status = true,
        symbols = {
          modified = ' ●',
          readonly = '󰷋',
          unnamed = '[No Name]',
          newfile = '[New]',
        },
      },
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = { { 'filetype', colored = false, icon_only = true } },
    lualine_z = { 'location' },
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {},
}
