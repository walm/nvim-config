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
