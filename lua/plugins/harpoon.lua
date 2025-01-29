return {
  'ThePrimeagen/harpoon',
  dependencies = { 'nvim-telescope/telescope.nvim' },
  branch = 'harpoon2',
  config = function()
    local harpoon = require 'harpoon'
    harpoon:setup()

    vim.keymap.set('n', '<leader>a', function()
      harpoon:list():add()
    end, { desc = 'Add file to harpoon list' })
    vim.keymap.set('n', '<leader>l', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'Display harpoon list' })

    -- Set <space>1..<space>0 be my shortcuts to moving to the files
    for _, idx in ipairs { 1, 2, 3, 4, 5 } do
      vim.keymap.set('n', string.format('<space>%d', idx), function()
        harpoon:list():select(idx)
      end, { desc = 'Harpoon ' .. idx })
    end

    -- basic telescope configuration
    local conf = require('telescope.config').values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require('telescope.pickers')
        .new({}, {
          prompt_title = 'Harpoon',
          finder = require('telescope.finders').new_table {
            results = file_paths,
          },
          previewer = conf.file_previewer {},
          sorter = conf.generic_sorter {},
        })
        :find()
    end

    vim.keymap.set('n', '<leader>p', function()
      toggle_telescope(harpoon:list())
    end, { desc = 'Telescope Harpoon' })
    vim.keymap.set('n', 'fp', function()
      toggle_telescope(harpoon:list())
    end, { desc = '[F]ind in Har[p]oon' })
  end,
}
