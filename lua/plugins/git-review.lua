-- In-buffer diff review (e.g. for AI changes) on top of LazyVim's gitsigns.
-- <leader>gR toggles line/word highlights + deleted lines inside the real buffer
-- (LSP keeps working), <leader>gV picks what to diff against, <leader>gv lists
-- all hunks against that base. Accept/reject per hunk with <leader>ghs / <leader>ghr.

local base ---@type string? nil = index (gitsigns default)

local function set_base(rev)
  base = rev
  require("gitsigns").change_base(rev, true)
  vim.notify("Diff base: " .. (rev or "index"), vim.log.levels.INFO, { title = "Git Review" })
end

local function pick_base()
  local choices = {
    { label = "Index (unstaged changes only)" },
    { label = "HEAD (all uncommitted changes)", rev = "HEAD" },
    { label = "HEAD~1 (incl. last commit)", rev = "HEAD~1" },
    { label = "Branch…", picker = "git_branches" },
    { label = "Commit…", picker = "git_log" },
  }
  vim.ui.select(choices, {
    prompt = "Diff against",
    format_item = function(c)
      return c.label
    end,
  }, function(choice)
    if not choice then
      return
    elseif choice.picker then
      Snacks.picker[choice.picker]({
        confirm = function(picker, item)
          picker:close()
          if item then
            set_base(item.branch or item.commit)
          end
        end,
      })
    else
      set_base(choice.rev)
    end
  end)
end

return {
  "lewis6991/gitsigns.nvim",
  opts = function()
    Snacks.toggle({
      name = "Git Review",
      get = function()
        return require("gitsigns.config").config.linehl
      end,
      set = function(state)
        local gs = require("gitsigns")
        gs.toggle_linehl(state)
        gs.toggle_word_diff(state)
        gs.toggle_deleted(state)
      end,
    }):map("<leader>gR")
  end,
  keys = {
    { "<leader>gV", pick_base, desc = "Git Review: Choose Diff Base" },
    {
      "<leader>gv",
      function()
        Snacks.picker.git_diff(base and { base = base } or { staged = false })
      end,
      desc = "Git Review: Hunks vs Base",
    },
  },
}
