-- return {
-- 	{"nvim-treesitter/nvim-treesitter",
-- 	build = ":TSUpdate",
--     config = function ()
--       local configs = require("nvim-treesitter.configs")
--
--       configs.setup({
--           ensure_installed = { "c", "cpp", "toml", "lua", "python", "javascript", "html", "json" },
--           sync_install = false,
--           highlight = { enable = true },
--           indent = { enable = true },
--         })
--     end,
--     },
-- }

return {
    'nvim-treesitter/nvim-treesitter',
    event = { "BufReadPost", "BufNewFile" },
    main = "nvim-treesitter.configs",
    dev = true,
    opts = {
        autotag = {
            enable = true
        },
        highlight = {
            -- `false` will disable the whole extension
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<CR>",
                node_incremental = "<CR>",
                scope_incremental = "<S-CR>",
                node_decremental = "<BS>",
            },
        },
    }
}
