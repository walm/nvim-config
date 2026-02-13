vim.api.nvim_create_user_command("StripTrailingWhitespace", function()
  -- Save cursor position
  local curpos = vim.api.nvim_win_get_cursor(0)
  -- Run the substitution on the whole buffer
  vim.cmd([[%s/\s\+$//e]])
  -- Restore cursor position
  vim.api.nvim_win_set_cursor(0, curpos)
end, { desc = "Remove trailing whitespace in current buffer" })

vim.api.nvim_create_user_command("CopyGitRelativePath", function()
  local filepath = vim.fn.expand("%:p")

  if filepath == "" then
    print("No file in current buffer")
    return
  end

  local dir = vim.fn.expand("%:p:h")
  local handle = io.popen("git -C " .. vim.fn.shellescape(dir) .. " rev-parse --show-toplevel 2>/dev/null")
  local gitroot = handle:read("*l")
  handle:close()

  if gitroot and gitroot ~= "" then
    -- Escape special pattern characters in gitroot
    local escaped_root = gitroot:gsub("([^%w])", "%%%1")
    local relpath = filepath:gsub("^" .. escaped_root .. "/", "")
    vim.fn.setreg("+", relpath)
    print("Copied (git-relative): " .. relpath)
  else
    vim.fn.setreg("+", filepath)
    print("Copied (full path): " .. filepath)
  end
end, { desc = "Copy git-relative path" })
