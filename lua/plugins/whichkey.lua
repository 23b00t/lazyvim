return {
	"folke/which-key.nvim",
	opts = {
		require("which-key").add({ "<leader>a", group = "ai", mode = { "n", "v" } }),
	},
}
