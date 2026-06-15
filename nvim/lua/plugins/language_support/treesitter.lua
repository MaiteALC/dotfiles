-- NOTE: You can also specify a branch or a specific commit
vim.pack.add { { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' } }

local parsers = {
  'bash',
  'c',
  'diff',
  'html',
  'css',
  'javascript',
  'java',
  'javadoc',
  'python',
  'lua',
  'luadoc',
  'json',
  'yaml',
  'toml',
  'xml',
  'sql',
  'http',
  'markdown',
  'markdown_inline',
  'query',
  'vim',
  'vimdoc',
}

local treesitter = require 'nvim-treesitter'
treesitter.install(parsers)

---@param buf integer
---@param language string
local function treesitter_try_attach(buf, language)
  -- Check if a parser exists, and if so load and enable it
  if not vim.treesitter.language.add(language) then return end
  vim.treesitter.start(buf, language)

  -- Check if treesitter based folds are available for this language, and if so enable it
  local has_fold_query = vim.treesitter.query.get(language, 'folds') ~= nil

  if has_fold_query then
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  end

  -- Check if treesitter indentation is available for this language, and if so enable it
  local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

  if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
end

local available_parsers = treesitter.get_available()

vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local buf, filetype = args.buf, args.match

    local language = vim.treesitter.language.get_lang(filetype)
    if not language then return end

    local installed_parsers = treesitter.get_installed 'parsers'

    if vim.tbl_contains(installed_parsers, language) then
      treesitter_try_attach(buf, language)
    elseif vim.tbl_contains(available_parsers, language) then
      -- If a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
      treesitter.install(language):await(function() treesitter_try_attach(buf, language) end)
    else
      -- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
      treesitter_try_attach(buf, language)
    end
  end,
})
