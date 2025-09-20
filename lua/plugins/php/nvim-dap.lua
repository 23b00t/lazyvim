return {
	"mfussenegger/nvim-dap",
	optional = true,
	opts = function()
		local dap = require("dap")
		local home = os.getenv("HOME")

		-- Debug adapter setup
		local path = require("mason-registry").get_package("php-debug-adapter"):get_install_path()
		dap.adapters.php = {
			type = "executable",
			command = "node",
			args = { path .. "/extension/out/phpDebug.js" },
		}
		-- Debug configurations
		dap.configurations.php = {
			{
				type = "php",
				request = "launch",
				name = "il9",
				port = 9003,
				pathMappings = {
					["/var/www/html"] = home .. "/code/il_9/ilias_9",
				},
			},
			{
				type = "php",
				request = "launch",
				name = "il10",
				port = 9003,
				pathMappings = {
					["/var/www/html"] = home .. "/code/il_10/ilias_10",
				},
			},
			{
				type = "php",
				request = "launch",
				name = "il10_2",
				port = 9003,
				pathMappings = {
					["/var/www/html"] = home .. "/code/il_10_2/ilias_10",
				},
			},
		}
	end,
}
