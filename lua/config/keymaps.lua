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

Snacks.toggle({
	name = "Copilot Shadow Text",
	get = function()
		return vim.lsp.inline_completion.is_enabled()
	end,
	set = function(state)
		vim.lsp.inline_completion.enable(state)
	end,
}):map("<leader>ai")

-- Copilot inline completion (native LSP), same keys as the old copilot.lua setup.
-- Partial accept: insert only the next word/line of the suggestion; Copilot
-- re-requests afterwards, so the rest shows up again as shadow text.
local function accept_partial(patterns)
	return function()
		vim.lsp.inline_completion.get({
			on_accept = function(item)
				if type(item.insert_text) ~= "string" then
					return item
				end
				local win = vim.api.nvim_get_current_win()
				local buf = vim.api.nvim_win_get_buf(win)
				local row, col = unpack(vim.api.nvim_win_get_cursor(win))
				row = row - 1
				local srow, scol = row, col
				if item.range then
					srow, scol = item.range:to_extmark()
				end
				-- Text between range start and cursor is already typed; the suggestion repeats it.
				local typed = srow == row
						and vim.api.nvim_buf_get_text(buf, srow, scol, row, col, {})[1]
					or nil
				if not typed or item.insert_text:sub(1, #typed) ~= typed then
					return item
				end
				local rest, chunk = item.insert_text:sub(#typed + 1), nil
				for _, pattern in ipairs(patterns) do
					chunk = chunk or rest:match(pattern)
				end
				if not chunk or chunk == "" then
					return item
				end
				local lines = vim.split(chunk, "\n")
				vim.api.nvim_buf_set_text(buf, row, col, row, col, lines)
				vim.api.nvim_win_set_cursor(win, {
					row + #lines,
					(#lines == 1 and col or 0) + #lines[#lines],
				})
			end,
		})
	end
end

vim.keymap.set("i", "<A-s>", function()
	vim.lsp.inline_completion.get()
end, { desc = "Copilot: accept suggestion" })
vim.keymap.set("i", "<A-w>", accept_partial({ "^%s*[%w_]+", "^%s*[^%w_%s]+" }), { desc = "Copilot: accept word" })
vim.keymap.set("i", "<A-l>", accept_partial({ "^\n?[^\n]*" }), { desc = "Copilot: accept line" })
vim.keymap.set("i", "<A-n>", function()
	vim.lsp.inline_completion.select({ count = 1 })
end, { desc = "Copilot: next suggestion" })
vim.keymap.set("i", "<A-b>", function()
	vim.lsp.inline_completion.select({ count = -1 })
end, { desc = "Copilot: previous suggestion" })

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
