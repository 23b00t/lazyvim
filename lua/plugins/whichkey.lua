return {
	"folke/which-key.nvim",
	-- Use a function so the entries are appended to LazyVim's spec instead of replacing it
	-- (lazy.nvim replaces list-like tables when merging opts).
	opts = function(_, opts)
		opts.spec = opts.spec or {}
		table.insert(opts.spec, {
			{ "<leader>a", group = "ai", mode = { "n", "v" } },
			{ "<localleader>c", group = "Diffview Choose", mode = { "n" } },
			{ "<localleader>d", group = "Diffview", mode = { "n" } },
		})
	end,
}
