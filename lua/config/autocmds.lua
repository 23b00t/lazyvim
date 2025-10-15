-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		-- try to apply spell checking to strings and comments
		vim.cmd("syntax spell toplevel")
	end,
})

function _G.set_terminal_keymaps()
	local opts = { buffer = 0 }
	vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
	vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
	vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
	vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
	vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

-- php fix
-- local group = vim.api.nvim_create_augroup("PHPIndentFix", { clear = true })
--
-- vim.api.nvim_create_autocmd("FileType", {
-- 	group = group,
-- 	pattern = "php",
-- 	callback = function()
-- 		-- Verzögerung, um sicherzustellen, dass unsere Einstellungen nach
-- 		-- allen anderen Initialisierungen angewendet werden
-- 		vim.defer_fn(function()
-- 			-- Nur das TreeSitter-Indenting deaktivieren, nicht die ganze Funktionalität
-- 			vim.bo.indentexpr = "" -- Entferne das TreeSitter Indent-Expression
-- 			vim.bo.autoindent = true
-- 			vim.bo.cindent = false
-- 			vim.bo.smartindent = true
-- 			vim.bo.shiftwidth = 4
-- 		end, 10)
-- 	end,
-- })
