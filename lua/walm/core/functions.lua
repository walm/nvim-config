
vim.api.nvim_create_user_command("StripTrailingWhitespace", function()
    -- Save cursor position
    local curpos = vim.api.nvim_win_get_cursor(0)
    -- Run the substitution on the whole buffer
    vim.cmd([[%s/\s\+$//e]])
    -- Restore cursor position
    vim.api.nvim_win_set_cursor(0, curpos)
end, { desc = "Remove trailing whitespace in current buffer" })
