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
  local opts = {buffer = 0}
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

-- Set cmd to .git of current buffer (for nested git repos)
-- Simple autocmd: determines the directory of the current file,
-- asks git with -C <dir> for the repo root and sets the cwd if found.
local function set_cwd_to_buffer_git_root()
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname == nil or bufname == "" then
    return
  end

  local dir = vim.fn.expand('%:p:h')
  if dir == nil or dir == "" then
    return
  end

  -- Ask git for the root, without changing the global cwd
  local output = vim.fn.systemlist({ "git", "-C", dir, "rev-parse", "--show-toplevel" })
  if vim.v.shell_error == 0 and output and output[1] and output[1] ~= "" then
    local git_root = vim.fn.fnamemodify(output[1], ":p")
    local ok, cur = pcall(vim.loop.cwd)
    if not ok then cur = "" end
    if cur ~= git_root then
      pcall(vim.api.nvim_set_current_dir, git_root)
    end
  end
  -- If no git root was found: do nothing
end

-- Autocmd: on Buffer and Window enter, set cwd to git root if applicable
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  callback = function()
    set_cwd_to_buffer_git_root()
  end,
})
