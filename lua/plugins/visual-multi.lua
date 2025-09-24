return {
	{
		"mg979/vim-visual-multi",
		branch = "master",
		keys = {
			{ "<C-j>", "<Plug>(VM-Add-Cursor-Down)", desc = "Visual Multi: Add Cursor Down", mode = { "n" } },
			{ "<C-k>", "<Plug>(VM-Add-Cursor-Up)", desc = "Visual Multi: Add Cursor Up", mode = { "n" } },
		},
		init = function()
			vim.g.VM_theme = "purblegray"
		end,
	},
}
