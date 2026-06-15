vim.pack.add { 'https://github.com/binhtran432k/dracula.nvim' }

local use_transparency = true
local siderbar_style = 'dark'
local float_Style = 'dark'

if use_transparency then
  siderbar_style = 'transparent'
  float_Style = 'transparent'
end

require('dracula').setup {
  style = 'default', -- The theme comes in three styles, `default`, a darker variant `soft` and `day`
  light_style = 'day',
  transparent = use_transparency,
  terminal_colors = true,
  styles = {
    comments = { italic = true },
    keywords = { italic = true },
    functions = {},
    variables = {},
    -- Background styles. Can be "dark", "transparent" or "normal"
    sidebars = siderbar_style,
    floats = float_Style,
  },
  on_colors = function(colors)
    colors.hint = colors.bright_cyan
    colors.todo = colors.bright_green
    colors.warning = colors.orange
    colors.line = colors.none
  end,

  dim_inactive = false,
  cache = true,
}

vim.cmd.colorscheme 'dracula'
