return {
  "sindrets/diffview.nvim",
  config = function()
    local actions = require("diffview.actions")
    require("diffview").setup({
      keymaps = {
        view = {
          { "n", "<localleader>e",  actions.focus_files, { desc = "Focus file panel" } },
          { "n", "<localleader>b",  actions.toggle_files, { desc = "Toggle file panel" } },
          { "n", "<localleader>ca", actions.conflict_choose("all"), { desc = "Choose all versions of conflict" } },
          { "n", "<localleader>cA", actions.conflict_choose_all("all"), { desc = "Choose all versions of conflict (whole file)" } },
          { "n", "<localleader>cb", actions.conflict_choose("base"), { desc = "Choose BASE version of conflict" } },
          { "n", "<localleader>cB", actions.conflict_choose_all("base"), { desc = "Choose BASE version of conflict (whole file)" } },
          { "n", "<localleader>co", actions.conflict_choose("ours"), { desc = "Choose OURS version of conflict" } },
          { "n", "<localleader>cO", actions.conflict_choose_all("ours"), { desc = "Choose OURS version of conflict (whole file)" } },
          { "n", "<localleader>ct", actions.conflict_choose("theirs"), { desc = "Choose THEIRS version of conflict" } },
          { "n", "<localleader>cT", actions.conflict_choose_all("theirs"), { desc = "Choose THEIRS version of conflict (whole file)" } },
        },
      },
    })

    -- Custom commands (not part of Diffview keymaps)
    vim.keymap.set('n', '<localleader>do', "<Cmd>DiffviewOpen<CR>", { desc = "Open Diffview" })
    vim.keymap.set('n', '<localleader>dc', "<Cmd>DiffviewClose<CR>", { desc = "Close Diffview" })
    vim.keymap.set('n', '<localleader>dh', "<Cmd>DiffviewFileHistory<CR>", { desc = "Diffview Filehistory" })
  end,
}
