local helpers = require("plugins.php.helpers")

if helpers.in_laravel then
	local cmd, prefix = helpers.laravel_cmd("vendor/bin/pint")

	return {
		"stevearc/conform.nvim",
		optional = true,
		opts = function(_, opts)
			opts.formatters_by_ft = opts.formatters_by_ft or {}
			opts.formatters_by_ft.php = { "pint" }

			opts.formatters = opts.formatters or {}
			opts.formatters.pint = {
				command = cmd,
				-- conform writes a temp file next to the buffer; pass it relative to
				-- the root so the path also resolves inside the container.
				args = function(_, ctx)
					local args = vim.deepcopy(prefix)
					table.insert(args, "--quiet")
					table.insert(args, helpers.relative_path(ctx.filename))
					return args
				end,
				cwd = function()
					return vim.fn.getcwd()
				end,
				stdin = false,
			}

			return opts
		end,
	}
end

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
