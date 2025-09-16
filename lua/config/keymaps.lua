-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set({ "n" }, "<leader>bf", function()
	Snacks.picker.buffers()
end, { desc = "Buffer find", silent = true })

vim.keymap.set("v", "<leader>e", function()
	require("toggleterm").send_lines_to_terminal("visual_selection", true, { args = vim.v.count })
end, { desc = "Send visual selection to terminal" })

vim.keymap.set({ "n", "v", "t" }, "<leader>t", "<cmd>ToggleTermToggleAll<CR>", { desc = "Toggle all terminals" })
