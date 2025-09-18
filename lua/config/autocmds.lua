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
local uv = vim.loop
local sep = package.config:sub(1,1)

local function exists(path)
  return uv.fs_stat(path) ~= nil
end

-- Suche rekursiv nach dem nächsten Parent, der eine .git Datei/Ordner enthält.
-- startpath muss ein absolutes Verzeichnis sein.
local function find_git_root(startpath)
  if not startpath or startpath == "" then
    return nil
  end

  local path = vim.fn.fnamemodify(startpath, ":p")
  local prev = ""

  while path ~= prev do
    if exists(path .. sep .. ".git") then
      return vim.fn.fnamemodify(path, ":p")
    end
    prev = path
    path = vim.fn.fnamemodify(path .. sep .. "..", ":p")
  end

  return nil
end

local function set_cwd_to_git_parent()
  local bufname = vim.api.nvim_buf_get_name(0)
  if not bufname or bufname == "" then
    return
  end

  local startdir = vim.fn.fnamemodify(bufname, ":p:h")
  if startdir == "" then
    return
  end

  local git_root = find_git_root(startdir)
  if git_root and git_root ~= "" then
    -- Nur setzen, wenn sich das cwd tatsächlich ändert (kleine Optimierung)
    local cwd = vim.loop.cwd()
    if cwd ~= git_root then
      pcall(vim.api.nvim_set_current_dir, git_root)
      -- vim.notify("cwd → " .. git_root, vim.log.levels.INFO, { title = "Project CWD" })
    end
  end
  -- Wenn kein .git gefunden wurde: nichts machen
end

-- Autocmd: bei Buffer- und Window-Enter das cwd ggf. setzen
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  callback = function()
    set_cwd_to_git_parent()
  end,
})
