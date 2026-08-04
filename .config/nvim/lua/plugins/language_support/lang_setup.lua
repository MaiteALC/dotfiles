local function disable_lsp_formatting(client)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
end

---@type table<string, vim.lsp.Config>
local servers = {
  clangd = {},
  basedpyright = {},

  -- Special Rust config, as recommended by rust_analyzer manual
  rust_analyzer = {
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
  },

  html = {
    on_init = function(client) -- Disabling formatting to delegate it to biome
      disable_lsp_formatting(client)
    end,
  },
  cssls = {
    on_init = function(client) -- Disabling formatting to delegate it to biome
      disable_lsp_formatting(client)
    end,
  },
  emmet_ls = {},
  ts_ls = {
    on_init = function(client) -- Disabling formatting to delegate it to biome
      disable_lsp_formatting(client)
    end,
  },
  jdtls = {},
  yamlls = {},
  jsonls = {
    on_init = function(client) -- Disabling formatting to delegate it to biome
      disable_lsp_formatting(client)
    end,
  },
  taplo = {}, -- TOML formatter, linter and LSP
  bashls = {},
  lemminx = {},
  sqlls = {},
  dockerls = {},

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
  'ruff', -- Formatter and linter

  -- C/C++
  'clang-format', -- Formatter and linter

  -- Web / JS / TS
  'biome', -- Formatter and linter

  'stylua', -- Lua formatter

  -- Other languages
  'markdownlint', -- Markdown linter
  'hadolint', -- Dockerfile linter
  'yamlfmt', -- YAML formatter
  'yamllint', -- YAML linter
  'lemminx', -- XML linter
  'xmlformatter', -- XML formatter
  'sql-formatter', -- SQL formatter
  'sqlfluff', -- SQL linter
})

require('mason-tool-installer').setup { ensure_installed = ensure_installed }

for server_name, user_overrides in pairs(servers) do
  vim.lsp.config(server_name, user_overrides)
  vim.lsp.enable(server_name)
end
