local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local check_backspace = function()
  local col = vim.fn.col(".") - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end


local M = {
  {
    'VonHeikemen/lsp-zero.nvim',
    lazy = true,
    config = function()
      -- This is where you modify the settings for lsp-zero
      -- Note: autocompletion settings will not take effect

      require('lsp-zero.settings').preset({
        float_border = 'rounded',
        call_servers = 'local',
        configure_diagnostics = true,
        setup_servers_on_start = true,
        set_lsp_keymaps = {
          preserve_mappings = false,
          omit = {},
        },
        manage_nvim_cmp = {
          set_sources = 'recommended',
          set_basic_mappings = true,
          set_extra_mappings = true,
          use_luasnip = true,
          set_format = true,
          documentation_window = true,
        },
      })
    end
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      { "sirver/UltiSnips",
        -- config = function()
        --     vim.g.UltiSnipsSnippetDir = "~/.snippets/UltiSnips"
        -- end,
      },
      -- "L3MON4D3/LuaSnip",
      -- dependencies = { "rafamadriz/friendly-snippets" },
      {
        "quangnguyen30192/cmp-nvim-ultisnips",
        -- "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
    },
    config = function()
      -- Here is where you configure the autocompletion settings.
      -- The arguments for .extend() have the same shape as `manage_nvim_cmp`:
      -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/api-reference.md#manage_nvim_cmp

      require('lsp-zero.cmp').extend()
      -- And you can configure cmp even more, if you want to.
      local cmp = require('cmp')
      local cmp_action = require('lsp-zero.cmp').action()


      local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
      -- require("luasnip.loaders.from_lua").lazy_load { paths = vim.g.lua_snippets_path or "" }
      -- require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
          end,
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'nvim_lua' },
          -- {name = 'luasnip'},
          { name = 'ultisnips' },
          { name = 'path' },
          { name = 'buffer' },
        },
        mapping = {
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-h>"] = cmp.mapping.scroll_docs(-4),
          ["<C-l>"] = cmp.mapping.scroll_docs(4),

          ["<Tab>"] = cmp.mapping(function(fallback)
              if vim.fn["UltiSnips#CanExpandSnippet"]() then
                cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
              elseif vim.fn["UltiSnips#CanJumpForwards"]() then
                cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
              elseif check_backspace() then
                cmp.complete()
              else
                fallback()
              end
            end,
            {
              "i",
              "s",
            }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif vim.fn["UltiSnips#CanJumpBackwards"]() then
                cmp_ultisnips_mappings.jump_backwards(fallback)
              else
                fallback()
              end
            end,
            {
              "i",
              "s",
            }),

        }
      })
    end
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    cmd = 'LspInfo',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'williamboman/mason-lspconfig.nvim' },
      { 'williamboman/mason.nvim' },
    },
    config = function()
      -- This is where all the LSP shenanigans will live

      local lsp = require('lsp-zero')

      lsp.on_attach(function(client, bufnr)
        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        lsp.default_keymaps({ buffer = bufnr })
      end)

      -- integrate mason with lsp-zero
      require('mason').setup({})
      require('mason-lspconfig').setup({
        -- Replace the language servers listed here 
        -- with the ones you want to install
        ensure_installed = {'pyright', 'lua_ls', 'phpactor', 'yamlls', 'jsonls'},
        handlers = {
          lsp.default_setup,
        },
      })

      -- (Optional) Configure lua language server for neovim
      require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())



      -- configure keys

      lsp.on_attach(function(client, bufnr)
        lsp.default_keymaps({ buffer = bufnr })
        vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { buffer = bufnr })
        vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { buffer = bufnr })
        vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { buffer = bufnr })
        vim.keymap.set("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", { buffer = bufnr })
        vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { buffer = bufnr })
        vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", { buffer = bufnr })
        vim.keymap.set("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", { buffer = bufnr })
        vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<cr>", { buffer = bufnr })
        vim.keymap.set("n", "<leader>lI", "<cmd>LspInstallInfo<cr>", { buffer = bufnr })
        vim.keymap.set("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", { buffer = bufnr })
        vim.keymap.set("n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", { buffer = bufnr })
        vim.keymap.set("n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", { buffer = bufnr })
        vim.keymap.set("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", { buffer = bufnr })
        vim.keymap.set("n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { buffer = bufnr })
        vim.keymap.set("n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", { buffer = bufnr })

      end)


      lsp.setup()
    end
  }
}

return M



-- TODO: Integrate luasnip into cmp config

-- ["<Tab>"] = cmp.mapping(function(fallback)
-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
-- they way you will only jump inside the snippet region
-- if require("luasnip").expand_or_jumpable() then
-- require("luasnip").expand_or_jump()
-- elseif cmp.visible() then
-- cmp.select_next_item()
-- elseif has_words_before() then
-- cmp.complete()
-- else
-- fallback()
-- end
-- end, { "i", "s" }),
--
-- ["<S-Tab>"] = cmp.mapping(function(fallback)
-- if cmp.visible() then
-- cmp.select_prev_item()
-- elseif require("luasnip").jumpable(-1) then
-- require("luasnip").jump(-1)
-- else
-- fallback()
-- end
-- end, { "i", "s" }),
