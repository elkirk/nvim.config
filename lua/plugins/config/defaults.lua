local M = {}

M.tool_installer_setup = function()
  require('mason-tool-installer').setup {
    -- default linters/formatters mason should install
    ensure_installed = {
      'ruff', -- python linter
      'tflint', -- terraform linter
      'jsonlint', -- json linter
      'hadolint', -- dockerfile linter
      'markdownlint', -- markdown linter
      'revive', -- golang linter
      'rust_analyzer',

      'stylua', -- lua formatter
      'blue', -- python formatter
    },
  }
end

return M
