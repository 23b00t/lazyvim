return {
  -- LSP server installer
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    opts = {},
  },

  -- bridge mason <-> lspconfig
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = { "tsserver" },
      automatic_installation = true,
    },
  },

  -- actual LSP client config
  {
    "neovim/nvim-lspconfig",
    dependencies = { "mason-org/mason-lspconfig.nvim" },
    config = function()
      local lspconfig = require("lspconfig")

      -- tsserver = typescript-language-server (works for JS too)
      lspconfig.tsserver.setup({
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
        },
      })
    end,
  },
}
