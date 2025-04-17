return {
  -- https://github.com/Exafunction/codeium.vim
  {
    "Exafunction/windsurf.vim",
    config = function()
      -- Accept suggestion
      vim.keymap.set("i", "<M-s>", function()
        return vim.fn["codeium#Accept"]()
      end, { expr = true, silent = true })
      -- Next suggestion
      vim.keymap.set("i", "<M-n>", function()
        return vim.fn["codeium#CycleCompletions"](1)
      end, { expr = true, silent = true })
      -- Previous suggestion
      vim.keymap.set("i", "<M-b>", function()
        return vim.fn["codeium#CycleCompletions"](-1)
      end, { expr = true, silent = true })
      -- Accept word from suggestion
      vim.keymap.set("i", "<M-w>", function()
        return vim.fn["codeium#AcceptNextWord"]()
      end, { expr = true, silent = true })
      -- Accept line from suggestion
      vim.keymap.set("i", "<M-l>", function()
        return vim.fn["codeium#AcceptNextLine"]()
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<M-c>", function()
        return vim.fn["codeium#Clear"]()
      end, { expr = true, silent = true })
    end,
    event = "BufEnter",
  },
}
