return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    window = {
      width = 60,
    },
  },
  -- keys = {
  --   {
  --     "<leader>fe",
  --     function()
  --       require("neo-tree.command").execute({ action = "focus", dir = LazyVim.root() })
  --     end,
  --     desc = "Explorer NeoTree (Root Dir)",
  --   },
  --   {
  --     "<leader>fE",
  --     function()
  --       require("neo-tree.command").execute({ action = "focus", dir = vim.uv.cwd() })
  --     end,
  --     desc = "Explorer NeoTree (cwd)",
  --   },
  -- },
}
