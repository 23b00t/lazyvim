return {
  "ibhagwan/fzf-lua",
  opts = {
    previewers = {
      builtin = {
        -- Treesitter's injection pass on large Markdown files blocks the main loop for
        -- over 30s while typing in a picker; the preview falls back to regex syntax.
        treesitter = { disabled = { "markdown" } },
      },
    },
  },
}
