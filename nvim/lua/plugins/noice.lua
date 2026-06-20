vim.pack.add {
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/folke/noice.nvim',
}

require('noice').setup {
  lsp = {
    override = {
      -- Treesitter-based Markdown rendering
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
    },

    -- Preventing plugin overlaps
    progress = { enable = false }, -- Lualine and Fidget handle the LSP progress
    signature = { enable = false }, -- Blink.cmp handles the signature help window
  },

  presets = {
    bottom_search = false, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },
}
