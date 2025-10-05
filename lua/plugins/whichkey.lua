return {
	"folke/which-key.nvim",
	opts = {
		require("which-key").add({
			{ "<leader>a", group = "ai", mode = { "n", "v" } },
			{ "<leader>k", group = "terminal", mode = { "n", "v", "t" } },
			{ "<localleader>c", group = "Diffview Choose", mode = { "n" } },
			{ "<localleader>d", group = "Diffview", mode = { "n" } },
		}),
	},
}
