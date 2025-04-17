-- ~/.config/nvim/lua/plugins/lualine.lua
return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- opts.options.theme = "github_dark_dimmed"
    opts.sections.lualine_c = {
      {
        function()
          local status = vim.api.nvim_call_function("codeium#GetStatusString", {})
          return " " .. status
        end,
      },
    }
  end,
}
