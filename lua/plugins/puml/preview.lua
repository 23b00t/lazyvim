--- Live browser preview for PlantUML buffers.
---
--- The buffer content is piped through `plantuml -pipe`, so output file names
--- (`@startuml <name>`), multiple diagrams per file and unsaved changes are all
--- handled by PlantUML itself. The rendered SVGs are written as a JS payload next
--- to a static HTML page, which polls the payload and swaps the diagrams in place.
local M = {}

local DELIMITER = "<!--PLANTUML-PREVIEW-DELIMITER-->"

--- @class PlantumlPreviewOpts
--- @field output_dir string Directory for the preview pages (must be readable by the browser)
--- @field poll_interval integer Reload check interval of the preview page in ms
M.opts = {
  -- Shared with the flatpak override of the browser, /tmp is private inside flatpaks.
  output_dir = vim.fn.expand("~/.cache/plantuml-previewer"),
  poll_interval = 500,
}

--- @class PlantumlPreviewState
--- @field id string File name stem of the preview page
--- @field version integer Incremented per render, used to drop stale results

--- @type table<integer, PlantumlPreviewState>
local previews = {}

--- @param msg string
--- @param level? integer
local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = "PlantUML" })
end

--- @return boolean
local function check_plantuml()
  if vim.fn.executable("plantuml") == 1 then
    return true
  end
  notify("`plantuml` not found in PATH", vim.log.levels.ERROR)
  return false
end

--- Write a file via rename, so the browser never reads a half written payload.
--- @param path string
--- @param content string
local function write_atomic(path, content)
  local tmp = path .. ".tmp"
  local file = assert(io.open(tmp, "w"))
  file:write(content)
  file:close()
  assert(vim.uv.fs_rename(tmp, path))
end

--- @param id string
--- @param ext string
--- @return string
local function page_path(id, ext)
  return M.opts.output_dir .. "/" .. id .. "." .. ext
end

--- Split `plantuml -pipe` stdout into one SVG per diagram.
--- Diagrams with syntax errors are rendered by PlantUML as an error image.
--- @param stdout string
--- @return string[]
local function parse_diagrams(stdout)
  local diagrams = {}
  for chunk in stdout:gmatch("(.-)" .. vim.pesc(DELIMITER)) do
    local svg = chunk:match("<svg.*</svg>")
    if svg then
      table.insert(diagrams, svg)
    end
  end
  return diagrams
end

--- Collect syntax errors, reported on stderr as "ERROR\n<line>\n<message>".
--- The line is relative to the failing diagram, not to the file.
--- @param stderr string
--- @return string[]
local function parse_errors(stderr)
  local errors = {}
  for line, message in stderr:gmatch("ERROR%s*\n(%d+)%s*\n([^\n]*)") do
    table.insert(errors, ("Line %s of diagram: %s"):format(line, vim.trim(message)))
  end
  return errors
end

