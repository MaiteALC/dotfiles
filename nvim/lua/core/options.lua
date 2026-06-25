vim.loader.enable()

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Tab configuration
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Enable undo/redo changes even after closing and reopening a file
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.undofile = true

vim.opt.isfname:append("@-@")

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Make line numbers default
vim.opt.nu = true
vim.o.relativenumber = false

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

vim.o.breakindent = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 150

vim.o.timeoutlen = 500

vim.o.splitright = true
vim.o.splitbelow = true

-- Set visible characters to be displayed when there are invisible characters
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

vim.o.cursorline = true

vim.o.scrolloff = 10

vim.o.confirm = true

vim.opt.termguicolors = true

vim.diagnostic.config {
  signs = false,
  update_in_insert = true,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  virtual_text = true,
  virtual_lines = false,

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float {
        bufnr = bufnr,
        scope = 'cursor',
        focus = false,
      }
    end,
  },
}

vim.opt.cmdheight = 0

vim.opt.laststatus = 3 -- 0: Never show the status line
-- 1: Show the status line if there are at least two splits
-- 2: Always show one status line per split
-- 3: Always show one global status line at the bottom of the screen
