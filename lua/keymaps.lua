-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
--  Keymaps that rely on third-party plugins are defined in that plugin's file

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.open_float, { desc = 'Open diagnostic in floating window' })

-- Window splits
vim.keymap.set('n', '<leader>h', ':split<CR>', { desc = 'Split down' })
vim.keymap.set('n', '<leader>v', ':vsplit<CR>', { desc = 'Split right' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Buffers
vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<cmd> w <cr>', { desc = 'Save buffer' })
vim.keymap.set({ 'n', 'v' }, '<leader>x', '<cmd> bd <cr>', { desc = 'Close buffer' })
vim.keymap.set({ 'n' }, '<leader>e', ':enew <CR>', { desc = 'New buffer' })

-- format with jq
vim.keymap.set('n', '<leader>fj', '<cmd>%!jq .<CR>', { desc = 'Format JSON with jq' })
vim.keymap.set('n', '<leader>fJ', '<cmd>%!jq -c .<CR>', { desc = 'Flatten JSON with jq' })

-- Tabs
vim.keymap.set('n', '<TAB>n', '<CMD> tabnew <CR>', { desc = 'Open new tab' })
vim.keymap.set('n', '<TAB>l', '<CMD> tabnext <CR>', { desc = 'Next tab' })
vim.keymap.set('n', '<TAB>h', '<CMD> tabprevious <CR>', { desc = 'Previous tab' })
vim.keymap.set('n', '<TAB>x', '<CMD> tabclose <CR>', { desc = 'Close tab' })

-- Move highlighted text
local opts = { noremap = true, silent = true }
vim.keymap.set('v', '<A-j>', ':m .+1<CR>==', opts)
vim.keymap.set('v', '<A-k>', ':m .-2<CR>==', opts)
vim.keymap.set('v', 'p', '"_dP', opts)
vim.keymap.set('x', 'J', ":move '>+1<CR>gv-gv", opts)
vim.keymap.set('x', 'K', ":move '<-2<CR>gv-gv", opts)
vim.keymap.set('x', '<A-j>', ":move '>+1<CR>gv-gv", opts)
vim.keymap.set('x', '<A-k>', ":move '<-2<CR>gv-gv", opts)

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- vim: ts=2 sts=2 sw=2 et
