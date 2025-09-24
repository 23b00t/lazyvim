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

vim.keymap.set("n", "<leader>as", function()
	require("copilot.suggestion").toggle_auto_trigger()
end, { desc = "Toggle Shadow Text" })

-- Copy visual selection to clipboard using wl-copy
vim.keymap.set("v", "<leader>y", [[:'<,'>w !wl-copy<CR>]], { desc = "Copy to clipboard (wl-copy)" })
-- Paste clipboard contents at cursor using wl-paste
vim.keymap.set("n", "<leader>v", [[:r !wl-paste<CR>]], { desc = "Paste from clipboard (wl-paste)" })
