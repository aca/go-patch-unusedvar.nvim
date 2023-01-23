local i = vim.pretty_print
vim.api.nvim_create_user_command("GoPatchUnusedVar", function()
	local buf = 0
	for _, v in ipairs(vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.ERROR })) do
		if v["code"] == "UnusedVar" then
            local nod = vim.treesitter.get_node_at_pos(buf, v.lnum, v.col, { lang = "go" })
            local var_name = vim.treesitter.query.get_node_text(nod, 0, {})

            -- "append line at the end of declaration"
            local end_row  = nod:parent():parent():end_()
			vim.api.nvim_buf_set_lines(buf, end_row + 1, end_row + 1, true, { '_ = ' .. var_name })

            vim.lsp.buf.format()
		end
	end
end, {})
