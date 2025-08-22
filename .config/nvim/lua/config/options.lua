-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.autoformat = false

local function setup_poetry_python()
  local handle = io.popen("poetry env info --path 2>/dev/null")
  if handle then
    local venv_path = handle:read("*a"):gsub("%s+", "")
    handle:close()
    if venv_path ~= "" and vim.fn.filereadable(venv_path .. "/bin/python") == 1 then
      vim.g.python3_host_prog = venv_path .. "/bin/python"
    end
  end
end

setup_poetry_python()
