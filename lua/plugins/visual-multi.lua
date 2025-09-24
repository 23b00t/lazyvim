return {
	{
		"mg979/vim-visual-multi",
		branch = "master",
		keys = {
      { "<A-d>", "<Plug>(VM-Add-Cursor-Down)", desc = "Visual Multi: Add Cursor Down", mode = { "n" } },
			{ "<A-e>", "<Plug>(VM-Add-Cursor-Up)", desc = "Visual Multi: Add Cursor Up", mode = { "n" } },
		},
		init = function()
			vim.g.VM_theme = "purblegray"
		end,
	},
}
