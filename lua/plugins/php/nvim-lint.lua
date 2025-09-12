local helpers = require("plugins.php.helpers")

return {
	"mfussenegger/nvim-lint",
	optional = true,
	opts = function(_, opts)
		opts.linters_by_ft = opts.linters_by_ft or {}
		opts.linters_by_ft.php = { "phpcs", "phpstan" }

		opts.linters = opts.linters or {}
		opts.linters.phpcs = {
			cmd = helpers.phpcs_bin,
			args = {
        "-q",
				"--standard=" .. helpers.phpcs_standard,
				"--report=json",
				"-",
			},
			stdin = true,
		}

		local phpstan_args = {
			"analyse",
			"--error-format=json",
			"--no-progress",
		}

		if helpers.phpstan_config then
			table.insert(phpstan_args, "--configuration=" .. helpers.phpstan_config)
		else
			table.insert(phpstan_args, "--level=max")
		end

		opts.linters.phpstan = {
			-- TODO: Include bin in php template
			cmd = helpers.phpstan_bin,
			args = phpstan_args,
			ignore_exitcode = true,
		}

		return opts
	end,
}
