return {
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      local step = 15
      opts.keys = {
        -- increase width
        ["<c-Right>"] = function(win)
          win:resize("width", step)
        end,
        -- decrease width
        ["<c-Left>"] = function(win)
          win:resize("width", 0 - step)
        end,
        -- increase height
        ["<c-Up>"] = function(win)
          win:resize("height", 2)
        end,
        -- decrease height
        ["<c-Down>"] = function(win)
          win:resize("height", -2)
        end,     -- })
      }
      -- opts.right = opts.right or {}
      -- table.insert(opts.right, {
      --   title = "Database",
      --   ft = "dbui",
      --   pinned = true,
      --   width = 0.5,
      --   open = function()
      --     vim.cmd("DBUI")
      --   end,
      -- })
      --
      -- opts.bottom = opts.bottom or {}
      -- table.insert(opts.bottom, {
      --   title = "DB Query Result",
      --   ft = "dbout",
      -- opts.right = opts.right or {}
      -- table.insert(opts.right, {
      --   ft = "copilot-chat",
      --   title = "Copilot Chat",
      --   size = { width = 50 },
      -- })
    end,
  },
}
