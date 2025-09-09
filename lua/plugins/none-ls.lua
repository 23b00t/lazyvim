return {
	{
		"nvimtools/none-ls.nvim",
		opts = function(_, opts)
			-- remove all sources that support the php filetype
			opts.sources = vim.tbl_filter(function(src)
				return not (src.filetypes and vim.tbl_contains(src.filetypes, "php"))
			end, opts.sources or {})
		end,
	},
}