--- @param id string
--- @param title string
local function write_page(id, title)
  local html = [[
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>__TITLE__</title>
<style>
  body { margin: 0; font-family: sans-serif; background: #f4f4f5; color: #18181b; }
  header { position: sticky; top: 0; padding: 6px 16px; background: #27272a; color: #e4e4e7; font-size: 13px; }
  header.error { background: #b91c1c; color: #fff; }
  header pre { margin: 4px 0 0; font: inherit; white-space: pre-wrap; }
  main { padding: 16px; }
  .diagram { margin-bottom: 24px; padding: 16px; background: #fff; border-radius: 6px; overflow: auto; }
</style>
</head>
<body>
<header id="status">Rendering __TITLE__ …</header>
<main id="diagrams"></main>
<script>
  let version = null;
  window.plantumlPreview = (data) => {
    if (data.version === version) return;
    version = data.version;
    const status = document.getElementById("status");
    status.className = data.errors.length ? "error" : "";
    status.textContent = data.title + " · " + data.updated;
    if (data.errors.length) {
      const pre = document.createElement("pre");
      pre.textContent = data.errors.join("\n");
      status.append(pre);
    }
    document.getElementById("diagrams").replaceChildren(...data.diagrams.map((svg) => {
      const el = document.createElement("section");
      el.className = "diagram";
      el.innerHTML = svg;
      return el;
    }));
  };
  // file:// forbids fetch(), but loading a sibling script is allowed.
  (function poll() {
    const script = document.createElement("script");
    script.src = "__ID__.js?" + Date.now();
    script.onload = script.onerror = () => {
      script.remove();
      setTimeout(poll, __INTERVAL__);
    };
    document.head.append(script);
  })();
</script>
</body>
</html>
]]
  local escaped_title = title:gsub("[<>&]", { ["<"] = "&lt;", [">"] = "&gt;", ["&"] = "&amp;" })
  -- Function replacements, so "%" in the values is not interpreted by gsub.
  html = html
    :gsub("__TITLE__", function()
      return escaped_title
    end)
    :gsub("__ID__", function()
      return id
    end)
    :gsub("__INTERVAL__", tostring(M.opts.poll_interval))
  write_atomic(page_path(id, "html"), html)
end

--- Render the buffer content and update the preview payload.
--- @param bufnr integer
local function render(bufnr)
  local preview = previews[bufnr]
  if not preview then
    return
  end
  preview.version = preview.version + 1
  local version = preview.version

  local name = vim.api.nvim_buf_get_name(bufnr)
  local text = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n") .. "\n"

  vim.system(
    { "plantuml", "-pipe", "-tsvg", "-charset", "UTF-8", "-pipedelimitor", DELIMITER },
    -- cwd makes relative !include paths resolve like for the file itself
    { stdin = text, cwd = vim.fn.fnamemodify(name, ":p:h"), text = true },
    vim.schedule_wrap(function(result)
      -- Preview stopped or a newer render was started meanwhile.
      if not previews[bufnr] or previews[bufnr].version ~= version then
        return
      end

      local stderr = result.stderr or ""
      local diagrams = parse_diagrams(result.stdout or "")
      local errors = parse_errors(stderr)
      if #diagrams == 0 and #errors == 0 then
        local message = vim.trim(stderr)
        table.insert(errors, message ~= "" and message or "No diagram found (missing @startuml?)")
      end
      if #errors > 0 then
        notify(table.concat(errors, "\n"), vim.log.levels.WARN)
      end

      local payload = vim.json.encode({
        version = version,
        title = vim.fn.fnamemodify(name, ":t"),
        updated = os.date("%H:%M:%S"),
        diagrams = diagrams,
        errors = errors,
      })
      write_atomic(page_path(preview.id, "js"), "window.plantumlPreview(" .. payload .. ");\n")
    end)
  )
end

--- Stop the preview of a buffer.
--- @param bufnr? integer
function M.stop(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local preview = previews[bufnr]
  if not preview then
    return
  end
  previews[bufnr] = nil
  pcall(vim.api.nvim_del_augroup_by_name, "PlantumlPreview" .. bufnr)
  pcall(vim.uv.fs_unlink, page_path(preview.id, "js"))
  pcall(vim.uv.fs_unlink, page_path(preview.id, "html"))
end

--- Open the browser preview for a buffer, re-rendering on every write.
--- @param bufnr? integer
function M.open(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if not check_plantuml() then
    return
  end

  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then
    notify("Buffer has no file name", vim.log.levels.ERROR)
    return
  end

  if not previews[bufnr] then
    vim.fn.mkdir(M.opts.output_dir, "p")
    -- Readable name plus a hash, so equally named files in different dirs don't clash.
    local id = vim.fn.fnamemodify(name, ":t:r"):gsub("[^%w_-]", "_") .. "-" .. vim.fn.sha256(name):sub(1, 8)
    previews[bufnr] = { id = id, version = 0 }
    write_page(id, vim.fn.fnamemodify(name, ":t"))

    local group = vim.api.nvim_create_augroup("PlantumlPreview" .. bufnr, { clear = true })
    vim.api.nvim_create_autocmd("BufWritePost", {
      group = group,
      buffer = bufnr,
      callback = function()
        render(bufnr)
      end,
    })
    vim.api.nvim_create_autocmd({ "BufWipeout", "BufDelete" }, {
      group = group,
      buffer = bufnr,
      callback = function()
        M.stop(bufnr)
      end,
    })
  end

  render(bufnr)
  vim.ui.open(page_path(previews[bufnr].id, "html"))
end

--- @param bufnr? integer
function M.toggle(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if previews[bufnr] then
    M.stop(bufnr)
  else
    M.open(bufnr)
  end
end

--- Export the diagrams of the current file next to it, named like PlantUML does.
--- @param format? string "svg" (default) or "png"
function M.export(format)
  format = format or "svg"
  if not check_plantuml() then
    return
  end
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.bo[bufnr].modified then
    notify("Write the buffer before exporting", vim.log.levels.WARN)
    return
  end
  local name = vim.api.nvim_buf_get_name(bufnr)
  vim.system({ "plantuml", "-t" .. format, "-charset", "UTF-8", name }, { text = true }, function(result)
    vim.schedule(function()
      if result.code == 0 then
        notify("Exported " .. format .. " to " .. vim.fn.fnamemodify(name, ":~:h"))
      else
        notify("Export failed:\n" .. vim.trim((result.stderr or "") .. (result.stdout or "")), vim.log.levels.ERROR)
      end
    end)
  end)
end

--- @param opts? PlantumlPreviewOpts
function M.setup(opts)
  M.opts = vim.tbl_extend("force", M.opts, opts or {})

  vim.api.nvim_create_user_command("PlantumlPreview", function()
    M.open()
  end, { desc = "Open PlantUML browser preview" })
  vim.api.nvim_create_user_command("PlantumlPreviewStop", function()
    M.stop()
  end, { desc = "Stop PlantUML browser preview" })
  vim.api.nvim_create_user_command("PlantumlExport", function(args)
    M.export(args.fargs[1])
  end, {
    nargs = "?",
    complete = function()
      return { "svg", "png" }
    end,
    desc = "Export PlantUML diagrams next to the file",
  })
end

return M
