local helpers = require("plugins.php.helpers")

if helpers.in_ilias == false then
  return {}
end

return {
	"stevearc/conform.nvim",
	optional = true,
	opts = function(_, opts)
		opts.formatters_by_ft = opts.formatters_by_ft or {}
		opts.formatters_by_ft.php = { "php_cs_fixer", "phpcbf" }

		opts.formatters = opts.formatters or {}
		opts.formatters.php_cs_fixer = {
			command = helpers.php_cs_fixer_bin,
			args = {
        -- "--rules=@PSR12",
        "--config=" .. (helpers.php_cs_fixer_config or ""),
        "--using-cache=no",
				"fix",
				"$FILENAME",
				"--quiet",
			},
			stdin = false,
			line_ending = "lf",
		}

		return opts
	end,
}
