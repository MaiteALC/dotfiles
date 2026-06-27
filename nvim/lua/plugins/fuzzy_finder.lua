local telescope_plugins = {
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-telescope/telescope-ui-select.nvim',
}

if vim.fn.executable 'make' == 1 then table.insert(telescope_plugins, 'htpps://github.com/nvim-telescope/telescope-fzf-native.nvim') end

vim.pack.add(telescope_plugins)

require('telescope').setup {
  extensions = {
    ['ui-select'] = { require('telescope.themes').get_dropdown() },
  },
}

-- Enable Telescope extensions if they are installed
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')

local builtin = require 'telescope.builtin'

vim.keymap.set('n', '<leader>lg', builtin.live_grep, { desc = 'Telescope: [L]ive [G]rep' })

vim.keymap.set('n', '<leader>km', builtin.keymaps, { desc = 'Telescope: Search [K]ey[m]aps' })

vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Telescope: [ ] Find existing buffers' })

vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope: [F]ind [H]elp' })

vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope: [F]ind [F]iles in working directory' })
vim.keymap.set('n', '<leader>fg', builtin.git_files, { desc = 'Telescope: [F]ind [G]it Files' })
vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = 'Telescope: [F]ind Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader>fc', builtin.current_buffer_fuzzy_find, { desc = 'Telescope: [F]ind in [C]urrent buffer' })

vim.keymap.set('n', '<leader>fs', builtin.builtin, { desc = 'Telescope: [F]ind [S]elect Telescope' })
vim.keymap.set({ 'n', 'v' }, '<leader>fw', builtin.grep_string, { desc = 'Telescope: [F]ind current [W]ord' })
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Telescope: [F]ind [D]iagnostics' })
vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = 'Telescope: [F]ind [R]esume' })
vim.keymap.set('n', '<leader>fm', builtin.commands, { desc = 'Telescope: [F]ind Co[m]mands' })

vim.keymap.set('n', '<leader>f/', function()
  local path = vim.fn.input 'Directory: '
  if path == '' then return end

  require('telescope.builtin').find_files {
    cwd = path,
  }
end, { desc = 'Telescope: [F]ind in an arbitrary [/] directory' })

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
  callback = function(event)
    local buf = event.buf

    vim.keymap.set('n', '<leader>gr', builtin.lsp_references, { buffer = buf, desc = 'Telescope: [G]oto [R]eferences' })

    vim.keymap.set('n', '<leader>gi', builtin.lsp_implementations, { buffer = buf, desc = 'Telescope: [G]oto [I]mplementation' })

    -- To jump back, press <C-t>.
    vim.keymap.set('n', '<leader>gdf', builtin.lsp_definitions, { buffer = buf, desc = 'Telescope: [G]oto [D]e[f]inition' })

    -- Fuzzy find all the symbols in your current document.
    -- Symbols are things like variables, functions, types, etc.
    vim.keymap.set('n', '<leader>ds', builtin.lsp_document_symbols, { buffer = buf, desc = 'Telescope: Open [D]ocument [S]ymbols' })

    -- Similar to document symbols, except searches over your entire project.
    vim.keymap.set('n', '<leader>ws', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Telescope: Open [W]orkspace [S]ymbols' })

    vim.keymap.set('n', '<leader>td', builtin.lsp_type_definitions, { buffer = buf, desc = 'Telescope: Goto [T]ype [D]efinition' })
  end,
})

vim.keymap.set(
  'n',
  '<leader>/',
  function()
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end,
  { desc = '[/] Fuzzily search in current buffer' }
)

vim.keymap.set(
  'n',
  '<leader>lo',
  function()
    builtin.live_grep {
      grep_open_files = true,
      prompt_title = 'Live Grep in Open Files',
    }
  end,
  { desc = '[L]ive grep in [O]pen Files' }
)

vim.keymap.set('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config', follow = true } end, { desc = '[S]earch [N]eovim files' })
