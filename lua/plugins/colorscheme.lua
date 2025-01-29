return {
  'lcroberts/persistent-colorscheme.nvim',
  lazy = false,
  priority = 1000,
  dependencies = {
    -- 'RRethy/nvim-base16', -- Lots of baked-in themes and support to add more
    'notken12/base46-colors',
    {
      'folke/tokyonight.nvim',
      opts = {
        style = 'night',
      },
    },
  },
  opts = {},
}
