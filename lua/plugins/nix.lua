return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        nil_ls = false,
        nixd = {
          settings = {
            nixd = {
              formatting = {
                command = { "nixfmt" },
              },
            },
          },
        },
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
