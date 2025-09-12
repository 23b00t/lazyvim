local helpers = require("plugins.php.helpers")

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
        "--rules=@PSR12",
        -- NOTE: ILIAS rules are not satisfying
        -- helpers.php_cs_fixer_config and helpers.php_cs_fixer_config,
        "--using-cache=no",
				"fix",
				"$FILENAME",
				"--quiet",
			},
			stdin = false, -- Wichtig: Benötigt Dateipfad, nicht stdin
			-- ILIAS nutzt oft LF, falls dein Editor was anderes versucht
			line_ending = "lf",
		}

		return opts
	end,
}
