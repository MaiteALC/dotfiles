vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

vim.keymap.set('n', '\\', '<Cmd>Neotree reveal<CR>', { desc = 'NeoTree reveal', silent = true })

local function on_rename(data) Snacks.rename.on_rename_file(data.source, data.destination) end

local events = require 'neo-tree.events'

require('neo-tree').setup {
  event_handlers = {
    { event = events.FILE_RENAMED, handler = on_rename },
    { event = events.FILE_MOVED, handler = on_rename },
  },

  filesystem = {
    use_libuv_file_watcher = true,
    window = {
      mappings = {
        ['\\'] = 'close_window',
      },
    },
  },
}
