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
