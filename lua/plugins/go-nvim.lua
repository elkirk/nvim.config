return {
  'ray-x/go.nvim',
  dependencies = { -- optional packages
    'ray-x/guihua.lua',
    'neovim/nvim-lspconfig',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('go').setup {
      icons = { breakpoint = '', currentpos = '' },
    }
    vim.opt.tabstop = 2
    vim.opt.shiftwidth = 2
    vim.opt.softtabstop = 2
    vim.opt.expandtab = true

    ---- keymaps ----

    ---- codegen ----
    -- generate comment --
    vim.keymap.set('n', '<leader>gac', '<CMD> GoCmt <CR>', { desc = 'Add comment', silent = true })

    -- generate struct tags
    vim.keymap.set('n', '<leader>gsy', '<CMD> GoAddTag yaml <CR>', { desc = 'Add yaml struct tags', silent = true })
    vim.keymap.set('n', '<leader>gsj', '<CMD> GoAddTag json <CR>', { desc = 'Add json struct tags', silent = true })
    -- vim.keymap.set('n', '<leader>gsr', '<CMD> GoRmTag <CR>', { desc = 'Remove struct tags', silent = true }) -- not working

    -- generate if err
    vim.keymap.set('n', '<leader>gie', '<CMD> GoIfErr <CR>', { desc = 'Add if err block', silent = true })

    -- generate test boilerplate --
    vim.keymap.set('n', '<leader>gat', '<CMD> GoAddTest <CR>', { desc = 'Add test for current function', silent = true })
    vim.keymap.set('n', '<leader>gaT', '<CMD> GoAddAllTest <CR>', { desc = 'Add tests for all functions in current file', silent = true })
    vim.keymap.set('n', '<leader>gae', '<CMD> GoAddExpTest <CR>', { desc = 'Add tests for all exported functions in current file', silent = true })

    -- implement interface on struct under cursor
    vim.keymap.set('n', '<leader>gii', '<CMD> GoImpl <CR>', { desc = 'Implement interface <user_provided> on current struct', silent = true })

    ---- testing ----
    -- Run tests in current package
    vim.keymap.set('n', '<leader>gtp', '<CMD> GoTestPkg -F <CR>', { desc = 'Run tests for current package/folder' })
    -- Run tests in current file
    vim.keymap.set('n', '<leader>gtf', '<CMD> GoTestFile -F <CR>', { desc = 'Run tests for current file' })
    -- Run go test -coverprofile
    vim.keymap.set('n', '<leader>gtc', '<CMD> GoCoverage -F <CR>', { desc = 'Run go test -coverprofile' })
    -- switch between current file and its test file
    -- vim.keymap.set('n', '<leader>Q', '<CMD> GoAlt! <CR>', { desc = 'Switch to test file (create if not exist)' })
    -- vim.keymap.set('n', '<leader>q', '<CMD> GoAlt <CR>', { desc = 'Switch to test file' })

    -- vim.keymap.set('n', '<leader>gdf', '<CMD> GoDebug -t <CR>', { desc = 'Start debug session for this test file' })
    vim.keymap.set('n', '<leader>gdt', '<CMD> GoDebug -n <CR>', { desc = 'Start debug session for nearest test function' })
    -- vim.keymap.set('n', '<leader>gda', ':GoDebug -A ', { desc = 'Debug with args' })

    ---- autocommands ----
    -- nvim-lsp support goimports by default
    -- local go_augroup = vim.api.nvim_create_augroup('go.nvim', { clear = true })
    -- vim.api.nvim_create_autocmd({ 'BufWritePre', 'InsertLeave' }, {
    --   pattern = '*.go',
    --   group = go_augroup,
    --   callback = function()
    --     vim.lsp.buf.formatting_sync(nil, 500)
    --   end,
    -- })

    -- Run gofmt + goimports on save
    -- local format_sync_grp = vim.api.nvim_create_augroup('goimports', {})
    -- vim.api.nvim_create_autocmd('BufWritePre', {
    --   pattern = '*.go',
    --   callback = function()
    --     require('go.format').goimports()
    --   end,
    --   group = format_sync_grp,
    -- })

    -- Use this block instead of the above to only run gofmt, without golines
    -- local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
    -- vim.api.nvim_create_autocmd("BufWritePre", {
    --   pattern = "*.go",
    --   callback = function()
    --    require('go.format').gofmt()
    --   end,
    --   group = format_sync_grp,
    -- })
  end,
  event = { 'CmdlineEnter' },
  ft = { 'go', 'gomod' },
  build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
}
