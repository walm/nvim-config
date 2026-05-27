return {
  {
    "kndndrj/nvim-dbee",
    dependencies = { "MunifTanjim/nui.nvim" },
    build = function()
      require("dbee").install()
    end,
    cmd = "Dbee",
    keys = {
      { "<leader>D", function() require("dbee").toggle() end, desc = "Toggle Dbee (database)" },
    },
    config = function()
      local sources = require("dbee.sources")

      -- project-local: <root>/.dbee.json (editable/persisted via the dbee UI)
      local root = vim.fs.root(0, { ".git", ".dbee.json" }) or vim.fn.getcwd()
      local project_file = root .. "/.dbee.json"

      -- global: merge every *.json under ~/.config/dbee/connections/ (read-only)
      local function load_global()
        local dir = vim.fn.expand("~/.config/dbee/connections")
        local conns = {}
        for _, f in ipairs(vim.fn.glob(dir .. "/*.json", false, true)) do
          local ok, data = pcall(function()
            return vim.json.decode(table.concat(vim.fn.readfile(f), "\n"))
          end)
          if ok and type(data) == "table" then
            vim.list_extend(conns, data)
          else
            vim.notify("dbee: skipping invalid connections file " .. f, vim.log.levels.WARN)
          end
        end
        return conns
      end

      require("dbee").setup({
        sources = {
          sources.MemorySource:new(load_global()), -- global, read-only
          sources.FileSource:new(project_file),    -- project, editable/persisted
        },
      })
    end,
  },

  -- Completion source for dbee scratchpads (tables/columns/schemas).
  -- It is an nvim-cmp source; blink consumes it via blink.compat (see blink.lua).
  -- Loads on the `sql` filetype, which is what dbee editor buffers use.
  {
    "MattiasMTS/cmp-dbee",
    dependencies = { "kndndrj/nvim-dbee" },
    ft = "sql",
    opts = {},
  },
}
