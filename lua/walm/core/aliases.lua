vim.cmd("command! Git Neogit")

-- Don't make mistakes, there are no such thing :)
vim.cmd("command! -nargs=* W w")
vim.cmd("command! -nargs=* Wq wq")
vim.cmd("command! -nargs=* WQ wq")
vim.cmd("command! -nargs=* Q q")
vim.cmd("command! -nargs=* Qa qa")
vim.cmd("command! -nargs=* QA qa")
