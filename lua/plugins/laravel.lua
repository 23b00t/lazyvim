--[[
Laravel: Blade support plus laravel.nvim. PHP tooling (pint, phpstan,
intelephense) lives in lua/plugins/php/*. Usage notes: ~/org/laravel.md

laravel.nvim is only loaded in Laravel projects (cwd contains `artisan`).
All artisan/composer/npm calls run inside the compose service
(`docker compose exec -T app ...`), paths are mapped back to the host.

Keybindings (<localleader> = "\", so e.g. `\Lr`):

  \Ll  Laravel picker   Searchable list of every laravel.nvim command - use it
                        when you forgot a binding.
  \La  Artisan          All `php artisan` commands with their usage; selecting
                        one prompts for arguments and runs it in the container.
  \Lr  Routes           `route:list` as a picker (method, URI, middleware);
                        <CR> opens the controller at the handling method.
  \Lm  Make             Only the `make:*` generators (model, controller,
                        migration, request, ...); opens the created file.
  \Lo  Resources        Jump into project folders by kind: Controllers, Models,
                        Migrations, Policies, ...
  \LR  Related          In a model: its relations, observers and policy.
  \Lc  Custom commands  The `user_commands` below (`composer ide-helper`,
                        `migrate:fresh --seed`).
  \LH  History          Every command run through laravel.nvim, re-runnable.
  \Lt  Code actions     Context actions for the current file, e.g. on a model:
                        generate `$fillable` from the real columns, add a
                        relation, go to its migration; on an event: create
                        a listener.
  \Lu  Artisan Hub      Tabbed terminal with long-running commands: `pail`
                        (live application log) and the laravel.log tail.
                        Inside: q close, <Tab> next tab, r restart, s stop,
                        a add tab, d delete tab.
  \Lp  Command Center   Prompt with completion for `artisan ...` /
                        `composer ...` commands and a usage preview.
  \Lk  Tinker           Opens a `.tinker` scratch file next to its result;
                        <CR> runs it in the container (Eloquent results are
                        rendered as tables, queries with SQL + bindings).
  \Lv  View finder      In a Blade file: who renders this view; in PHP: jump
                        to a `view('...')` used in this file.
  gf   Go to resource   On `route('name')`, `view('x')`, `Inertia::render('Page')`,
                        `config('a.b')` or `env('KEY')` jump to the definition;
                        anywhere else it is the normal `gf`.

Passive features (no key needed): model info above Eloquent models
(table + columns), route info above controller methods, diagnostics for
missing views/Inertia pages and routes without a controller method,
completion for route/view/config/env/Inertia names and model columns.
]]
local helpers = require("plugins.php.helpers")

vim.filetype.add({
  pattern = {
    [".*%.blade%.php"] = "blade",
  },
})

--- laravel.nvim environment matching the project: inside the compose service
--- when there is one (host PHP is usually the wrong version), otherwise local.
local function environments()
  if not helpers.laravel_exec then
    return { default = "local", ask_on_boot = false }
  end

  -- `-T` instead of the plugin's `-it`: most calls are background jobs without a TTY.
  local function exec(bin)
    local cmd = vim.deepcopy(helpers.laravel_exec)
    table.insert(cmd, bin)
    return cmd
  end

  return {
    default = "project-container",
    ask_on_boot = false,
    definitions = {
      {
        name = "project-container",
        map = {
          php = exec("php"),
          composer = exec("composer"),
          npm = exec("npm"),
        },
      },
      { name = "local" },
    },
  }
end

local function run(command)
  return function()
    Laravel.commands.run(command)
  end
end

local function pick(picker)
  return function()
    Laravel.pickers[picker]()
  end
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "blade", "php_only" } },
  },
  {
    "adalessa/laravel.nvim",
    -- Only in Laravel projects, so ILIAS and other PHP projects stay untouched.
    cond = helpers.in_laravel,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
    },
    ft = { "php", "blade" },
    event = { "BufEnter composer.json" },
    cmd = { "Laravel" },
    -- On <localleader> so LazyVim's <leader> bindings stay intact.
    keys = {
      { "<localleader>L", "", desc = "+laravel" },
      { "<localleader>Ll", pick("laravel"), desc = "Laravel Picker" },
      { "<localleader>La", pick("artisan"), desc = "Artisan" },
      { "<localleader>Lr", pick("routes"), desc = "Routes" },
      { "<localleader>Lm", pick("make"), desc = "Make" },
      { "<localleader>Lo", pick("resources"), desc = "Resources" },
      { "<localleader>LR", pick("related"), desc = "Related (Model)" },
      { "<localleader>Lc", pick("commands"), desc = "Custom Commands" },
      { "<localleader>LH", pick("history"), desc = "Command History" },
      { "<localleader>Lt", run("actions"), desc = "Code Actions" },
      { "<localleader>Lu", run("hub"), desc = "Artisan Hub" },
      { "<localleader>Lp", run("command_center"), desc = "Command Center" },
      { "<localleader>Lk", run("tinker:open"), desc = "Tinker" },
      { "<localleader>Lv", run("view:finder"), desc = "View Finder" },
      {
        "gf",
        function()
          if Laravel.app("gf").cursorOnResource() then
            return "<cmd>lua Laravel.commands.run('gf')<cr>"
          end
          return "gf"
        end,
        expr = true,
        noremap = true,
        ft = { "php", "blade" },
        desc = "Laravel: Go to resource",
      },
    },
    opts = {
      features = {
        -- snacks is the only provider besides telescope with the master picker.
        pickers = { provider = "snacks" },
      },
      environments = environments(),
      extensions = {
        artisan_hub = {
          -- App server and Vite already run as compose services.
          commands = {
            { name = "Pail", cmd = "artisan pail --timeout=0" },
            { name = "Logs", class = "laravel.extensions.artisan_hub.log_command" },
          },
        },
      },
      user_commands = {
        composer = {
          ["ide-helper"] = { cmd = { "ide-helper" }, desc = "Regenerate IDE helper files" },
        },
        artisan = {
          ["migrate:fresh --seed"] = {
            cmd = { "migrate:fresh", "--seed" },
            desc = "Drop, re-migrate and seed the database",
          },
        },
      },
    },
  },
}
