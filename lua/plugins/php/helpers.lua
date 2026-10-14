local M = {}

--- Functions for detecting ILIAS projects and configurations
--- @return boolean, string|nil: in_ilias?, ilias_root path
M.is_ilias_project = function()
	local ilias_markers = {
		"ilias.php",
		"ilias.ini.php",
	}

	local current_dir = vim.fn.getcwd()
	for _, marker in ipairs(ilias_markers) do
		if
			vim.fn.filereadable(current_dir .. "/" .. marker) == 1
			or vim.fn.isdirectory(current_dir .. "/" .. marker) == 1
		then
			return true, current_dir
		end
	end

	return false, nil
end

--- Function to get PHP version
--- @return string|nil: PHP version or nil if not found
M.php_version = function()
	local handle = io.popen("php -v 2>/dev/null")
	if handle then
		local result = handle:read("*a")
		handle:close()
		return result:match("PHP%s+(%d+%.%d+)")
	end

	vim.notify("No PHP executable found!")
	return nil
end

local function get_ilias_major_version(filepath)
	local file = io.open(filepath, "r")
	if not file then
		return nil
	end
	local last_line
	for line in file:lines() do
		last_line = line
	end
	file:close()
	if last_line then
		local major = last_line:match('ILIAS_VERSION_NUMERIC%s*=%s*"(%d+)%.%d+"')
		return major and tonumber(major) or nil
	end
	return nil
end

M.in_ilias, M.ilias_root = M.is_ilias_project()
M.phpstan_config = nil
M.phpstan_bin = "phpstan"
M.php_cs_fixer_bin = "php-cs-fixer"
M.php_cs_fixer_config = nil
M.phpcs_bin = "phpcs"
M.phpcs_standard = "PSR12"

if M.in_ilias then
	local major_version = get_ilias_major_version(M.ilias_root .. "/ilias_version.php")
	if not major_version then
		major_version = get_ilias_major_version(M.ilias_root .. "/include/inc.ilias_version.php")
	end

	M.composer_base = "/vendor"
	if major_version and major_version < 10 then
		M.composer_base = "/libs"
	end

	if vim.fn.filereadable(M.ilias_root .. "/../phpstan.neon") == 1 then
		M.phpstan_config = M.ilias_root .. "/../phpstan.neon"
	end

	if vim.fn.executable(M.ilias_root .. M.composer_base .. "/composer/vendor/bin/phpstan") == 1 then
		M.phpstan_bin = M.ilias_root .. M.composer_base .. "/composer/vendor/bin/phpstan"
	end

	if vim.fn.executable(M.ilias_root .. M.composer_base .. "/composer/vendor/bin/php-cs-fixer") == 1 then
		M.php_cs_fixer_bin = M.ilias_root .. M.composer_base .. "/composer/vendor/bin/php-cs-fixer"
	end

	if major_version and major_version < 10 then
		M.php_cs_fixer_config = M.ilias_root .. "/CI/PHP-CS-Fixer/code-format.php_cs"
	else
		M.php_cs_fixer_config = M.ilias_root .. "/scripts/PHP-CS-Fixer/code-format.php_cs"
	end

	if vim.fn.executable(M.ilias_root .. M.composer_base .. "/composer/vendor/bin/phpcs") == 1 then
		M.phpcs_bin = M.ilias_root .. M.composer_base .. "/composer/vendor/bin/phpcs"
	end

	local phpcs_up = M.ilias_root .. "/../phpcs.xml"
	local phpcs_captainhook = M.ilias_root .. M.composer_base .. "/composer/vendor/captainhook/captainhook/phpcs.xml"

	if vim.fn.filereadable(phpcs_up) == 1 then
		M.phpcs_standard = phpcs_up
	elseif vim.fn.filereadable(phpcs_captainhook) == 1 then
		M.phpcs_standard = phpcs_captainhook
	end
end

--- Laravel projects are detected by an `artisan` file in the cwd.
M.in_laravel = vim.fn.filereadable(vim.fn.getcwd() .. "/artisan") == 1

--- Minimum PHP version required by the project's composer.json ("^8.4" -> "8.4").
--- @return string|nil
M.project_php_version = function()
	local file = io.open(vim.fn.getcwd() .. "/composer.json", "r")
	if not file then
		return nil
	end
	local content = file:read("*a")
	file:close()
	local ok, json = pcall(vim.json.decode, content)
	if not ok or type(json.require) ~= "table" or type(json.require.php) ~= "string" then
		return nil
	end
	return json.require.php:match("(%d+%.%d+)")
end

--- Command prefix to run PHP tools inside the project's compose service, or nil
--- to run them on the host. Dockerized projects usually need a PHP version the
--- host does not have, and Larastan boots the app, so tools must run in there.
--- Override the service via `vim.g.laravel_php_service`.
M.laravel_exec = nil
M.laravel_container_root = "/app"

if M.in_laravel then
	local cwd = vim.fn.getcwd()
	for _, name in ipairs({ "compose.yaml", "compose.yml", "docker-compose.yaml", "docker-compose.yml" }) do
		local file = io.open(cwd .. "/" .. name, "r")
		if file then
			local content = file:read("*a")
			file:close()
			local service = vim.g.laravel_php_service
			if not service then
				if content:find("\n%s+laravel%.test:") then
					-- Laravel Sail
					service = "laravel.test"
					M.laravel_container_root = "/var/www/html"
				elseif content:find("\n%s+app:") then
					service = "app"
				end
			end
			if service then
				M.laravel_exec = { "docker", "compose", "exec", "-T", service }
			end
			break
		end
	end
end

--- Builds a command that runs `bin` (relative to the project root) on the host
--- or inside the compose service.
--- @param bin string
--- @return string cmd, string[] prefix_args
M.laravel_cmd = function(bin)
	if M.laravel_exec then
		local prefix = vim.list_slice(M.laravel_exec, 2)
		table.insert(prefix, bin)
		return M.laravel_exec[1], prefix
	end
	return vim.fn.getcwd() .. "/" .. bin, {}
end

--- Path of a buffer relative to the project root, as seen by the container.
--- @param path string
--- @return string
M.relative_path = function(path)
	return vim.fn.fnamemodify(path, ":.")
end

return M
