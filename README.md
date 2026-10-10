# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## Copilot: Next Edit Suggestions (NES)

Der Shadow-Text (Inline Completion) ergänzt Code an der Cursorposition.
NES schlägt dagegen, ausgehend von deiner letzten Änderung, die nächste
passende Änderung an anderer Stelle in der Datei vor, z. B. weitere Stellen
einer Umbenennung. Beides läuft über Copilot (sidekick.nvim) und belastet das
Kontingent von Copilot Free, deshalb ist NES standardmäßig aus.

| Taste | Funktion |
|---|---|
| `<leader>uN` | NES für die laufende Sitzung an/aus |
| `<Tab>` (Normal) | zum Vorschlag springen, nochmal `<Tab>` übernimmt ihn |
| `<Tab>` (Insert) | Snippet-Sprung, sonst NES übernehmen, sonst Shadow-Text übernehmen |

Dauerhaft aktivieren: in `lua/plugins/sidekick.lua` die Zeile
`nes = { enabled = false },` entfernen.

## Git Review (AI-Änderungen im Editor prüfen)

Diff direkt im normalen Buffer – LSP, Navigation und Editieren bleiben verfügbar.
Basiert auf gitsigns (LazyVim-Standard), Config in `lua/plugins/git-review.lua`.
Lazygit (`<leader>gg`) bleibt für Git-Arbeit, diffview für Mergekonflikte.

| Taste | Funktion |
|---|---|
| `<leader>gR` | Review-Modus an/aus: Zeilen farbig hinterlegt, Wort-Diff, gelöschte Zeilen als virtuelle Zeilen |
| `<leader>gV` | Diff-Basis wählen: Index, HEAD, HEAD~1, Branch… oder Commit… (gilt für alle Buffer) |
| `<leader>gv` | Picker mit allen Hunks gegen die aktuelle Basis, über alle Dateien, mit Vorschau |
| `]h` / `[h` | nächster / vorheriger Hunk |
| `<leader>ghs` | Hunk stagen = annehmen |
| `<leader>ghr` | Hunk zurücksetzen = ablehnen |

### Workflow für AI-Änderungen

- **Basis Index** (Default): Es werden nur ungestagte Änderungen angezeigt.
  Angenommenes mit `<leader>ghs` stagen, es verschwindet aus der Hervorhebung;
  Abgelehntes mit `<leader>ghr` zurücksetzen. Am Ende ist alles Gestagte geprüft.
- **Basis HEAD**: alles seit dem letzten Commit, inkl. Gestagtem.
- **Basis HEAD~1**: wenn Claude bereits committet hat.

Hinweis: `toggle_deleted` ist in gitsigns als deprecated markiert, funktioniert aber.
`preview_hunk_inline` wäre die Alternative, zeigt Gelöschtes aber nur für einen Hunk.
