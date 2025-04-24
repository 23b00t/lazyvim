return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        php = { "phpcs" },
      },
      linters = {
        phpcs = {
          args = {
            "-q",
            "--standard=PSR2",
            "--report=json",
            "-"
          },
        },
      },
    },
  },
}
