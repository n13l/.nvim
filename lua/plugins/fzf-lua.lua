return {
  "ibhagwan/fzf-lua",
  keys = {
    { "<F5>", "<cmd>FzfLua files<cr>", desc = "Find Files" },
    { "<F6>", "<cmd>FzfLua oldfiles<cr>", desc = "Recent Files" },
    { "<F7>", "<cmd>FzfLua tags<cr>", desc = "Search Tags" },
  },
  opts = {
    defaults = { file_icons = false },
  },
}
