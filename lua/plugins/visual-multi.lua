vim.g.VM_theme = "purplegray"

return {
	{
		"mg979/vim-visual-multi",
		branch = "master",
		init = function()
			vim.api.nvim_set_keymap("n", "<A-d>", "<Plug>(VM-Add-Cursor-Down)", {})
			vim.api.nvim_set_keymap("n", "<A-e>", "<Plug>(VM-Add-Cursor-Up)", {})
		end,
	},
}
