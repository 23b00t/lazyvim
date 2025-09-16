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

	if vim.fn.filereadable(M.ilias_root .. "../phpstan.neon") == 1 then
		M.phpstan_config = M.ilias_root .. "/../phpstan.neon"
	end

	if vim.fn.executable(M.ilias_root .. M.composer_base .. "/composer/vendor/bin/phpstan") == 1 then
		M.phpstan_bin = M.ilias_root .. M.composer_base .. "/composer/vendor/bin/phpstan"
	end

	if vim.fn.executable(M.ilias_root .. M.composer_base .. "/composer/vendor/bin/php-cs-fixer") == 1 then
		M.php_cs_fixer_bin = M.ilias_root .. M.composer_base .. "/composer/vendor/bin/php-cs-fixer"
	end

	if vim.fn.filereadable(M.ilias_root .. "/CI/PHP-CS-FIXER/code-format.php_cs") == 1 then
		M.php_cs_fixer_config = "--config=" .. M.ilias_root .. "/CI/PHP-CS-FIXER/code-format.php_cs"
	end

	if vim.fn.executable(M.ilias_root .. M.composer_base .. "/composer/vendor/bin/phpcs") == 1 then
		M.phpcs_bin = M.ilias_root .. M.composer_base .. "/composer/vendor/bin/phpcs"
	end

	if
		vim.fn.filereadable(M.ilias_root .. M.composer_base .. "/composer/vendor/captainhook/captainhook/phpcs.xml")
		== 1
	then
		-- M.phpcs_standard = M.ilias_root .. M.composer_base .. "/composer/vendor/captainhook/captainhook/phpcs.xml"
		M.phpcs_standard = M.ilias_root .. "/../phpcs.xml"
	end
end

return M
