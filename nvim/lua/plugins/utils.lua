---@return string
local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add {
  gh 'folke/todo-comments.nvim',
  gh 'NMAC427/guess-indent.nvim',
  gh 'lewis6991/gitsigns.nvim',
  gh 'folke/which-key.nvim',
  gh 'windwp/nvim-autopairs',
}

require('todo-comments').setup { signs = false }

require('guess-indent').setup {}

require('which-key').setup {
  delay = 0,
  icons = { mappings = vim.g.have_nerd_font },
  spec = {
    { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } }, -- Enable gitsigns recommended keymaps first
    { '<leader>f', group = '[F]ind' },
    { '<leader>g', group = '[G]oto' },
  },
}
