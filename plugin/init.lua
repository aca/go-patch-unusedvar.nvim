vim.api.nvim_create_user_command("GoPatchUnusedVar", function()
	local buf = 0
	for _, v in ipairs(vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.ERROR })) do
		if v["code"] == "UnusedVar" then
			local end_lnum = v["end_lnum"]
			local msg = v["message"]
			local unusedVar = string.match(msg, "^%S+")
			local lineString = vim.api.nvim_buf_get_lines(buf, end_lnum, end_lnum + 1, false)[1]
			lineString = lineString .. "; _ = " .. unusedVar
			vim.api.nvim_buf_set_lines(buf, end_lnum, end_lnum + 1, false, { lineString })
		end
	end
end, {})
