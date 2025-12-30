return {
	{
		"habamax/vim-godot",
	},
	-- { "skywind3000/asyncrun.vim" },
	{ "teatek/gdscript-extended-lsp.nvim" },
	{
		"mfussenegger/nvim-dap",
		optional = true,
		opts = function()
			local dap = require("dap")
			dap.adapters.godot = {
				type = "server",
				host = "127.0.0.1",
				port = 6007,
			}
			dap.configurations.gdscript = {
				{
					type = "godot",
					request = "launch",
					name = "Debug Godot Scene",
					project = "${workspaceFolder}",
					-- launch_scene = true,
				},
			}
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				gdscript = {
					filetypes = { "gd", "gdscript" },
				},
			},
		},
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				gdscript = { "gdformat" },
				gd = { "gdformat" },
			},
		},
		formatters = {
			gdformat = { command = "gdformat" },
		},
	},
	{
		-- Set tab width for gd and gdscript files
		"nvim-lua/plenary.nvim",
		config = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "gd", "gdscript" },
				callback = function()
					vim.opt_local.tabstop = 4
					vim.opt_local.shiftwidth = 4
					vim.opt_local.expandtab = true
				end,
			})
		end,
	},
}
