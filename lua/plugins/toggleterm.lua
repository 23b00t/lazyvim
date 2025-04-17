return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      shell = vim.fn.executable("zsh") == 1 and "zsh" or vim.o.shell,
      direction = "horizontal",
      start_in_insert = true,
      persist_mode = true,
    },
    config = function(_, opts)
      local toggleterm = require("toggleterm")
      toggleterm.setup(opts)

      local Terminal = require("toggleterm.terminal").Terminal

      -- Define terminals outside the keymaps
      local term1 = Terminal:new({
        direction = "horizontal",
        hidden = true,
        count = 1,
        size = math.floor(vim.o.lines * 0.4),
      })

      local term2 = Terminal:new({
        direction = "vertical",
        hidden = true,
        count = 2,
        size = 120,
      })

      local term3 = Terminal:new({
        direction = "float",
        hidden = true,
        count = 3,
      })

      -- Keymaps toggle these exact instances
      vim.keymap.set("n", "<A-1>", function()
        term1:toggle()
      end, { desc = "Toggle Terminal 1 (horizontal)" })

      vim.keymap.set("n", "<A-2>", function()
        term2:toggle()
      end, { desc = "Toggle Terminal 2 (vertical)" })

      vim.keymap.set("n", "<A-3>", function()
        term3:toggle()
      end, { desc = "Toggle Terminal 3 (float)" })
    end,
  },
}
