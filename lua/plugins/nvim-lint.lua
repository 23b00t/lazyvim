return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        php = { "phpstan" },
      },
      linters = {
        phpstan = {
          cmd = "phpstan",
          args = { "analyze", "--error-format=raw", "--no-progress", "src" },
          stdin = false,
          stream = "stdout",
          ignore_exitcode = true,
          parser = require("lint.parser").from_errorformat("%f:%l:%c: %m", {
            source = "phpstan",
          }),
        },
      },
    },
  },
}
