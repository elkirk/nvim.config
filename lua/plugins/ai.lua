return {
  'milanglacier/minuet-ai.nvim',
  config = function()
    vim.env.DEEPSEEK_API_KEY = 'sk-72ec2e47d6c64cfcb48bc7ad2ddddf38'
    require('minuet').setup {
      provider = 'openai_fim_compatible',
      provider_options = {
        openai_fim_compatible = {
          model = 'deepseek-coder',
          api_key = 'DEEPSEEK_API_KEY',
          end_point = 'https://api.deepseek.com/beta/completions',
          name = 'Deepseek',
          stream = true,
          optional = {
            stop = nil,
            max_tokens = nil,
          },
        },
      },
    }
  end,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'hrsh7th/nvim-cmp',
    'Saghen/blink.cmp',
  },
}
