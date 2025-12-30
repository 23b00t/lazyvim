return {
	{
		"habamax/vim-godot",
		config = function()
			-- Godot remote starten auf Host (über ssh)
			vim.g.godot_executable = "ssh nx@10.0.0.254 godot"
		end,
	},
	{ "skywind3000/asyncrun.vim" },
	{ "teatek/gdscript-extended-lsp.nvim", opts = { view_type = "floating", picker = "snacks" } },
	{
		"mfussenegger/nvim-dap",
		optional = true,
		opts = function()
			local dap = require("dap")
			dap.adapters.godot = {
				type = "server",
				host = "10.0.0.254",
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
					cmd = { "ncat", "10.0.0.254", "6005" }, -- schickt stdin/stdout zu Godot!
					filetypes = { "gd", "gdscript" },
				},
			},
		},
	},
}
