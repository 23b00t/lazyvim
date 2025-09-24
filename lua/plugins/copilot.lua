--[[
Plugin specification for GitHub Copilot integration in Neovim using zbirenbaum/copilot.lua.

This table configures the Copilot plugin with custom options and keymaps, and disables telemetry.
It also updates LazyVim's cmp.actions to handle Copilot suggestions.

Fields:
- "zbirenbaum/copilot.lua": Plugin repository.
- cmd: Command to trigger Copilot.
- build: Command to authenticate Copilot.
- event: Lazy-loading event (BufReadPost).
- opts: Function to setup Copilot configuration.
  - suggestion: Controls inline suggestion behavior and keymaps.
  - panel: Enables Copilot panel.
  - chat: Enables Copilot Chat and follow-up mode.
  - server_opts_overrides: Disables telemetry.
  - filetypes: Enables Copilot for all filetypes.
  - filetypes_exclude: (commented) Example of disabling Copilot for specific filetypes.

Example:
  Use <A-s> to accept Copilot suggestions, <A-n>/<A-b> to cycle, <C-c> to dismiss.
]]
return {
    -- Specify the Copilot plugin repository
    "zbirenbaum/copilot.lua",
    -- Define the command to trigger Copilot
    cmd = "Copilot",
    -- Command to authenticate Copilot after installation
    build = ":Copilot auth",
    -- Load Copilot when a buffer is read
    event = "BufReadPost",
    -- Plugin options and configuration
    opts = function()
        -- Initialize and configure Copilot
        require("copilot").setup({
            suggestion = {
                enabled = true, -- Enable inline shadow-text suggestions
                auto_trigger = true, -- Automatically show suggestions as you type
                debounce = 500, -- Wait 500ms before showing suggestions after typing
                hide_during_completion = false, -- Keep suggestions visible during LSP completion
                keymap = {
                    accept = "<A-s>", -- Keybinding to accept the current suggestion
                    next = "<A-n>", -- Keybinding to cycle to the next suggestion
                    prev = "<A-b>", -- Keybinding to cycle to the previous suggestion
                    dismiss = "<C-c>", -- Keybinding to dismiss the current suggestion
                    accept_word = "<A-w>", -- Keybinding to accept the current word from the suggestion
                    accept_line = "<A-l>", -- Keybinding to accept the current line from the suggestion
                },
            },
            panel = {
                enabled = true, -- Enable the Copilot panel for viewing suggestions
            },
            chat = {
                enabled = true, -- Enable Copilot Chat for conversational AI
                follow_up_mode = true, -- Allow follow-up questions in the same chat session
            },
            server_opts_overrides = {
                settings = {
                    telemetry = {
                        telemetryLevel = "off", -- Disable telemetry data collection
                    },
                },
            },
            filetypes = {
                ["*"] = true, -- Enable Copilot for all filetypes by default
            },
            -- Uncomment and edit the following to disable Copilot for specific filetypes
            -- filetypes_exclude = {
            --   "plaintext", -- Disable Copilot for plaintext files
            --   "log", -- Disable Copilot for log files
            -- },
        })

        -- Override LazyVim's cmp.actions.ai_accept to disable Copilot's AI accept action
        LazyVim.cmp.actions.ai_accept = function()
            return false
        end
    end,
}
