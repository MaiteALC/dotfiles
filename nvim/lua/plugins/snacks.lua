require('snacks').setup {
  rename = { enabled = true },

  notifier = { enabled = true },

  scope = {
    enabled = true,
    min_size = 1,
    keys = {
      text_object = {
        ii = false,
        ai = false,

        ['is'] = {
          min_size = 1,
          edge = false,
          cursor = false,
          treesitter = { blocks = { enabled = false } },
          desc = '[I]nner [s]cope (scope without the edges)',
        },

        ['as'] = {
          min_size = 1,
          edge = false,
          cursor = false,
          treesitter = { blocks = { enabled = false } },
          desc = '[A]round [s]cope (scope with the edges)',
        },
      },
    },
  },

  indent = {
    enabled = true,
    only_current = true,
    scope = { only_current = true },
  },

  terminal = { enabled = true },
}

vim.keymap.set('n', '<leader>tt', function() Snacks.terminal.toggle() end, { desc = '[T]oggle snacks.nvim [t]erminal', silent = true })
