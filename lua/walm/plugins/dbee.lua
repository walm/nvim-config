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

      -- Extend (not replace) the default drawer mappings. dbee merges config with
      -- tbl_deep_extend("force", ...), which merges list tables by index, so we
      -- start from the defaults and append our extra keys.
      local drawer_mappings = vim.deepcopy(require("dbee.config").default.drawer.mappings)
      vim.list_extend(drawer_mappings, {
        { key = "e", mode = "n", action = "action_2" },
        { key = "h", mode = "n", action = "collapse" },
        { key = "l", mode = "n", action = "expand" },
      })

      -- Display-only entries: dbee builds the drawer help node from any mapping
      -- whose action is a string, but only *binds* a key when the action resolves
      -- to a real drawer action. These yank keys live on the result buffer, so
      -- they show up as a cheat-sheet in the help node without being bound here.
      vim.list_extend(drawer_mappings, {
        { key = "yaj", mode = "n", action = "[res] yank row as JSON" },
        { key = "yac", mode = "n", action = "[res] yank row as CSV" },
        { key = "yaJ", mode = "n", action = "[res] yank all rows as JSON" },
        { key = "yaC", mode = "n", action = "[res] yank all rows as CSV" },
      })

      require("dbee").setup({
        sources = {
          sources.MemorySource:new(load_global()), -- global, read-only
          sources.FileSource:new(project_file),    -- project, editable/persisted
        },
        drawer = { mappings = drawer_mappings },
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
