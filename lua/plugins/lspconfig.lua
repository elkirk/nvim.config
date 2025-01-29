return {
  -- Main LSP Configuration
  'neovim/nvim-lspconfig',
  dependencies = {
    -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
    { 'williamboman/mason.nvim', opts = {} },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Useful status updates for LSP.
    { 'j-hui/fidget.nvim', opts = {} },

    -- Allows extra capabilities provided by nvim-cmp
    'hrsh7th/cmp-nvim-lsp',
    {
      'hrsh7th/nvim-cmp',
      event = 'InsertEnter',
      dependencies = {
        {
          'windwp/nvim-autopairs',
          opts = {
            fast_wrap = {},
            disable_filetype = { 'TelescopePrompt', 'vim' },
          },
          config = function(_, opts)
            require('nvim-autopairs').setup(opts)

            -- setup cmp for autopairs
            local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
            require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())
          end,
        },
      },
    },
    {
      'L3MON4D3/LuaSnip',
      version = 'v2.*',
      build = 'make install_jsregexp',
      dependencies = { 'rafamadriz/friendly-snippets' },
      config = function()
        require('luasnip.loaders.from_vscode').lazy_load()
      end,
    },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-cmdline' },
    { 'saadparwaiz1/cmp_luasnip' },
  },
  config = function()
    -- Change diagnostic symbols in the sign column (gutter)
    if vim.g.have_nerd_font then
      local signs = { ERROR = '', WARN = '', INFO = '', HINT = '' }
      local diagnostic_signs = {}
      for type, icon in pairs(signs) do
        diagnostic_signs[vim.diagnostic.severity[type]] = icon
      end
      vim.diagnostic.config { signs = { text = diagnostic_signs } }
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
    capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())
    -- servers in this list will be auto-installed by mason
    -- https://github.com/williamboman/mason-lspconfig.nvim?tab=readme-ov-file#available-lsp-servers
    local servers = {
      gopls = {
        settings = {
          gopls = {
            experimentalPostfixCompletions = true,
            analyses = {
              unusedparams = true,
              shadow = true,
            },
            staticcheck = true,
          },
        },
        init_options = {
          usePlaceholders = true,
        },
      },
      yamlls = {
        capabilities = {
          textDocument = {
            foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true,
            },
          },
        },
      },
      pyright = {},
      rust_analyzer = {},
      lua_ls = {
        -- filetypes = { ... },
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using
              -- (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
            },
            completion = {
              callSnippet = 'Replace',
            },
            diagnostics = {
              disable = { 'missing-fields' },
              globals = {
                'vim',
                'require',
              },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file('', true),
            },
            telemetry = {
              enable = false,
            },
          },
        },
      },
    }

    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua', -- Used to format Lua code
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          -- This handles overriding only values explicitly passed
          -- by the server configuration above. Useful when disabling
          -- certain features of an LSP (for example, turning off formatting for ts_ls)
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }
    -- local function cmp_border(hl_name)
    --   return {
    --     { '╭', hl_name },
    --     { '─', hl_name },
    --     { '╮', hl_name },
    --     { '│', hl_name },
    --     { '╯', hl_name },
    --     { '─', hl_name },
    --     { '╰', hl_name },
    --     { '│', hl_name },
    --   }
    -- end
    --
    -- local cmp = require 'cmp'
    -- local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
    -- cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    --
    -- cmp.setup {
    --   sources = {
    --     { name = 'nvim_lsp' },
    --     { name = 'vim-dadbod-completion' },
    --     { name = 'luasnip' },
    --     { name = 'codeium' },
    --     { name = 'buffer' },
    --     { name = 'path' },
    --   },
    --   snippet = {
    --     expand = function(args)
    --       vim.snippet.expand(args.body)
    --     end,
    --   },
    --   window = {
    --     completion = {
    --       border = cmp_border 'CmpDocBorder',
    --       max_width = 40,
    --     },
    --     documentation = {
    --       border = cmp_border 'CmpDocBorder',
    --       max_width = 50,
    --     },
    --   },
    --   mapping = cmp.mapping.preset.insert {
    --     -- Select the [n]ext item
    --     ['<C-n>'] = cmp.mapping.select_next_item(),
    --     -- Select the [p]revious item
    --     ['<C-p>'] = cmp.mapping.select_prev_item(),
    --
    --     -- Scroll the documentation window [b]ack / [f]orward
    --     ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    --     ['<C-f>'] = cmp.mapping.scroll_docs(4),
    --
    --     -- Accept ([y]es) the completion.
    --     --  This will auto-import if your LSP supports it.
    --     --  This will expand snippets if the LSP sent a snippet.
    --     ['<C-y>'] = cmp.mapping.confirm { select = true },
    --
    --     -- If you prefer more traditional completion keymaps,
    --     -- you can uncomment the following lines
    --     ['<CR>'] = cmp.mapping.confirm { select = true },
    --     -- ['<Tab>'] = cmp.mapping.select_next_item(),
    --     -- ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    --     ['<Tab>'] = cmp.mapping(function(fallback)
    --       if cmp.visible() then
    --         cmp.select_next_item()
    --       elseif require('luasnip').expand_or_jumpable() then
    --         vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
    --       else
    --         fallback()
    --       end
    --     end, {
    --       'i',
    --       's',
    --     }),
    --     ['<S-Tab>'] = cmp.mapping(function(fallback)
    --       if cmp.visible() then
    --         cmp.select_prev_item()
    --       elseif require('luasnip').jumpable(-1) then
    --         vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
    --       else
    --         fallback()
    --       end
    --     end, {
    --       'i',
    --       's',
    --     }),
    --   },
    -- }
    --
    -- -- Floating border on hover window
    -- vim.cmd [[autocmd! ColorScheme * highlight NormalFloat guibg=#1f2335]]
    -- vim.cmd [[autocmd! ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]]
    -- local float_border = {
    --   { '🭽', 'FloatBorder' },
    --   { '▔', 'FloatBorder' },
    --   { '🭾', 'FloatBorder' },
    --   { '▕', 'FloatBorder' },
    --   { '🭿', 'FloatBorder' },
    --   { '▁', 'FloatBorder' },
    --   { '🭼', 'FloatBorder' },
    --   { '▏', 'FloatBorder' },
    -- }
    -- -- have to override the defaults for open_floating_preview
    -- local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    -- function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    --   opts = opts or {}
    --   opts.border = opts.border or float_border
    --   opts.max_width = opts.max_width or 60
    --   opts.max_height = opts.max_height or 100
    --   return orig_util_open_floating_preview(contents, syntax, opts, ...)
    -- end
  end,
}
