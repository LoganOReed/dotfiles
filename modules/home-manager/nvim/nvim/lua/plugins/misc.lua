return {
  {
    'Mofiqul/dracula.nvim',
    init = function()
      vim.cmd('colorscheme dracula')
    end,
  },
  {
    'ThePrimeagen/harpoon',
    lazy = false,
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>a", function() require("harpoon.mark").add_file() end,        desc = "Add Current File" },
      { "<leader>h", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Toggle Quick Menu" },
      { "<C-]>",     function() require("harpoon.ui").nav_next() end,          desc = "Go To Next Mark" },
      { "<C-[>",     function() require("harpoon.ui").nav_prev() end,          desc = "Go To Prev Mark" },
      { "<C-1>",     function() require("harpoon.ui").nav_file(1) end,         desc = "Go To First Mark" },
      { "<C-2>",     function() require("harpoon.ui").nav_file(2) end,         desc = "Go To Second Mark" },
      { "<C-3>",     function() require("harpoon.ui").nav_file(3) end,         desc = "Go To Third Mark" },
      { "<C-4>",     function() require("harpoon.ui").nav_file(4) end,         desc = "Go To Fourth Mark" },
      { "<C-5>",     function() require("harpoon.ui").nav_file(5) end,         desc = "Go To Fifth Mark" },

    },
    config = function()
      require("harpoon"):setup({})
    end,
  },
  {
    'mbbill/undotree',
    lazy = false,
    init = function()
      vim.g["undotree_SetFocusWhenToggle"] = 1
    end,
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undo Tree" },
    },
  },
  -- Only load whichkey after all the gui
  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<c-r>", '"', "'", "`", "c", "v", "g" },
    cmd = "WhichKey",
  },

  -- git stuff
  {
    "lewis6991/gitsigns.nvim",
    ft = { "gitcommit", "diff" },
    init = function()
      -- load gitsigns only when a git file is opened
      vim.api.nvim_create_autocmd({ "BufRead" }, {
        group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
        callback = function()
          vim.fn.system("git -C " .. '"' .. vim.fn.expand "%:p:h" .. '"' .. " rev-parse")
          if vim.v.shell_error == 0 then
            vim.api.nvim_del_augroup_by_name "GitSignsLazyLoad"
            vim.schedule(function()
              require("lazy").load { plugins = { "gitsigns.nvim" } }
            end)
          end
        end,
      })
    end,
    opts = function()
      return {
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "󰍵" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "│" },
        },
      }
    end,
    config = function(_, opts)
      require("gitsigns").setup(opts)
    end,
  },
  {
    "goolord/alpha-nvim",
    lazy = false,
    config = function()
      require "plugins.configs.alpha"
    end,
  },
  -- todo highlighting and searching
  -- FIX, TODO, HACK, WARN, PERF, NOTE, TEST with colon after
  -- TODO: Change lazy flag to event like above
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufEnter",
    opts = {
      -- require("core.utils").load_mappings "blankline"
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugins.configs.lualine")
    end,
  },
  -- makes jk escape nice to use
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  {
    "ahmedkhalf/project.nvim",
    lazy = false,
    config = function()
      require("project_nvim").setup {
        -- NOTE: lsp detection will get annoying with multiple langs in one project
        detection_methods = { "pattern" },

        -- patterns used to detect root dir, when **"pattern"** is in detection_methods
        patterns = { ".git", "Makefile", "package.json" },
      }
    end,
  },

  -- Movement stuff
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },
  {
    "ggandor/leap.nvim",
    dependencies = { "tpope/vim-repeat" },
    event = "VeryLazy",
    config = function()
      require('leap').add_default_mappings()
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {} -- this is equalent to setup({}) function
  },
  {
    "lervag/vimtex",
    -- lazy-load on tex files
    ft = "tex",
    config = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_syntax_enabled = 1
      vim.g.vimtex_compiler_latexmk = {
        -- creates build directory based on tex file name
        out_dir = function()
          return vim.fn.expand "%:t:r"
        end,
        executable = "latexmk",
      }
      vim.g.vimtex_quickfix_ignore_filters = {
        "Underfull \\hbox",
        "Overfull \\hbox",
      }
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    init = function()
      require("plugins.configs.toggleterm")
    end,
    opts = {
      direction = "float",
      open_mapping = [[<c-\>]],
      -- insert_mappings = false,
      -- terminal_mappings = false,
    },
    config = true,
  },
  {
    'echasnovski/mini.comment',
    event = "InsertEnter",
    init = function()
      require("mini.comment").setup()
    end,
  },

  {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  -- used to get rid of import errors with poetry
  {
    "petobens/poet-v",
    ft = "py",
    config = function()
      vim.g["poetv_auto_activate"] = 1
    end,
  },
  {
    "ThePrimeagen/vim-be-good"
  },
  {
    "olimorris/persisted.nvim",
    config = true
  },
  -- Moves to end of parenthesis
  {
    "abecodes/tabout.nvim",
    dependencies = {"hrsh7th/nvim-cmp"},
    event = "InsertEnter",
    config = function()
      require('tabout').setup {
      tabkey = "<c-d>", -- key to trigger tabout, set to an empty string to disable
      backwards_tabkey = "<c-s>", -- key to trigger backwards tabout, set to an empty string to disable
      act_as_tab = true, -- shift content if tab out is not possible
      act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
      default_tab = '<C-t>', -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
      default_shift_tab = '<C-d>', -- reverse shift default action,
      enable_backwards = true, -- well ...
      completion = false, -- if the tabkey is used in a completion pum
      tabouts = {
        {open = "'", close = "'"},
        {open = '"', close = '"'},
        {open = '`', close = '`'},
        {open = '(', close = ')'},
        {open = '[', close = ']'},
        {open = '<', close = '>'},
        {open = '{', close = '}'}
      },
      ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
      exclude = {} -- tabout will ignore these filetypes
    }
  end,
  },
}
