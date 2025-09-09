-- Der Name "zz-" sorgt dafür, dass LazyVim diese Datei als eine der letzten lädt.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- Wir hängen uns an nvim-treesitter, da es immer für PHP geladen wird.
    config = function()
      -- Erstelle eine dedizierte autocommand-Gruppe, um sie sauber verwalten zu können.
      local group = vim.api.nvim_create_augroup("PHPIndentFix", { clear = true })

      -- Erstelle den autocommand, der bei jedem Öffnen einer PHP-Datei feuert.
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "php",
        callback = function()
          -- Setze einen Timer, der die Befehle mit einer winzigen Verzögerung ausführt.
          -- Dies stellt sicher, dass unser Code NACH allen anderen Initialisierungs-Skripten
          -- (LSP, Tree-sitter etc.) ausgeführt wird. Dies ist der entscheidende Trick.
          vim.defer_fn(function()
            vim.bo.autoindent = true
            vim.bo.cindent = false
            vim.bo.smartindent = false
          end, 10) -- 10 Millisekunden Verzögerung
        end,
      })
    end,
  },
}
