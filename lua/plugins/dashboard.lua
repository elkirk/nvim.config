return {
  'goolord/alpha-nvim',
  dependencies = { -- need these so we have keymappings at dashboard load
    'ThePrimeagen/harpoon',
    'nvim-telescope/telescope.nvim',
  },
  lazy = false,
  config = function()
    local alpha = require 'alpha'

    local col = function(strlist, opts)
      -- strlist is a TABLE of TABLES, representing columns of text
      -- opts is a text display option

      -- column spacing
      local padding = 12
      -- fill lines up to the maximim length with 'fillchar'
      local fillchar = ' '
      -- columns padding char (for testing)
      local padchar = ' '

      -- define maximum string length in a table
      local maxlen = function(str)
        local max = 0
        for i in pairs(str) do
          if #str[i] > max then
            max = #str[i]
          end
        end
        return max
      end

      -- add as much right-padding to align the text block
      local pad = function(str, max)
        local strlist = {}
        for i in pairs(str) do
          if #str[i] < max then
            local newstr = str[i] .. string.rep(fillchar, max - #str[i])
            table.insert(strlist, newstr)
          else
            table.insert(strlist, str[i])
          end
        end
        return strlist
      end

      -- this is a table for text strings
      local values = {}
      -- process all the lines
      for i = 1, maxlen(strlist) do
        local str = ''
        -- process all the columns but last, because we dont wand extra padding
        -- after last column
        for column = 1, #strlist - 1 do
          local maxstr = maxlen(strlist[column])
          local padded = pad(strlist[column], maxstr)
          if strlist[column][i] == nil then
            str = str .. string.rep(fillchar, maxstr) .. string.rep(padchar, padding)
          else
            str = str .. padded[i] .. string.rep(padchar, padding)
          end
        end

        -- lets process the last column, no extra padding
        do
          local maxstr = maxlen(strlist[#strlist])
          local padded = pad(strlist[#strlist], maxstr)
          if strlist[#strlist][i] == nil then
            str = str .. string.rep(fillchar, maxlen(strlist[#strlist]))
          else
            str = str .. padded[i]
          end
        end

        -- insert result into output table
        table.insert(values, { type = 'text', val = str, opts = opts })
      end

      return values
    end

    local git = {
      '             git                    ',
      ' ',
      '<leader>as         git [s]tage hunk',
      '<leader>ar         git [r]eset hunk',
      '<leader>aS         git [S]tage buffer',
      '<leader>au         git [u]ndo stage hunk',
      '<leader>aR         git [R]eset buffer',
      '<leader>ap         git [p]review hunk',
      '<leader>ab         git [b]lame line',
      '<leader>ad         git [d]iff against index',
      '<leader>aD         git [D]iff against last commit',
      '<leader>asd        git [s]how [d]eleted',
    }

    local search = {
      '               find/search                            ',
      ' ',
      'ff or <leader>sf        fuzzy [f]ind [f]iles in cwd',
      'fg or <leader>sg        fuzzy [f]ind within files in cwd with [g]rep',
      'fp or <leader>sp        fuzzy [f]ind har[p]oon list',
      'fr or <leader>sr        fuzzy [f]ind [r]ecently opened files',
      'fR or <leader>sR        fuzzy [f]ind [R]esume last telescope search',
      'fk or <leader>sk        fuzzy [f]ind [k]eymappings',
      'fn or <leader>sn        fuzzy [f]ind in [n]eovim config files',
      'fh or <leader>sh        fuzzy [f]ind in [h]elp docs',
      'fb or <leader>sv        fuzzy [f]ind telescope [b]uilt-ins',
      'fd or <leader>sd        fuzzy [f]ind document [d]iagnostics',
      'fc or <leader>sc        fuzzy [f]ind git commits',
      'fs or <leader>ss        fuzzy [f]ind git status',
    }

    local terminal = {
      '               terminal                        ',
      ' ',
      '<ALT>h         toggle terminal [h]orizontally',
      '<ALT>v         toggle terminal [v]ertically',
      '<ALT>.         toggle floating terminal',
      ' ',
      ' ',
      ' ',
      ' ',
      '               file system                     ',
      ' ',
      '<CTRL>n        open mini-files window',
    }

    local harpoon = {
      '             harpoon                            ',
      ' ',
      '<leader>a         [a]dd file to harpoon list',
      '<leader>l         show harpoon [l]ist',
      '<leader>1-5       jump to harpoon [1-5]',
    }

    local debugging = {
      '      debugging                            ',
      ' ',
      '<F5>         start or continue debugging',
      '<F1>         step into',
      '<F2>         step over',
      '<F3>         step out',
      '<F11>        terminate session',
    }

    local splits = {
      '          splits                            ',
      ' ',
      '<leader>v       split right (vertical)',
      '<leader>h       split down (horizontal)',
      ':q or :wq       close active split',
      '<CTRL>hjkl      navigate between splits',
    }

    local tabs = {
      '        tabs                            ',
      ' ',
      '<TAB>n       Open new tab',
      '<TAB>l       Cycle next tab',
      '<TAB>h       Cycle prev tab',
      '<TAB>x       Close current tab',
    }

    local leader = {
      '<leader> key is mapped to <space>',
    }

    local buffers = {
      'f󱁐  or <leader><space> to fuzzy find open buffers',
    }

    local head = {
      type = 'text',
      val = {
        [[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ]],
        [[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ]],
        [[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ]],
        [[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ]],
        [[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ]],
        [[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ]],
      },
      opts = {
        position = 'center',
        hl = 'Type',
      },
    }

    local foot = {
      type = 'text',
      val = {
        [[ l.kuykendall@fetchrewards.com ]],
      },
      opts = {
        position = 'center',
        hl = 'Number',
      },
    }

    local block1 = {
      type = 'group',
      val = col({ git, search, terminal }, {
        position = 'center',
        hl = {
          { 'Title', 0, -1 },
          { 'Comment', 0, -1 },
          { 'Title', 0, -1 },
        },
      }),
      opts = {
        spacing = 0,
      },
    }

    local block2 = {
      type = 'group',
      val = col({ debugging, tabs, splits, harpoon }, {
        position = 'center',
        hl = {
          { 'Title', 0, -1 },
          { 'Comment', 0, -1 },
          { 'Title', 0, -1 },
        },
      }),
      opts = {
        spacing = 0,
      },
    }

    local block3 = {
      type = 'group',
      val = col({ leader, buffers }, {
        position = 'center',
        hl = {
          { 'Comment', 0, -1 },
          { 'Title', 0, -1 },
          { 'Title', 152, 159 },
          { 'Title', 198, 209 },
        },
      }),
      opts = {
        spacing = 0,
      },
    }

    local opts = {
      layout = {
        { type = 'padding', val = 2 },
        head,
        { type = 'padding', val = 2 },
        block1,
        { type = 'padding', val = 8 },
        block2,
        { type = 'padding', val = 8 },
        block3,
        { type = 'padding', val = 3 },
        foot,
      },
      opts = {
        noautocmd = true,
        margin = 5,
      },
    }

    alpha.setup(opts)
  end,
}
