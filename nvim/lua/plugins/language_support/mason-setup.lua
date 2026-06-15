local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add {
  gh 'j-hui/fidget.nvim',
  gh 'neovim/nvim-lspconfig',
  gh 'mason-org/mason.nvim',
  gh 'mason-org/mason-lspconfig.nvim',
  gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
}

require('fidget').setup {}

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--  See `:help lsp-config` for information about keys and how to configure
---@type table<string, vim.lsp.Config>
local servers = {
  clangd = {},
  pyright = {},
  rust_analyzer = {},
  -- ts_ls = {},
  stylua = {}, -- Lua formatter
  jdtls = {},

  -- Special Lua Config, as recommended by neovim help docs
  lua_ls = {
    on_init = function(client)
      client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
      end

      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
          version = 'LuaJIT',
          path = { 'lua/?.lua', 'lua/?/init.lua' },
        },
        workspace = {
          checkThirdParty = false,
          -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
          --  See https://github.com/neovim/nvim-lspconfig/issues/3189
          library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
            '${3rd}/luv/library',
            '${3rd}/busted/library',
          }),
        },
      })
    end,
    ---@type lspconfig.settings.lua_ls
    settings = {
      Lua = {
        format = { enable = false }, -- Disable formatting (formatting is done by stylua)
      },
    },
  },
}

-- To check the current status of installed tools and/or manually install
-- other tools, you can run
--    :Mason
--
-- You can press `g?` for help in this menu.
require('mason').setup {}

local ensure_installed = vim.tbl_keys(servers or {})

vim.list_extend(ensure_installed, {
  -- Java
  'google-java-format', -- Formatter
  'checkstyle', -- Linter

  -- Bash / Shell Script
  'shfmt', -- Formatter
  'shellcheck', -- Linter

  -- Python
  'black', -- Formatter
  'isort', -- Imports formatter
  'flake8', -- Linter

  -- C/C++
  'clang-format', -- Formatter

  -- Web / JavaScript
  'prettierd', -- Formatter
  'eslint_d', -- Linter

  -- Other languages
  'markdownlint', -- Markdown linter
  'jsonlint', -- JSON linter
  'hadolint', -- Dockerfile linter
})

require('mason-tool-installer').setup { ensure_installed = ensure_installed }

for name, server in pairs(servers) do
  vim.lsp.config(name, server)
  vim.lsp.enable(name)
end

-- Specific Rust configuration
vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      imports = {
        granularity = {
          group = 'module',
        },
        prefix = 'self',
      },
      cargo = {
        buildScripts = {
          enable = true,
        },
      },
      procMacro = {
        enable = true,
      },
    },
  },
})
