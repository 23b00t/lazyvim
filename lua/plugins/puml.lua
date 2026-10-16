return {
  "aklt/plantuml-syntax", -- syntax highlighting
  ft = "plantuml",
  cmd = { "PlantumlPreview", "PlantumlPreviewStop", "PlantumlExport" },
  keys = {
    {
      "<leader>cp",
      function()
        require("plugins.puml.preview").toggle()
      end,
      ft = "plantuml",
      desc = "PlantUML Preview",
    },
  },
  config = function()
    require("plugins.puml.preview").setup()
  end,
}
