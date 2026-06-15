vim.pack.add { 'https://github.com/stevearc/conform.nvim' }

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
      bash = true
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
    python = { 'isort', 'black' },
    javascript = { 'prettierd', 'prettier', stop_after_first = true },
    typescript = { 'prettierd', 'prettier', stop_after_first = true },
    rust = { 'rustfmt' },
    java = { 'google-java-format' },
    sh = { 'shfmt' },
    bash = { 'shfmt' },
    c = { 'clang-format' }
  },
}

vim.keymap.set({ 'n', 'v' }, '<leader>fb', function() require('conform').format { async = true } end, { desc = 'Conform: [F]ormat [b]uffer' })
