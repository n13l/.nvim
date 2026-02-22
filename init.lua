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
    vim.api.nvim_set_hl(0, "StatusLine", { bg = "#333333", fg = "#aaaaaa" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#222222", fg = "#777777" })
  else
    vim.api.nvim_set_hl(0, "LineNr", { ctermfg = 240 })
    vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg = 236 })
    vim.api.nvim_set_hl(0, "Normal", { ctermbg = 16 })
    vim.api.nvim_set_hl(0, "StatusLine", { ctermbg = 236, ctermfg = 249 })
    vim.api.nvim_set_hl(0, "StatusLineNC", { ctermbg = 234, ctermfg = 243 })
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
vim.g.netrw_keepdir = 0
vim.g.netrw_fastbrowse = 0

vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    vim.opt_local.conceallevel = 2
    vim.opt_local.concealcursor = "nvic"
    vim.api.nvim_set_hl(0, "Conceal", { fg = "#6e738d", bg = "NONE" })
    vim.diagnostic.enable(false, { bufnr = 0 })
    vim.opt_local.statusline = "%{fnamemodify(b:netrw_curdir, ':~')}"

    vim.keymap.set("n", "<CR>", function()
      local word = vim.fn["netrw#Call"]("NetrwGetWord")
      if word == "" or word == "../" or word == "./" then
        return vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<Plug>NetrwLocalBrowseCheck", true, true, true),
          "n", false)
      end
      local curdir = vim.b.netrw_curdir or ""
      local full = curdir .. "/" .. word
      local ftype = vim.fn.getftype(full)
      if ftype ~= "link" then
        return vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<Plug>NetrwLocalBrowseCheck", true, true, true),
          "n", false)
      end
      local resolved = vim.fn.resolve(full)
      if vim.fn.isdirectory(resolved) == 1 then
        vim.w.netrw_treetop = resolved
        vim.b.netrw_curdir = resolved
        vim.cmd("let w:netrw_treedict = {}")
        vim.cmd.Explore(vim.fn.fnameescape(resolved))
      else
        local chgwin = vim.g.netrw_chgwin or 0
        if chgwin > 0 and vim.api.nvim_win_is_valid(vim.fn.win_getid(chgwin)) then
          vim.cmd(chgwin .. "wincmd w")
        else
          vim.cmd("wincmd p")
        end
        vim.cmd.edit(vim.fn.fnameescape(resolved))
      end
    end, { buffer = true, desc = "netrw: follow symlinks" })
  end,
})
vim.keymap.set("n", "<F4>", "<cmd>Lex 30<cr>", { desc = "File browser" })

vim.g.clipboard = {
  name = "xclip",
  copy = {
    ["+"] = "xclip -selection clipboard",
    ["*"] = "xclip -selection primary",
  },
  paste = {
    ["+"] = "xclip -selection clipboard -o",
    ["*"] = "xclip -selection primary -o",
  },
}
vim.keymap.set("v", "<C-c>", '"+y', { desc = "Copy to clipboard" })
