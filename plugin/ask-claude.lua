local M = require("ask-claude")

vim.api.nvim_create_user_command("AskClaude", M.toggle_claude, {})
vim.api.nvim_create_user_command("AskClaudeContext", M.ask_claude_context, { range = true })
vim.api.nvim_create_user_command("AskClaudeDiagnostics", M.ask_claude_diagnostics, { range = true })

-- Make sure we update buffers when leaving a terminal, in case claude has changed files
vim.api.nvim_create_autocmd({
	"TermLeave",
}, {
	pattern = "*",
	callback = function()
		vim.cmd("checktime")
	end,
})
