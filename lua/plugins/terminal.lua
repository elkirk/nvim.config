return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    vim.keymap.set({ 'n', 't' }, '<A-v>', '<CMD> ToggleTerm direction=vertical <CR>', { desc = 'Toggle vertical terminal' })
    vim.keymap.set({ 'n', 't' }, '<A-h>', '<CMD> ToggleTerm direction=horizontal <CR>', { desc = 'Toggle horizontal terminal' })
    vim.keymap.set({ 'n', 't' }, '<A-.>', '<CMD> ToggleTerm direction=float <CR>', { desc = 'Toggle floating terminal' })
    -- navigate in/out of terminal while keeping it open
    function _G.set_terminal_keymaps()
      local opts = { buffer = 0 }
      vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
      vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
    end
    vim.cmd 'autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()'
    require('toggleterm').setup {
      size = function(term)
        if term.direction == 'horizontal' then
          return 30
        elseif term.direction == 'vertical' then
          return vim.o.columns * 0.5
        end
      end,
    }
  end,
}
