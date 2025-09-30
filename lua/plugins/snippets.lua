return {
  {
    "L3MON4D3/LuaSnip",
    opts = function(_, _)
      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node

      ls.add_snippets("php", {
        s("dic", {
          t("/** @var \\ILIAS\\DI\\Container $DIC */"),
        }),
      })
    end,
  },
}
