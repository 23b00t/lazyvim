return {
	"mfussenegger/nvim-dap",
	optional = true,
	opts = function()
		local dap = require("dap")
		local home = os.getenv("HOME")

		-- Debug adapter setup
		-- local path = require("mason-registry").get_package("php-debug-adapter"):get_install_path()
		-- dap.adapters.php = {
		-- 	type = "executable",
		-- 	command = "node",
		-- 	args = { path .. "/extension/out/phpDebug.js" },
		-- }
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
				name = "il9_2",
				port = 9003,
				pathMappings = {
					["/var/www/html"] = home .. "/code/il_9_2/ilias_9",
				},
			},
			{
				type = "php",
				request = "launch",
				name = "il9_it",
				port = 9003,
				pathMappings = {
					["/var/www/html"] = home .. "/code/il_9_it/ilias_9",
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
			{
				type = "php",
				request = "launch",
				name = "il10_new",
				port = 9003,
				pathMappings = {
					["/var/www/html"] = home .. "/code/il_10_new/ilias_10",
				},
			},
			{
				type = "php",
				request = "launch",
				name = "il9_chart",
				port = 9003,
				pathMappings = {
					["/var/www/html"] = home .. "/code/il_9_chart/ilias_9",
				},
			},
			{
				type = "php",
				request = "launch",
				name = "il10_auth",
				port = 9003,
				pathMappings = {
					["/var/www/html"] = home .. "/code/il_10_auth/ilias_10",
				},
			},
			{
				type = "php",
				request = "launch",
				name = "il11_auth",
				port = 9003,
				pathMappings = {
					["/var/www/html"] = home .. "/code/il_11_auth/ilias_11",
				},
			},
			{
				type = "php",
				request = "launch",
				name = "il12_auth",
				port = 9003,
				pathMappings = {
					["/var/www/html"] = home .. "/code/il_12_auth/ilias_12",
				},
			},
		}
	end,
}
