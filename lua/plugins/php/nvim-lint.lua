local helpers = require("plugins.php.helpers")

if helpers.in_laravel then
	local cmd, prefix = helpers.laravel_cmd("vendor/bin/phpstan")
	local args = vim.deepcopy(prefix)
	vim.list_extend(args, { "analyse", "--error-format=json", "--no-progress", "--memory-limit=1G" })
	-- Analyse only the current (saved) file, addressed relative to the root.
	table.insert(args, function()
		return helpers.relative_path(vim.api.nvim_buf_get_name(0))
	end)

	return {
		"mfussenegger/nvim-lint",
		optional = true,
		opts = function(_, opts)
			-- Pint owns code style, so phpcs only adds noise here.
			opts.linters_by_ft = opts.linters_by_ft or {}
			opts.linters_by_ft.php = { "phpstan" }

			opts.linters = opts.linters or {}
			opts.linters.phpstan = {
				cmd = cmd,
				args = args,
				append_fname = false,
				ignore_exitcode = true,
				parser = function(output, bufnr)
					-- Non-JSON output (e.g. container not running) yields no diagnostics.
					local ok, json = pcall(vim.json.decode, output)
					if not ok or type(json) ~= "table" or type(json.files) ~= "table" then
						return {}
					end

					local relative = helpers.relative_path(vim.api.nvim_buf_get_name(bufnr))
					local diagnostics = {}
					for path, file in pairs(json.files) do
						-- Paths are absolute inside the container or on the host.
						if path:sub(-#relative - 1) == "/" .. relative then
							for _, message in ipairs(file.messages or {}) do
								table.insert(diagnostics, {
									lnum = type(message.line) == "number" and (message.line - 1) or 0,
									col = 0,
									message = message.message,
									source = "phpstan",
									code = message.identifier,
								})
							end
						end
					end
					return diagnostics
				end,
			}

			return opts
		end,
	}
end

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
