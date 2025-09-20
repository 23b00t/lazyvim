local helpers = require("plugins.php.helpers")

return {
	"neovim/nvim-lspconfig",
	dependencies = { "mason-org/mason-lspconfig.nvim" },
	opts = function(_, opts)
		opts.servers.phpactor = false
		-- manual setup
		local lspconfig = require("lspconfig")
		lspconfig.intelephense.setup({
			filetypes = { "php" },
			root_dir = function(_)
				-- force to cwd
				return vim.loop.fs_realpath(vim.fn.getcwd())
			end,
			settings = {
				intelephense = {
					references = {
						codeLens = {
							enabled = true,
						},
					},
					implementations = {
						codeLens = {
							enabled = true,
						},
					},

					stubs = {
						"apache",
						"bcmath",
						"bz2",
						"calendar",
						"com_dotnet",
						"Core",
						"curl",
						"date",
						"dba",
						"dom",
						"enchant",
						"fileinfo",
						"filter",
						"fpm",
						"ftp",
						"gd",
						"gettext",
						"gmp",
						"hash",
						"iconv",
						"imap",
						"intl",
						"json",
						"ldap",
						"libxml",
						"mbstring",
						"mysqli",
						"oci8",
						"odbc",
						"openssl",
						"pcntl",
						"pcre",
						"PDO",
						"pdo_ibm",
						"pdo_mysql",
						"pdo_pgsql",
						"pdo_sqlite",
						"pgsql",
						"Phar",
						"posix",
						"pspell",
						"readline",
						"Reflection",
						"session",
						"shmop",
						"SimpleXML",
						"snmp",
						"soap",
						"sockets",
						"sodium",
						"SPL",
						"sqlite3",
						"standard",
						"superglobals",
						"sysvmsg",
						"sysvsem",
						"sysvshm",
						"tidy",
						"tokenizer",
						"xml",
						"xmlreader",
						"xmlrpc",
						"xmlwriter",
						"xsl",
						"Zend OPcache",
						"zip",
						"zlib",
					},
					telemetry = { enable = false },
					files = {
						exclude = {
							"**/.git/**",
							"**/.svn/**",
							"**/.hg/**",
							"**/CVS/**",
							"**/.DS_Store/**",
							"**/node_modules/**",
							"**/bower_components/**",
						},
						maxSize = 20000000,
					},

					environment = {
						phpVersion = helpers.php_version() or "8.1",
						-- TODO: Add more path?
						includePaths = {
							"Services",
							"Modules",
							"libs",
							"src",
							"components",
							"vendor",
							"Customizing/global/plugins",
							"setup",
						},
					},

					-- Der Rest der Einstellungen bleibt wie gehabt
					diagnostics = {
						enable = true,
						run = "onSave",
						deprecated = true,
						undefinedSymbols = true,
						undefinedVariables = true,
						undefinedProperties = true,
						undefinedMethods = true,
						unusedSymbols = true,
						nonexistentFile = true,
						caseSensitive = true,
						strictTypes = true,
						strictKeyCheck = true,
						duplicateSymbols = true,
					},
					completion = {
						enable = true,
						triggerParameterHints = true,
						insertUseDeclaration = true,
						fullyQualifyGlobalConstants = true,
						fullyQualifyGlobalFunctions = true,
						phpdoc = { enable = true, text = true },
						quickPick = { enable = true },
					},
					format = { enable = true, braces = "psr12" },
					rename = { enable = true },
				},
			},
		})
		return opts
	end,
}
