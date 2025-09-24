--[[
Plugin specification for olimorris/codecompanion.nvim.

Provides AI-powered code assistance, documentation generation, and chat features for Neovim.

Dependencies:
- nvim-lua/plenary.nvim: Utility functions for Neovim plugins.
- nvim-treesitter/nvim-treesitter: Syntax parsing for enhanced code understanding.
- MeanderingProgrammer/render-markdown.nvim: Markdown rendering for chat and documentation (enabled for markdown and codecompanion filetypes).
- nvim-mini/mini.diff: Minimal diff utility for code comparison.
- HakonHarnes/img-clip.nvim: Image clipboard integration, with custom settings for codecompanion filetype.

Options:
- providers: Configure AI providers (Copilot, Github Models) and chat strategies.
  - copilot: Enable or disable GitHub Copilot integration.
  - githubmodels: Enable or disable GitHub Models integration.
  - strategies.chat: Configure chat completion provider (cmp, blink, coc, default).
- shadow_text: Enable shadow text suggestions, set debounce time (ms), and highlight group.
- prompt_library: Define custom prompts for generating documentation comments and code comments.
  - Doc Comments: Inline strategy for generating doc comments, with key mapping and modes.
    - Prompts:
      - system: Sets the system role for expert documentation generation.
      - user (visual): Generates doc comments for visually selected code.
  - Update Doc: Inline strategy for updating doc comments, with key mapping and modes.
    - Prompts:
      - system: Sets the system role for expert documentation updating.
      - user (visual): Updates doc comments for visually selected code.
  - Comment: Inline strategy for generating code comments, with key mapping and modes.
    - Prompts:
      - system: Sets the system role for expert code commenting.
      - user (visual): Writes comments for visually selected code.

Keybindings:
- <leader>aa: Open CodeCompanion chat (normal/visual mode).
- <leader>at: Toggle CodeCompanion chat (normal/visual mode).
- <leader>aq: Enter inline command for selected code (visual mode).
- <leader>am: Open CodeCompanion actions (normal/visual mode).
- <leader>ac: Prompt for CodeCompanion command (normal mode).
- <localleader>ad: Generate doc comments for selected code (visual mode).
- <localleader>au: Update doc comments for selected code (visual mode).
- <localleader>ac: Write comments for selected code (visual mode).
--]]

--- Returns a function that generates a system role string for documentation or commenting prompts.
-- @param suffix string: Suffix describing the expert role (e.g., " documenter.").
-- @return function: Function that takes a context and returns the system role string.
local function system_role_suffix(suffix)
	return function(context)
		return "You are an expert " .. context.filetype .. suffix
	end
end

--- Returns a function that generates a user prompt including instructions and selected code.
-- @param prefix string: Prefix for the instructions (e.g., "\nWrite documentation comments...").
-- @return function: Function that takes a context and returns the user prompt string.
local function user_with_code(prefix)
	return function(context)
		local get_code = require("codecompanion.helpers.actions").get_code
		local text = get_code(context.start_line, context.end_line)
		local instructions = context.instructions or ""
		return instructions .. prefix .. "\n" .. text
	end
end

