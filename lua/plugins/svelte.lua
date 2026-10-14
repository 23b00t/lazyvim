-- Svelte support on top of the `lang.svelte` extra (svelte LSP, treesitter, vtsls plugin).
-- Projects built on vite-plus lint with oxlint and format with oxfmt instead of
-- eslint/prettier; the binaries are picked up from the project's node_modules.
local web_fts = {
  "svelte",
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "css",
  "json",
  "jsonc",
}

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Only attaches where an oxlint/vite-plus config exists (see lspconfig root_dir).
        oxlint = { mason = false },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      local util = require("conform.util")

      opts.formatters = opts.formatters or {}
      -- Plain oxfmt ignores the `fmt` block in vite.config.ts (quotes, indent,
      -- tailwind class sorting), so vite-plus projects must go through `vp fmt`.
      opts.formatters.vp_fmt = {
        command = util.from_node_modules("vp"),
        args = { "fmt", "--stdin-filepath=$FILENAME" },
        stdin = true,
        cwd = util.root_file({ "vite.config.ts", "vite.config.js" }),
        require_cwd = true,
      }

      opts.formatters_by_ft = opts.formatters_by_ft or {}
      -- Formatters are only available when the project ships them in
      -- node_modules, so other projects keep falling back to prettier.
      for _, ft in ipairs(web_fts) do
        opts.formatters_by_ft[ft] = { "vp_fmt", "oxfmt", "prettier", stop_after_first = true }
      end
    end,
  },
}
