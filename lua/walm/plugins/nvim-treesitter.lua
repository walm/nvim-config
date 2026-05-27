local ensure_installed = {
  "json",
  "javascript",
  "typescript",
  "tsx",
  "yaml",
  "html",
  "css",
  -- "prisma",
  "markdown",
  "markdown_inline",
  -- "svelte",
  -- "graphql",
  "bash",
  "sql", -- needed by cmp-dbee to parse queries
  "lua",
  "vim",
  "dockerfile",
  "gitignore",
  "query",
  "vimdoc",
  "c",
  "go",
  "ruby",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  config = function()
    local treesitter = require("nvim-treesitter")

    treesitter.setup()
    treesitter.install(ensure_installed)

    -- use bash parser for zsh files
    vim.treesitter.language.register("bash", "zsh")

    -- Neovim 0.12 provides the highlighter; nvim-treesitter main provides
    -- parsers/queries. Start highlighting for buffers that have a parser.
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local ok = pcall(vim.treesitter.start, args.buf)

        -- Treesitter-based indentation is still experimental, but this keeps
        -- the behavior from the old nvim-treesitter config for supported files.
        if ok then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
