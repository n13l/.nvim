require('config.lazy')
require('amp').setup({ auto_start = true, log_level = "info" })
require('ampcode')

vim.opt.number = true
vim.opt.colorcolumn = "80"

if vim.env.TERM and vim.env.TERM:match("screen") then
  vim.opt.termguicolors = false
else
  vim.opt.termguicolors = true
end

local function apply_colors()
  if vim.o.termguicolors then
    vim.api.nvim_set_hl(0, "LineNr", { fg = "#555555" })
    vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#333333" })
    vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
  else
    vim.api.nvim_set_hl(0, "LineNr", { ctermfg = 240 })
    vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg = 236 })
    vim.api.nvim_set_hl(0, "Normal", { ctermbg = 16 })
  end
end

vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_colors })
apply_colors()

vim.opt.listchars = { tab = "→ ", trail = "·", space = "·", eol = "¬" }
vim.keymap.set("n", "<F8>", "<cmd>set list!<cr>", { desc = "Toggle hidden characters" })

vim.diagnostic.config({
  virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "▸",
      [vim.diagnostic.severity.WARN]  = "▸",
      [vim.diagnostic.severity.INFO]  = "▸",
      [vim.diagnostic.severity.HINT]  = "▸",
    },
  },
  underline = true,
})

vim.lsp.config("clangd", {
  cmd = { "clangd", "--background-index", "--clang-tidy" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
})
vim.lsp.enable("clangd")
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "LSP References" })

vim.keymap.set("n", "<F9>", function()
  vim.ui.input({ prompt = "Command: ", default = "make" }, function(cmd)
    if cmd and cmd ~= "" then
      vim.cmd("botright split | terminal " .. cmd .. " 2>&1")
    end
  end)
end, { desc = "Run shell command" })

vim.keymap.set("n", "<F12>", function()
  if vim.g.colors_name == "quiet" then
    vim.cmd("colorscheme default")
  else
    vim.cmd("colorscheme quiet")
  end
end, { desc = "Toggle colorscheme" })

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3

vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    vim.opt_local.conceallevel = 2
    vim.opt_local.concealcursor = "nvic"
    vim.diagnostic.enable(false, { bufnr = 0 })
  end,
})
vim.keymap.set("n", "<F4>", "<cmd>Lex 30<cr>", { desc = "File browser" })

vim.opt.clipboard = "unnamedplus"
