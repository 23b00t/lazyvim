return {
	-- { "akinsho/toggleterm.nvim", version = "*", config = true },
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function(_, opts)
			local toggleterm = require("toggleterm")
			opts.size = 20
			toggleterm.setup(opts)

			local terminals = {}
			for i = 1, 8 do
				terminals[i] = require("toggleterm.terminal").Terminal:new({
					direction = "horizontal",
					count = i,
					hide_numbers = false,
          autochdir = true,
          dir = "git_dir",
				})
			end
			terminals[9] = require("toggleterm.terminal").Terminal:new({
				direction = "float",
				count = 9,
			})

			-- Keymaps toggle these exact instances
			for i = 1, 9 do
				vim.keymap.set({ "n", "t" }, "<A-" .. i .. ">", function()
					terminals[i]:toggle()
				end, { desc = "Toggle Terminal " .. i .. (i == 9 and " (float)" or "") })
			end
		end,
	},
}
