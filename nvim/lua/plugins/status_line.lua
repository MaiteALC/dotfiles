vim.pack.add {
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/nvim-lualine/lualine.nvim',
}

require('lualine').setup {
  -- Global configurations
  options = {
    icons_enabled = true,
    theme = 'dracula',
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
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
      refresh_time = 16, -- ~60fps
      events = {
        'WinEnter',
        'BufEnter',
        'BufWritePost',
        'SessionLoadPost',
        'FileChangedShellPost',
        'VimResized',
        'Filetype',
        'CursorMoved',
        'CursorMovedI',
        'ModeChanged',
      },
    },
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
    lualine_x = { 'encoding', 'fileformat', 'filesize', 'filetype' },
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
    lualine_a = { 'filename' },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = { 'filetype' },
    lualine_z = { 'location' },
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {},
}
