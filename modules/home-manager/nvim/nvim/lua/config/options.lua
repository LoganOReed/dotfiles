local opt = vim.opt
local g = vim.g


----------------------------------- globals ----------------------------------------------
g.mapleader = " "
g.maplocalleader = " "
-- lua snippet format
g.lua_snippets_path = "/home/occam/.snippets/luasnip"


----------------------------------- options ----------------------------------------------
opt.backup = false    -- creates a backup file
opt.undofile = true   -- enable persistent undo
opt.hlsearch = true   -- highlight all matches on previous search pattern
opt.ignorecase = true -- ignore case in search patterns
opt.wrap = false      -- display lines as one long line
opt.cursorline = true -- highlight the current line
opt.scrolloff = 8     -- minimal number of screen lines to keep above and below the cursor
opt.sidescrolloff = 8 -- minimal number of screen columns to keep to the left and right of the cursor if wrap is `false`
opt.relativenumber = true
opt.number = true

opt.laststatus = 3 -- global statusline
opt.showmode = false

opt.clipboard = "unnamedplus"
opt.cursorline = true

-- Indenting
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2

opt.fillchars = { eob = " " }
opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"

-- disable nvim intro
opt.shortmess:append "sI"

opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = 200

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 250

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

for _, provider in ipairs { "perl", "ruby" } do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end
