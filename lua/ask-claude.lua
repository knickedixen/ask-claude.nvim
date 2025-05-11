local state = {
	win = -1,
	buf = -1,
}

local function table_to_string(var)
	if type(var) == "table" then
		local s = "{"
		for k, v in pairs(var) do
			if type(k) ~= "number" then
				k = '"' .. k .. '"'
			end
			s = s .. "[" .. k .. "]=" .. table_to_string(v) .. ","
		end
		return s .. "}"
	else
		return tostring(var)
	end
end

local function current_line_diagnostics()
	local bufnr = 0
	local line_nr = vim.api.nvim_win_get_cursor(0)[1] - 1
	local opts = { ["lnum"] = line_nr }
	return vim.diagnostic.get(bufnr, opts)
end

local M = {}

M.open_claude_window = function(win, buf)
	if not vim.api.nvim_buf_is_valid(state.buf) then
		buf = vim.api.nvim_create_buf(false, true)
	end

	if not vim.api.nvim_win_is_valid(win) then
		local width = math.floor(vim.o.columns * 0.8)
		local height = math.floor(vim.o.lines * 0.8)
		local col = math.floor((vim.o.columns - width) / 2)
		local row = math.floor((vim.o.lines - height) / 2)

		local win_config = {
			relative = "editor",
			width = width,
			height = height,
			col = col,
			row = row,
			style = "minimal",
			border = "rounded",
		}

		win = vim.api.nvim_open_win(buf, true, win_config)
	end

	if vim.bo[buf].buftype ~= "terminal" then
		vim.cmd.terminal("claude")
	end

	return { win = win, buf = buf }
end

M.toggle_claude = function()
	if not vim.api.nvim_win_is_valid(state.win) then
		state = M.open_claude_window(state.win, state.buf)
	else
		vim.api.nvim_win_hide(state.win)
		-- Refresh buffers when claude closes
		vim.cmd("checktime")
	end
end

M.ask_claude = function(prompt)
	M.toggle_claude()

	local prompt_string = ""
	for k, v in pairs(prompt) do
		prompt_string = prompt_string .. v .. "\n"
	end
	vim.fn.feedkeys(prompt_string)
end

M.ask_claude_context = function(context)
	local file_path = vim.fn.expand("%")

	local prompt = {}
	table.insert(prompt, "File: " .. file_path)
	local line1 = context.line1
	local line2 = context.line2

	local mode = vim.api.nvim_get_mode().mode
	if mode == "v" or mode == "V" or mode == "\22" then
		-- HACK: Focre exit visual mode in order to get the selection, othwerwise we get the previous one...
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "x", true)
		local start_pos = vim.fn.getpos("'<")
		local end_pos = vim.fn.getpos("'>")
		line1 = start_pos[2]
		line2 = end_pos[2]
	end

	if line1 ~= line2 then
		table.insert(prompt, "From line " .. line1 .. " to " .. line2)
	else
		table.insert(prompt, "At line: " .. line1)
	end

	M.ask_claude(prompt)
end

M.ask_claude_diagnostics = function(context)
	local curr_diag = current_line_diagnostics()
	local file_path = vim.fn.expand("%")
	local prompt = {}

	if next(curr_diag) == nil then
		print("No diagnostics found, skipping...")
		return
	end

	table.insert(prompt, "File: " .. file_path)
	table.insert(prompt, "Line number: " .. context.line1)
	table.insert(prompt, table_to_string(curr_diag))
	table.insert(prompt, "Explain these vim diagnostics")

	M.ask_claude(prompt)
end

return M
