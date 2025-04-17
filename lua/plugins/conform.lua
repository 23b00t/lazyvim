return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ruby = { formatter },
        eruby = { "erb_format" },
        php = {
          {
            "php_cs_fixer",
            args = { "fix", "--config=.php-cs-fixer.dist.php", "--using-cache=no", "--quiet" },
          },
        },
      },
    },
  },
}
