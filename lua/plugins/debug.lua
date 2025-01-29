return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    'nvim-neotest/nvim-nio',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',
  },
  config = function()
    require('dapui').setup()
    -- require('nvim-dap-virtual-text').setup {
    --   commented = true,
    -- }
    local dap, dapui = require 'dap', require 'dapui'

    local function get_arguments()
      return coroutine.create(function(dap_run_co)
        local args = {}
        vim.ui.input({ prompt = 'Args: ' }, function(input)
          args = vim.split(input or '', ' ')
          coroutine.resume(dap_run_co, args)
        end)
      end)
    end

    dap.adapters.go = {
      type = 'server',
      port = '${port}',
      executable = {
        command = 'dlv',
        args = { 'dap', '-l', '127.0.0.1:${port}' },
        -- add this if on windows, otherwise server won't open successfully
        -- detached = false
      },
    }
    dap.configurations.go = {
      {
        type = 'go',
        name = 'Debug',
        request = 'launch',
        program = '${file}',
        outputMode = 'remote',
      },
      {
        type = 'go',
        name = 'Debug (Arguments)',
        request = 'launch',
        program = './${relativeFileDirname}',
        args = require('dap-go').get_arguments,
        outputMode = 'remote',
      },
      {
        type = 'go',
        name = 'Debug test',
        request = 'launch',
        mode = 'test',
        program = './${relativeFileDirname}',
        outputMode = 'remote',
      },
    }

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint)
    vim.keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end)
    vim.keymap.set('n', '<F5>', dap.continue)
    vim.keymap.set('n', '<F1>', dap.step_into)
    vim.keymap.set('n', '<F2>', dap.step_over)
    vim.keymap.set('n', '<F3>', dap.step_out)
    vim.keymap.set('n', '<F11>', dap.terminate)

    vim.keymap.set('n', '<leader>?', function()
      dapui.eval(nil, { enter = true, width = 120, height = 50 })
    end)

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F7>', dapui.toggle)
  end,
}
