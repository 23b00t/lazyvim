return {
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local nls = require("null-ls")

      -- Entferne php-cs-fixer, falls es noch in den sources ist
      opts.sources = vim.tbl_filter(function(source)
        return source.name ~= "phpcs"
      end, opts.sources or {})

      -- Füge PHPStan als Linter hinzu
      table.insert(opts.sources, nls.builtins.diagnostics.phpstan.with({
        command = "/var/home/nx/.config/composer/vendor/bin/phpstan",  -- Der Befehl für PHPStan
        args = {
          "analyse",  -- PHPStan im Analyse-Modus ausführen
          "--configuration", "/home/devuser/code/il_9/ilias_9/CI/PHPStan/phpstan.neon",  -- Dein spezifischer PHPStan-Konfigurationspfad
          "--level", "max",  -- Setzt die Strenge von PHPStan auf maximal
          "--", ".",    -- Das aktuelle Verzeichnis als Analyse-Pfad
        },
      }))

      -- Optional: Füge Prettier für das Formatieren von PHP-Dateien hinzu
      table.insert(opts.sources, nls.builtins.formatting.prettier)
    end,
  },
}
