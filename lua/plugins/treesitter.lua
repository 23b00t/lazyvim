return {
	{
		"nvim-treesitter/nvim-treesitter",
		config = function(_, opts)
			-- Ursprüngliche TreeSitter-Konfiguration beibehalten
			require("nvim-treesitter.configs").setup(opts)

			-- Dedizierte autocommand-Gruppe für PHP-Indentation-Fix
			local group = vim.api.nvim_create_augroup("PHPIndentFix", { clear = true })

			vim.api.nvim_create_autocmd("FileType", {
				group = group,
				pattern = "php",
				callback = function()
					-- Verzögerung, um sicherzustellen, dass unsere Einstellungen nach
					-- allen anderen Initialisierungen angewendet werden
					vim.defer_fn(function()
						-- Nur das TreeSitter-Indenting deaktivieren, nicht die ganze Funktionalität
						vim.bo.indentexpr = "" -- Entferne das TreeSitter Indent-Expression
						vim.bo.autoindent = true
						vim.bo.cindent = false
						vim.bo.smartindent = true
            vim.bo.shiftwidth = 4
					end, 10)
				end,
			})
		end,
	},
}
