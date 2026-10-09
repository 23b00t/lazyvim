-- Always use Claude Code: the LazyVim sidekick extra's keys are redefined with
-- a `claude` filter, so no tool picker shows up (<leader>as still offers all).
local function cli(fn, opts)
  return function()
    require("sidekick.cli")[fn](vim.tbl_extend("force", { name = "claude" }, opts or {}))
  end
end

return {
  "folke/sidekick.nvim",
  opts = {
    -- Persist CLI sessions in zellij, so detach (<leader>ad) keeps Claude running.
    cli = { mux = { backend = "zellij", enabled = true } },
  },
  -- stylua: ignore
  keys = {
    { "<c-.>", cli("focus"), desc = "Sidekick Focus", mode = { "n", "t", "i", "x" } },
    { "<leader>aa", cli("toggle"), desc = "Sidekick Toggle Claude" },
    { "<leader>ad", cli("close"), desc = "Detach Claude Session" },
    { "<leader>at", cli("send", { msg = "{this}" }), mode = { "x", "n" }, desc = "Send This" },
    { "<leader>af", cli("send", { msg = "{file}" }), desc = "Send File" },
    { "<leader>av", cli("send", { msg = "{selection}" }), mode = { "x" }, desc = "Send Visual Selection" },
    {
      "<leader>ap",
      function()
        require("sidekick.cli").prompt({
          cb = function(_, text)
            if text then
              require("sidekick.cli").send({ text = text, name = "claude" })
            end
          end,
        })
      end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
  },
}
