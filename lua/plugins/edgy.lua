local opts = {
	left = {
		{ title = "Neotest Summary", ft = "neotest-summary" },
		-- "neo-tree",
	},
	right = {
		{ title = "Grug Far", ft = "grug-far", size = { width = 50 } },
	},
}

if LazyVim.has("neo-tree.nvim") then
	local pos = {
		filesystem = "left",
		buffers = "top",
		git_status = "right",
		document_symbols = "bottom",
		diagnostics = "bottom",
	}
	local sources = LazyVim.opts("neo-tree.nvim").sources or {}
	for i, v in ipairs(sources) do
		if v ~= "buffers" and v ~= "git_status" then -- skip buffers and git_status
			table.insert(opts.left, i, {
				title = "Neo-Tree " .. v:gsub("_", " "):gsub("^%l", string.upper),
				ft = "neo-tree",
				size = { width = 50 },
				filter = function(buf)
					return vim.b[buf].neo_tree_source == v
				end,
				pinned = true,
				open = function()
					vim.cmd(
						("Neotree show position=%s %s dir=%s"):format(pos[v] or "bottom", v, LazyVim.root())
					)
				end,
			})
		end
	end
end

-- trouble
for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
	opts[pos] = opts[pos] or {}
	table.insert(opts[pos], {
		ft = "trouble",
		size = (pos == "right" or pos == "left") and { width = 50 } or nil,
		filter = function(_buf, win)
			return vim.w[win].trouble
				and vim.w[win].trouble.position == pos
				and vim.w[win].trouble.type == "split"
				and vim.w[win].trouble.relative == "editor"
				and not vim.w[win].trouble_preview
		end,
	})
end

return {
	"folke/edgy.nvim",
	opts = opts,
}
