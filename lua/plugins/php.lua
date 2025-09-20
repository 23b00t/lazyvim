-- lua/plugins/php.lua
-- NOTE: Entry point for lua/plugins/php/*

local function require_php_modules()
  local modules = {}
  local module_names = {
    "conform",
    "nvim-dap",
    "nvim-lint",
    "lsp"
  }
  for _, name in ipairs(module_names) do
    local ok, mod = pcall(require, "plugins.php." .. name)
    if ok then
      table.insert(modules, mod)
    else
      vim.notify("Error loading: " .. name .. "\nCause: " .. tostring(mod), vim.log.levels.ERROR)
    end
  end
  return modules
end

return require_php_modules()
