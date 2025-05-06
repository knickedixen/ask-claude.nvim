# Ask-claude.nvim
Ask-claude is a simple plugin integrating [claude-code](https://github.com/anthropics/claude-code) with neovim. It does this by setting up a few user commands that opens claude in a floating terminal with a prepared prompt that containts context of which file and line the user is currently looking at.

## Requirements
[claude-code](https://github.com/anthropics/claude-code) installed and available in PATH.

## Commands
`:AskClaude` Opens claude in a floatint terminal without any prompt

`:AskClaudeExplain` Asks claude to explain the current line or selection of lines

`:AskClaudeDiagnostics` Asks claude to explain the diagnostics found on the current line

## Installation
### Using [lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
  {
    'knickedixen/ask-claude.nvim',
    -- Example key bindings
    config = function()
      vim.keymap.set('n', '<leader>ac', '<cmd>AskClaude<CR>')
      vim.keymap.set('v', '<leader>ac', '<cmd>AskClaude<CR>')
      vim.keymap.set('n', '<leader>ae', '<cmd>AskClaudeExplain<CR>')
      vim.keymap.set('v', '<leader>ae', '<cmd>AskClaudeExplain<CR>')
      vim.keymap.set('n', '<leader>ad', '<cmd>AskClaudeDiagnostics<CR>')
      vim.keymap.set('v', '<leader>ad', '<cmd>AskClaudeDiagnostics<CR>')
    end,
  },
```
