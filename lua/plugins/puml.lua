return {
  "Maduki-tech/nvim-plantuml",
  config = function()
    require("plantuml").setup({
      output_dir = "/tmp",
      viewer = "open",
      auto_refresh = true,
    })
  end,
}
