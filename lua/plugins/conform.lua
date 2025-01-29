return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>ff',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true, json = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        css = { 'prettier' },
        html = { 'prettier' },
        go = {
          'gofmt',
          'goimports',
          'goimports-reviser',
          -- "golines",
        },
        -- Conform will run multiple formatters sequentially
        python = {
          'isort',
          'blue',
        },
        -- You can customize some of the format options for the
        -- filetype (:help conform.format)
        rust = { 'rustfmt', lsp_format = 'fallback' },
        -- markdown = { 'mdformat', lsp_format = 'fallback' },
        -- yaml = { 'prettier', lsp_format = 'fallback' },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
