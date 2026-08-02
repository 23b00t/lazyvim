return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.lsp.config("nil_ls", {
        cmd = { "nil" },
        filetypes = { "nix" },
        root_markers = { "flake.nix", ".git" },
      })
      vim.lsp.enable("nil_ls")
    end,
    opts = {
      servers = {
        nil_ls = false,
        nixd = false,
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        nix = { "statix", "deadnix" },
      },
    },
  },
}
