return {
	"mfussenegger/nvim-dap",
	optional = true,
	opts = function()
		local dap = require("dap")
		-- TODO: Do I need this block?
		local path = require("mason-registry").get_package("php-debug-adapter"):get_install_path()
		dap.adapters.php = {
			type = "executable",
			command = "node",
			args = { path .. "/extension/out/phpDebug.js" },
		}
		-- TODO: END block
		dap.configurations.php = {
			{
				type = "php",
				request = "launch",
				name = "xdebug",
				port = 9003,
				pathMappings = {
					-- TODO: Add mappings for other versions. Are multiple possible? Set it dynamically?
					-- What is with other PHP projects?
					["/var/www/html"] = "/home/nx/code/il_9/ilias_9",
				},
				-- optional: weitere Optionen wie stopOnEntry, etc.
			},
		}
	end,
}
