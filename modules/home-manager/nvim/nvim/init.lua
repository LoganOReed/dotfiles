require("config.options")
require("config.autocmds")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


-- used to have nix handle treesitter and
-- stop lazy from messing with it
require("lazy").setup("plugins", {
    dev = {
        path = "~/.local/share/nvim/nix",
        fallback = false,
    }
})

-- set values and such
require("config.keymaps")


-- TODO: https://github.com/jedrzejboczar/toggletasks.nvim
