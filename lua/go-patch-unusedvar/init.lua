vim.api.nvim_create_user_command("GoPatchUnusedVar", function()
	local buf = 0
	for _, v in ipairs(vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.ERROR })) do
		if v["code"] == "UnusedVar" then
            local cur_node = vim.treesitter.get_node({
                bufnr = buf,
                pos = {v.lnum, v.col},
                lang = "go",
            })

            -- TODO: handle error cases
            local var_name = vim.treesitter.query.get_node_text(cur_node, 0, {})

            -- append line at the end of declaration
            local block = cur_node:parent():parent()
            local _, start_col  = block:start()
            local end_row  = block:end_()
			vim.api.nvim_buf_set_lines(buf, end_row + 1, end_row + 1, true, { string.rep(' ', start_col) .. '_ = ' .. var_name })

            -- FORMAT on end?
            -- vim.lsp.buf.format()
		end
	end
end, {})
