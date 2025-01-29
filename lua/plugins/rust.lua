return {
  {
    'simrat39/rust-tools.nvim',
    ft = 'rust',
    config = function()
      require('rust-tools').setup {
        -- advanced configuration: https://github.com/simrat39/rust-tools.nvim?tab=readme-ov-file#configuration
        server = {
          on_attach = function(_, bufnr)
            local rt = require 'rust-tools'
            -- Hover actions
            vim.keymap.set('n', '<C-space>', rt.hover_actions.hover_actions, { buffer = bufnr })
            -- Code action groups
            vim.keymap.set('n', '<leader>a', rt.code_action_group.code_action_group, { buffer = bufnr })
          end,
        },
      }
    end,
  },
  {
    'rust-lang/rust.vim',
    ft = 'rust',
    init = function()
      vim.g.rustfmt_autosave = 1 -- run rust formatter on save
    end,
  },
}
