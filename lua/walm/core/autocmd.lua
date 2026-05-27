vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    -- optional extras:
    -- vim.opt_local.linebreak = true
    -- vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  pattern = "*.ts",
  callback = function()
    vim.bo.filetype = "typescriptreact"
  end,
})

-- Restore the last cursor position when reopening a file (uses the `"` mark,
-- persisted across sessions via shada). Skips commit messages and out-of-range marks.
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    if ft == "gitcommit" or ft == "gitrebase" then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
