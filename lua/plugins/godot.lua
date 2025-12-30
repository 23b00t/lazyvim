return {
	{
		"mfussenegger/nvim-dap",
		optional = true,
		opts = function()
			local dap = require("dap")
			dap.adapters.godot = {
				type = "server",
				host = "127.0.0.1",
				port = 6007,
			}
			dap.configurations.gdscript = {
				{
					type = "godot",
					request = "launch",
					name = "Debug Godot Scene",
					project = "${workspaceFolder}",
					launch_scene = true,
				},
			}
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("lspconfig").gdscript.setup({
				filetypes = { "gd", "gdscript" },
				root_dir = function(fname)
					return require("lspconfig.util").root_pattern("project.godot")(fname)
						or require("lspconfig.util").root_pattern(".git")(fname)
				end,
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				gdscript = { "gdformat" },
				gd = { "gdformat" },
			},
		},
		formatters = {
			gdformat = { command = "gdformat" },
		},
	},
	{
		-- Set tab width for gd and gdscript files
		"nvim-lua/plenary.nvim",
		config = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "gd", "gdscript" },
				callback = function()
					vim.opt_local.tabstop = 4
					vim.opt_local.shiftwidth = 4
					vim.opt_local.expandtab = true
				end,
			})
		end,
	},
	{
		"junegunn/fzf.vim",
		dependencies = { "junegunn/fzf" },
		lazy = false,
	},
	{
		"habamax/vim-godot",
		dependencies = { "junegunn/fzf.vim" },
	},
	{ "skywind3000/asyncrun.vim" },
	-- {
	-- 	"teatek/gdscript-extended-lsp.nvim",
	-- 	config = function()
	-- 		require("gdscript-extended-lsp").setup({
	-- 			-- doc_file_extension = ".txt", -- Documentation file extension (can allow a better search in buffers list with telescope)
	-- 			view_type = "floating", -- Options : "current", "split", "vsplit", "tab", "floating"
	-- 			-- split_side = false, -- (For split and vsplit only) Open on the right or top on false and on the left or bottom on true
	-- 			-- keymaps = {
	-- 			-- 	declaration = "gd", -- Keymap to go to definition
	-- 			-- 	close = { "q" }, -- Keymap for closing the documentation
	-- 			-- },
	-- 			-- floating_win_size = 0.8, -- Floating window size
	-- 			-- picker = "telescope", -- Options : "telescope", "snacks", "fzf-lua"
	-- 		})
	-- 	end,
	-- },
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			if opts.ensure_installed == nil then
				opts.ensure_installed = {}
			end
			vim.list_extend(opts.ensure_installed, { "gdscript" })
		end,
	},
}
