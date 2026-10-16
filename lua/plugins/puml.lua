return {
  "weirongxu/plantuml-previewer.vim",
  dependencies = {
    "tyru/open-browser.vim", -- opens the preview in the browser
    "aklt/plantuml-syntax", -- syntax highlighting + filetype
  },
  ft = "plantuml",
  cmd = { "PlantumlOpen", "PlantumlToggle", "PlantumlStop", "PlantumlSave" },
  init = function()
    -- Use the jar from the nix plantuml package (<store>/bin/plantuml -> <store>/lib/plantuml.jar)
    -- instead of the one bundled with the plugin. Resolved at runtime since the store path changes.
    local exe = vim.fn.exepath("plantuml")
    if exe ~= "" then
      local jar = vim.fn.fnamemodify(vim.fn.resolve(exe), ":h:h") .. "/lib/plantuml.jar"
      if vim.uv.fs_stat(jar) then
        vim.g["plantuml_previewer#plantuml_jar_path"] = jar
      end
    end
    vim.g["plantuml_previewer#save_format"] = "svg"
    vim.g["plantuml_previewer#viewer_path"] = vim.fn.expand("~/.cache/plantuml-previewer")
  end,
}
