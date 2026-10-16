return {
	"folke/which-key.nvim",
	-- Use a function so the entries are appended to LazyVim's spec instead of replacing it
	-- (lazy.nvim replaces list-like tables when merging opts).
	opts = function(_, opts)
		-- spellsuggest() raises "Keyboard interrupt" when the 'spellsuggest' timeout is hit
		-- (long German compound words); show a hint instead of throwing.
		local spelling = require("which-key.plugins.spelling")
		local expand = spelling.expand
		spelling.expand = function()
			local ok, items = pcall(expand)
			if ok then
				return items
			end
			return { { key = "1", desc = "no suggestions (timeout)", action = function() end } }
		end
		opts.spec = opts.spec or {}
		table.insert(opts.spec, {
			{ "<leader>a", group = "ai", mode = { "n", "v" } },
			{ "<localleader>c", group = "Diffview Choose", mode = { "n" } },
			{ "<localleader>d", group = "Diffview", mode = { "n" } },
		})
	end,
}