return {
	"olimorris/codecompanion.nvim",
	opts = {
		extensions = {
			-- NOTE: Installed vectorcode by: nix shell "nixpkgs#uv" "nixpkgs#gcc"
			-- uv tool install "vectorcode<1.0.0"

			---@module "vectorcode"
			vectorcode = {
				---@type VectorCode.CodeCompanion.ExtensionOpts
				opts = {
					tool_group = {
						-- this will register a tool group called `@vectorcode_toolbox` that contains all 3 tools
						enabled = true,
						-- a list of extra tools that you want to include in `@vectorcode_toolbox`.
						-- if you use @vectorcode_vectorise, it'll be very handy to include
						-- `file_search` here.
						extras = { "file_search" },
						collapse = false, -- whether the individual tools should be shown in the chat
					},
					tool_opts = {
						---@type VectorCode.CodeCompanion.ToolOpts
						["*"] = {},
						---@type VectorCode.CodeCompanion.LsToolOpts
						ls = {},
						---@type VectorCode.CodeCompanion.VectoriseToolOpts
						vectorise = {},
						---@type VectorCode.CodeCompanion.QueryToolOpts
						query = {
							max_num = { chunk = -1, document = -1 },
							default_num = { chunk = 100, document = 20 },
							include_stderr = false,
							use_lsp = true,
							no_duplicate = true,
							chunk_mode = false,
							---@type VectorCode.CodeCompanion.SummariseOpts
							summarise = {
								---@type boolean|(fun(chat: CodeCompanion.Chat, results: VectorCode.QueryResult[]):boolean)|nil
								enabled = true,
								-- adapter = nil,
								query_augmented = true,
							},
						},
						files_ls = {},
						files_rm = {},
					},
				},
			},
		},
		strategies = {
			chat = {
				opts = {
					completion_provider = "cmp", -- blink|cmp|coc|default
				},
				keymaps = {
					completion = { modes = { i = "<C-\\>" } },
					regenerate = { modes = { n = "<localleader>qr" } },
					stop = { modes = { n = "<localleader>qq" } },
					clear = { modes = { n = "<localleader>qx" } },
					codeblock = { modes = { n = "<localleader>qc" } },
					yank_code = { modes = { n = "<localleader>qy" } },
					pin = { modes = { n = "<localleader>qp" } },
					watch = { modes = { n = "<localleader>qw" } },
					change_adapter = { modes = { n = "<localleader>qa" } },
					fold_code = { modes = { n = "<localleader>qf" } },
					debug = { modes = { n = "<localleader>qd" } },
					system_prompt = { modes = { n = "<localleader>qs" } },
					memory = { modes = { n = "<localleader>qM" } },
					yolo_mode = { modes = { n = "<localleader>qty" } },
					goto_file_under_cursor = { modes = { n = "<localleader>qR" } },
					copilot_stats = { modes = { n = "<localleader>qS" } },
					super_diff = { modes = { n = "<localleader>qD" } },
				},
			},
		},
		providers = {
			copilot = { enabled = true },
			githubmodels = { enabled = true },
		},
		shadow_text = {
			enabled = true,
			debounce = 150,
			highlight = "Comment",
		},
		-- normalized keys to match the keybindings below
		prompt_library = {
			["Doc Comments"] = {
				strategy = "inline",
				description = "Generate doc comments",
				opts = {
					mapping = "<LocalLeader>ad",
					modes = { "v" },
					short_name = "Doc Comments",
				},
				prompts = {
					{
						role = "system",
						content = system_role_suffix(
							" documenter. You write clear, concise, and idiomatic doc comments."
						),
					},
					{
						role = "user",
						content = user_with_code("\nWrite documentation comments for the following selected code:"),
						opts = { contains_code = true },
					},
				},
			},
			["Update Doc"] = {
				strategy = "inline",
				description = "Update doc comments",
				opts = {
					mapping = "<LocalLeader>au",
					modes = { "v" },
					short_name = "Update Doc",
				},
				prompts = {
					{
						role = "system",
						content = system_role_suffix(
							" documenter. You write clear, concise, and idiomatic doc comments."
						),
					},
					{
						role = "user",
						content = user_with_code(
							"\nUpdate the documentation comments for the following selected code, don't change anything, just add and remove documentation comments for new or removed code:"
						),
						opts = { contains_code = true },
					},
				},
			},
			["Comment"] = {
				strategy = "inline",
				description = "Write Comments",
				opts = {
					mapping = "<LocalLeader>ac",
					modes = { "v" },
					short_name = "Comment",
				},
				prompts = {
					{
						role = "system",
						content = system_role_suffix(
							" code documenter. You write clear, concise, and idiomatic comments."
						),
					},
					{
						role = "user",
						content = user_with_code(
							"\nWrite comments to document the code for the following selected code. Please ensure that every significant step in the code is documented with clear, concise comments that explain its functionality, following best practices for code documentation. Comments should help readers understand the purpose and logic of each major section or operation:"
						),
						opts = { contains_code = true },
					},
				},
			},
		},
	},
	dependencies = {
		{
			"Davidyz/VectorCode",
			dependencies = { "nvim-lua/plenary.nvim" },
		},
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		{
			"MeanderingProgrammer/render-markdown.nvim",
			ft = { "markdown", "codecompanion" },
		},
		{ "nvim-mini/mini.diff", opts = {} },
		{
			"HakonHarnes/img-clip.nvim",
			opts = {
				filetypes = {
					codecompanion = {
						prompt_for_file_name = false,
						template = "[Image]($FILE_PATH)",
						use_absolute_path = true,
					},
				},
			},
		},
	},
	keys = {
		{ "<leader>aa", "<cmd>CodeCompanionChat<cr>", desc = " Open Chat", mode = { "n", "v" } },
		{ "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>", desc = " Toggle Chat", mode = { "n", "v" } },
		{ "<leader>aq", ":'<,'>CodeCompanion<cr>", desc = " Enter Inline Cmd", mode = { "v" } },
		{ "<leader>aq", "<cmd>CodeCompanion<cr>", desc = " Enter Inline Cmd", mode = { "n" } },
		{ "<leader>am", "<cmd>CodeCompanionActions<cr>", desc = " Actions", mode = { "n", "v" } },
		{ "<leader>ac", ":CodeCompanionCmd ", desc = "CodeCompanionCmd Prompt", mode = { "n" } },
		{
			"<localleader>ad",
			function()
				require("codecompanion").prompt("Doc Comments")
			end,
			desc = "Generate Doc Comments",
			mode = { "v" },
		},
		{
			"<localleader>au",
			function()
				require("codecompanion").prompt("Update Doc")
			end,
			desc = "Update Doc Comments",
			mode = { "v" },
		},
		{
			"<localleader>ac",
			function()
				require("codecompanion").prompt("Comment")
			end,
			desc = "Comment Code",
			mode = { "v" },
		},
	},
}
