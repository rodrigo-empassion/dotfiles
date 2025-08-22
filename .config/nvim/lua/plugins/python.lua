return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          before_init = function(_, config)
            local venv = vim.fn.trim(vim.fn.system("poetry env info --path"))
            if vim.v.shell_error == 0 and venv ~= "" then
              config.settings.python = config.settings.python or {}
              config.settings.python.pythonPath = venv .. "/bin/python"
            end
          end,
          root_dir = require("lspconfig/util").root_pattern("pyproject.toml", ".git"),
        },
      },
    },
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      local venv = vim.fn.trim(vim.fn.system("poetry env info --path"))
      local python_path
      if vim.v.shell_error == 0 and venv ~= "" then
        python_path = venv .. "/bin/python"
      else
        python_path = vim.g.python3_host_prog or "python"
      end
      require("dap-python").setup(python_path)
      table.insert(require("dap").configurations.python, {
        type = "python",
        request = "launch",
        name = "Launch with Poetry",
        program = "${file}",
        python = python_path,
        console = "integratedTerminal",
        cwd = "${workspaceFolder}",
      })
    end,
  },
}
