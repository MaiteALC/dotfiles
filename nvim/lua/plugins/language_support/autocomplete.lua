require('luasnip').setup {}
require('luasnip.loaders.from_vscode').lazy_load()

require('blink.cmp').setup {
  keymap = {
    -- <c-y> to accept ([y]es) the completion.
    --  This will auto-import if your LSP supports it.
    --  This will expand snippets if the LSP sent a snippet.
    --
    -- All presets have the following mappings:
    --  <tab>/<s-tab>: move to right/left of your snippet expansion
    --  <c-space>: Open menu or open docs if already open
    --  <c-n>/<c-p> or <up>/<down>: Select next/previous item
    --  <c-e>: Hide menu
    --  <c-k>: Toggle signature help
    preset = 'default',
  },

  appearance = {
    nerd_font_variant = 'mono',
  },

  completion = {
    menu = {
      border = 'rounded',
      auto_show = true,
      auto_show_delay_ms = 250, -- add small delay to prevent lag
    },

    documentation = {
      window = { border = 'rounded' },
      auto_show = true,
      -- Add small delays to prevent documentation window flickering
      auto_show_delay_ms = 270,
      update_delay_ms = 120,
    },

    ghost_text = {
      enabled = false,
    },
  },

  sources = {
    default = { 'lsp', 'path', 'snippets' },
  },

  snippets = { preset = 'luasnip' },

  fuzzy = { implementation = 'prefer_rust_with_warning' },

  -- Shows a signature help window while you type arguments for a function
  signature = {
    enabled = true,
    window = { border = 'rounded' },
  },
}
