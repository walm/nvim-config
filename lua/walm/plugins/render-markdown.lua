return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- parses the markdown (markdown + markdown_inline already installed)
    { "nvim-mini/mini.icons", version = "*", opts = {} }, -- icon provider for the rendered output
  },
  ft = { "markdown" },
  ---@module "render-markdown"
  ---@type render.md.UserConfig
  opts = {
    -- in-process LSP that completes link references, checkboxes, callouts, etc.
    completions = { lsp = { enabled = true } },
  },
}
