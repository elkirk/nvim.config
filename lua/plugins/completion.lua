return {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  dependencies = 'rafamadriz/friendly-snippets',
  -- Disable for some filetypes
  enabled = function()
    return not vim.tbl_contains({ 'lua', 'markdown' }, vim.bo.filetype)
      and vim.bo.buftype ~= 'prompt'
      and vim.bo.buftype ~= 'nofile'
      and vim.b.completion ~= false
  end,

  -- use a release tag to download pre-built binaries
  version = '*',
  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' for mappings similar to built-in completion
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    -- See the full "keymap" documentation for information on defining your own keymap.
    keymap = {
      preset = 'default',
      -- Manually invoke minuet completion.
      ['<A-y>'] = require('minuet').make_blink_map(),
    },

    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- Will be removed in a future release
      use_nvim_cmp_as_default = true,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
      providers = {
        minuet = {
          name = 'minuet',
          module = 'minuet.blink',
          score_offset = 8,
        },
      },
      cmdline = {},
    },
  },
  -- Recommended to avoid unnecessary request
  completion = { trigger = { prefetch_on_insert = false } },
  opts_extend = { 'sources.default' },
  signature = { window = { border = 'single' }, enabled = true },
  menu = {
    border = 'single',
    auto_show = true,
    draw = {
      columns = {
        { 'label', 'label_description', gap = 1 },
        { 'kind_icon', 'kind' },
      },
    },
  },
  documentation = {
    -- window = { border = 'single' },
    auto_show = true,
    auto_show_delay_ms = 100,
  },
  ghost_text = { enabled = false },
  snippets = {
    -- Function to use when expanding LSP provided snippets
    expand = function(snippet)
      vim.snippet.expand(snippet)
    end,
    -- Function to use when checking if a snippet is active
    active = function(filter)
      return vim.snippet.active(filter)
    end,
    -- Function to use when jumping between tab stops in a snippet, where direction can be negative or positive
    jump = function(direction)
      vim.snippet.jump(direction)
    end,
  },
}
