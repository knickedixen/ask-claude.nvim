local M = require("ask-claude")

vim.api.nvim_create_user_command("AskClaude", M.open_claude, {})
vim.api.nvim_create_user_command("AskClaudeExplain", M.ask_claude_explain, { range = true })
vim.api.nvim_create_user_command("AskClaudeDiagnostics", M.ask_claude_diagnostics, { range = true })
