require('conform').setup {
  notify_on_error = true,
  format_on_save = function(bufnr)
    -- You can specify filetypes to autoformat on save here:
    local enabled_filetypes = {
      rust = true,
      python = true,
      javascript = true,
      typescript = true,
      c = true,
      sh = true,
      bash = true,
      json = true,
      yaml = true,
      toml = true,
      xml = true,
      sql = true,
    }
    if enabled_filetypes[vim.bo[bufnr].filetype] then
      return { timeout_ms = 500 }
    else
      return nil
    end
  end,
  default_format_opts = {
    lsp_format = 'fallback', -- Use external formatters if configured below, otherwise use LSP formatting. Set to `false` to disable LSP formatting entirely.
  },
  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'ruff_organize_imports', 'ruff_format' },
    javascript = { 'biome' },
    typescript = { 'biome' },
    rust = { 'rustfmt' },
    java = { 'google-java-format' },
    sh = { 'shfmt' },
    bash = { 'shfmt' },
    c = { 'clang-format' },
    json = { 'biome' },
    html = { 'biome' },
    css = { 'biome' },
    yaml = { 'yamlfmt' },
    toml = { 'taplo' },
    xml = { 'xmlformatter' },
    sql = { 'sql-formatter' },
  },
}

vim.keymap.set({ 'n', 'v' }, '<leader>bf', function() require('conform').format { async = true } end, { desc = 'Conform: [B]uffer [f]ormatting' })
