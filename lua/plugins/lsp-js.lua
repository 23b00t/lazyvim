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
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.tsserver = vim.tbl_deep_extend("force", opts.servers.tsserver or {}, {
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
        },
      })
      return opts
    end,
  },
}
