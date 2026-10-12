-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Set to "solargraph" to use solargraph instead of ruby_lsp.
vim.g.lazyvim_ruby_lsp = "ruby_lsp"
vim.g.lazyvim_ruby_formatter = "rubocop"

-- Enable spell checking
vim.opt.spelllang = { "en_us", "de" }

-- Disable autoformat (format on save)
vim.g.autoformat = false

-- set zsh as default shell
vim.opt.shell = "zsh"

-- disable swap files
vim.opt.swapfile = false

vim.g.snacks_animate = false

vim.opt.clipboard = "unnamedplus"

--- Whether a usable Wayland session is reachable (local, or forwarded e.g. via wprs).
--- Checks the socket too: a zellij session started under Wayland and later attached
--- via plain ssh still inherits a WAYLAND_DISPLAY whose socket may be gone.
--- @return boolean
local function has_wayland_clipboard()
	local display = vim.env.WAYLAND_DISPLAY
	if not display or vim.fn.executable("wl-copy") == 0 then
		return false
	end
	local socket = display:sub(1, 1) == "/" and display or ((vim.env.XDG_RUNTIME_DIR or "") .. "/" .. display)
	return vim.uv.fs_stat(socket) ~= nil
end

if has_wayland_clipboard() then
	-- wl-clipboard with a paste timeout: if the selection owner never answers, wl-paste
	-- would block forever and freeze nvim (e.g. which-key's register preview reads "*" and "+").
	vim.g.clipboard = {
		name = "wl-clipboard-timeout",
		copy = {
			["+"] = { "wl-copy", "--type", "text/plain" },
			["*"] = { "wl-copy", "--primary", "--type", "text/plain" },
		},
		paste = {
			["+"] = { "timeout", "1", "wl-paste", "--no-newline" },
			["*"] = { "timeout", "1", "wl-paste", "--no-newline", "--primary" },
		},
		cache_enabled = 1,
	}
else
	-- No Wayland (e.g. ssh into a VM): copy to the host clipboard via OSC52, which passes
	-- through zellij/kitty/foot. zellij does not forward OSC52 paste queries, so paste from
	-- the unnamed register; use the terminal's paste (Ctrl+Shift+V) for host -> VM.
	local osc52 = require("vim.ui.clipboard.osc52")
	local function paste()
		return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
	end
	vim.g.clipboard = {
		name = "osc52-copy-only",
		copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
		paste = { ["+"] = paste, ["*"] = paste },
	}
end
