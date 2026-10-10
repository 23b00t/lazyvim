-- Tools that come from a project's dev shell (nix/direnv, bundler) instead of mason.
-- Not every project ships every binary, so nothing here may warn when one is missing:
-- * LSP servers are only enabled when their binary is on PATH (checked at startup)
--   and are never installed through mason.
-- * mason packages that need a missing toolchain (gem) are dropped from ensure_installed.
-- * every nvim-lint linter only runs when its command is executable.

-- lspconfig server name -> executable
local project_servers = {
  ruby_lsp = "ruby-lsp",
  rubocop = "rubocop",
  solargraph = "solargraph",
  standardrb = "standardrb",
  sorbet = "srb",
}

-- mason package -> toolchain its installer needs
local mason_toolchain = {
  ["erb-formatter"] = "gem",
  ["erb-lint"] = "gem",
}

local function executable(cmd)
  return type(cmd) == "string" and vim.fn.executable(cmd) == 1
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = { servers = { sorbet = {} } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      for server, bin in pairs(project_servers) do
        local sopts = opts.servers[server]
        -- keep servers that are disabled on purpose (e.g. by vim.g.lazyvim_ruby_lsp)
        if sopts ~= nil and sopts ~= false and not (type(sopts) == "table" and sopts.enabled == false) then
          sopts = sopts == true and {} or sopts
          sopts.mason = false
          sopts.enabled = executable(bin)
          opts.servers[server] = sopts
        end
      end
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = vim.tbl_filter(function(pkg)
        local toolchain = mason_toolchain[pkg]
        return not toolchain or executable(toolchain)
      end, opts.ensure_installed or {})
    end,
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    -- NOTE: only sees linters from specs merged before this file (lua/plugins/* load alphabetically)
    opts = function(_, opts)
      opts.linters = opts.linters or {}
      for _, names in pairs(opts.linters_by_ft or {}) do
        for _, name in ipairs(names) do
          local linter = opts.linters[name]
          if linter == nil then
            -- only extend built-in table linters; a function linter would be replaced by the table
            local ok, builtin = pcall(require, "lint.linters." .. name)
            if ok and type(builtin) == "table" then
              linter = {}
              opts.linters[name] = linter
            end
          end
          if type(linter) == "table" and not linter.condition then
            linter.condition = function()
              local cmd = require("lint").linters[name].cmd
              if type(cmd) == "function" then
                cmd = cmd()
              end
              return executable(cmd)
            end
          end
        end
      end
    end,
  },
}
