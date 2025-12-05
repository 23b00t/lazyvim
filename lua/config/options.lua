-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- LSP Server to use for Ruby.

-- Set to "solargraph" to use solargraph instead of ruby_lsp.
-- vim.g.lazyvim_ruby_lsp = "solargraph"
-- vim.g.lazyvim_ruby_formatter = "rubocop"

-- Enable spell checking
vim.opt.spelllang = { "en_us", "de" }

-- Disable autoformat (format on save)
vim.g.autoformat = false
-- But enable autoindent
-- vim.opt.autoindent = true

-- set zsh as default shell
vim.opt.shell = "zsh"

-- Set to "intelephense" to use intelephense instead of phpactor.
-- deactivated phpactor in lsp.lua; if I configure intelephense there, and define it here
-- I end up having to servers running in parallel, one with my desired config and one without.
-- vim.g.lazyvim_php_lsp = "intelephense"

-- disable swap files
vim.opt.swapfile = false

-- force root_dir to cwd
-- vim.g.root_spec = { "cwd" }

vim.g.snacks_animate = false

-- Optionally to prevent paperwm bug: https://github.com/paperwm/PaperWM/issues/1021
-- vim.opt.clipboard = ""
-- vim.g.clipboard = 'osc52'
vim.opt.clipboard = "unnamedplus"
-- Function to copy text using OSC52
local function osc52_copy(text)
	-- Base64 encoding with Lua (faster and more robust than system calls)
	local b64 = vim.base64.encode(text)
	-- Build OSC52 sequence
	local osc = string.format("\x1b]52;c;%s\x07", b64)
	-- Send to stderr (often more reliable for escape codes than stdout in nvim TUI)
	vim.api.nvim_chan_send(vim.v.stderr, osc)
end

-- Helper to get the current visual selection
local function get_visual_selection()
	local s_start = vim.fn.getpos("'<")
	local s_end = vim.fn.getpos("'>")
	local n_lines = math.abs(s_end[2] - s_start[2]) + 1
	local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)

	if #lines == 0 then
		return ""
	end

	lines[1] = string.sub(lines[1], s_start[3], -1)
	if n_lines == 1 then
		lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
	else
		lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
	end
	return table.concat(lines, "\n")
end

-- Mapping for visual selection
vim.keymap.set("v", "<localleader>y", function()
	-- Exit visual mode to update marks '< and '>
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
	local text = get_visual_selection()
	osc52_copy(text)
	vim.notify("Copied selection to host clipboard (OSC52)", vim.log.levels.INFO)
end, { desc = "Copy selection to clipboard (OSC52)" })

-- Mapping for current line in normal mode
vim.keymap.set("n", "<localleader>y", function()
	local text = vim.api.nvim_get_current_line()
	osc52_copy(text)
	vim.notify("Copied line to host clipboard (OSC52)", vim.log.levels.INFO)
end, { desc = "Copy line to clipboard (OSC52)" })
