local function run_build(name, cmd, cwd)
  local result = vim.system(cmd, { cwd = cwd }):wait()
  if result.code ~= 0 then
    local stderr = result.stderr or ''
    local stdout = result.stdout or ''
    local output = stderr ~= '' and stderr or stdout
    if output == '' then output = 'No output from build command.' end
    vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
  end
end

-- This autocommand runs after a plugin is installed or updated and
--  runs the appropriate build command for that plugin if necessary.
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if kind ~= 'install' and kind ~= 'update' then return end

    if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
      run_build(name, { 'make' }, ev.data.path)
      return
    end

    if name == 'LuaSnip' then
      if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then run_build(name, { 'make', 'install_jsregexp' }, ev.data.path) end
      return
    end

    if name == 'nvim-treesitter' then
      if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
      vim.cmd 'TSUpdate'
      return
    end
  end,
})

-- User commands to easily add/remove/update packages with vim.pack
vim.api.nvim_create_user_command('PackAdd', function(opts) vim.pack.add(opts.fargs) end, { nargs = '+', desc = 'Add plugins (:PackAdd user/repo1 user/repo2)' })

vim.api.nvim_create_user_command('PackDel', function(opts) vim.pack.del(opts.fargs) end, { nargs = '+', desc = 'Delete plugins (:PackDel plugin1 plugin2)' })

vim.api.nvim_create_user_command('PackUpdate', function(opts)
  if opts == nil or opts.args == nil or not opts.args:match '%w' then
    vim.pack.update()
  else
    local plugins = vim.split(opts.args, '%s', { trimempty = true })
    vim.pack.update(plugins)
  end
end, { nargs = '*', desc = 'Update all plugins or specific ones' })

local function gh(repo) return 'https://github.com/' .. repo end

local plugins_to_install = {
  -- Dependencies
  -- NOTE: The plugins in this section are common dependencies for
  -- another plugins, that's why they are dowloaded first.
  gh 'nvim-lua/plenary.nvim',
  gh 'MunifTanjim/nui.nvim',
  gh 'nvim-tree/nvim-web-devicons',

  -- Autocomplete
  { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' },
  { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' },
  gh 'rafamadriz/friendly-snippets',

  -- Debugging
  gh 'mfussenegger/nvim-dap',
  gh 'rcarriga/nvim-dap-ui',
  gh 'nvim-neotest/nvim-nio',
  gh 'jay-babu/mason-nvim-dap.nvim',

  -- Formatting
  gh 'stevearc/conform.nvim',

  -- Language support set up
  gh 'neovim/nvim-lspconfig',
  gh 'mason-org/mason.nvim',
  gh 'mason-org/mason-lspconfig.nvim',
  gh 'WhoIsSethDaniel/mason-tool-installer.nvim',

  -- Lintting
  gh 'mfussenegger/nvim-lint',

  -- Tree-sitter
  { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' },

  -- File explorer
  gh 'nvim-neo-tree/neo-tree.nvim',

  -- Fuzzy finder (Telescope)
  gh 'nvim-telescope/telescope.nvim',
  gh 'nvim-telescope/telescope-ui-select.nvim',

  -- Mini.nvim
  gh 'nvim-mini/mini.nvim',

  -- Noice
  gh 'folke/noice.nvim',

  -- Snacks.nvim
  gh 'folke/snacks.nvim',

  -- Status line
  gh 'nvim-lualine/lualine.nvim',

  -- Git integration
  gh 'lewis6991/gitsigns.nvim',

  -- Utility plugins
  gh 'folke/todo-comments.nvim',
  gh 'NMAC427/guess-indent.nvim',
  gh 'folke/which-key.nvim',

  -- Theme
  gh 'binhtran432k/dracula.nvim',
}

if vim.fn.executable 'make' == 1 then table.insert(plugins_to_install, gh 'nvim-telescope/telescope-fzf-native.nvim') end

vim.pack.add(plugins_to_install)
