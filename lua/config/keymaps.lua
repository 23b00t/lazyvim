-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set({ "n" }, "<leader>bf", function()
	Snacks.picker.buffers()
end, { desc = "Buffer find", silent = true })

vim.keymap.set("v", "<leader>ks", function()
	require("toggleterm").send_lines_to_terminal("visual_selection", true, { args = vim.v.count })
end, { desc = "Send visual selection to terminal" })

vim.keymap.set({ "n", "v", "t" }, "<leader>kt", "<cmd>ToggleTermToggleAll<CR>", { desc = "Toggle all terminals" })

vim.keymap.set("n", "<leader>as", function()
	require("copilot.suggestion").toggle_auto_trigger()
end, { desc = "Toggle Shadow Text" })

-- Copy visual selection to clipboard using wl-copy
-- vim.keymap.set("v", "<leader>y", [[:'<,'>w !wl-copy<CR>]], { desc = "Copy to clipboard (wl-copy)" })
-- Paste clipboard contents at cursor using wl-paste
-- vim.keymap.set("n", "<leader>v", [[:r !wl-paste<CR>]], { desc = "Paste from clipboard (wl-paste)" })
local function copy_current_buffer_path()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    vim.notify("No path found!", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", path)
  vim.notify("Copied path: " .. path)
end

vim.keymap.set("n", "<leader>yY", copy_current_buffer_path, { desc = "Copy absolute path to clipboard" })

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto Definition (LSP)" })
