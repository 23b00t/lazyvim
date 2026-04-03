-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- LSP Server to use for Ruby.

-- Set to "solargraph" to use solargraph instead of ruby_lsp.
vim.g.lazyvim_ruby_lsp = "ruby_lsp"
vim.g.lazyvim_ruby_formatter = "rubocop"

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

-- Autocmd to copy yanked text to host clipboard using OSC52
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		local event = vim.v.event
		if event.operator == "y" and event.regname == "" then -- nur Standardregister
			local yanked = vim.fn.getreg('"')
			if yanked and #yanked > 0 then
				osc52_copy(yanked)
			end
		end
	end,
	desc = "Copy yanked text to host clipboard (OSC52)",
})
