-- Here is a more advanced example where we pass configuration
-- options to `gitsigns.nvim`. This is equivalent to the following Lua:
--    require('gitsigns').setup({ ... })
--
-- See `:help gitsigns` to understand what the configuration keys do
return {
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- Actions
        -- visual mode
        map('v', '<leader>as', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'stage git hunk' })
        map('v', '<leader>ar', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'reset git hunk' })
        -- normal mode
        map('n', '<leader>as', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        map('n', '<leader>ar', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        map('n', '<leader>aS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        map('n', '<leader>au', gitsigns.undo_stage_hunk, { desc = 'git [u]ndo stage hunk' })
        map('n', '<leader>aR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        map('n', '<leader>ap', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
        map('n', '<leader>ab', gitsigns.blame_line, { desc = 'git [b]lame line' })
        map('n', '<leader>ad', gitsigns.diffthis, { desc = 'git [d]iff against index' })
        map('n', '<leader>aD', function()
          gitsigns.diffthis '@'
        end, { desc = 'git [D]iff against last commit' })
        -- Toggles
        map('n', '<leader>aB', gitsigns.toggle_current_line_blame, { desc = 'git [b]lame line' })
        map('n', '<leader>asd', gitsigns.toggle_deleted, { desc = 'git show [D]eleted' })
      end,
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
