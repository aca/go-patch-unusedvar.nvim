local patch = function()
    local patchtable = {}
    local count = 0
	for _, v in ipairs(vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })) do
		if v["code"] == "UnusedVar" then
            count = count + 1

            local cur_node = vim.treesitter.get_node({
                bufnr = 0,
                pos = {v.lnum, v.col},
                lang = "go",
            })

            if cur_node == nil then
                return 1
            end
            -- TODO: handle error cases
            local var_name = vim.treesitter.get_node_text(cur_node, 0, {})

            -- append line at the end of declaration
            local block = cur_node:parent():parent()
            if block == nil then
                return 1
            end
            local _, start_col  = block:start()
            local end_row  = block:end_()
            patchtable[count] = {end_row + 1, string.rep('\t', start_col) .. '_ = ' .. var_name}
		end
	end

    for k, v in pairs(patchtable) do
        vim.api.nvim_buf_set_lines(0, v[1] + k - 1, v[1] + k - 1, true, { v[2] })
    end
end

vim.api.nvim_create_user_command("GoPatchUnusedVar", function()
    patch()
end, {})

return patch
