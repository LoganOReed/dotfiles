
return {
    'nvim-telescope/telescope.nvim',
      dependencies = {{ 'nvim-lua/plenary.nvim' },
      { "nvim-telescope/telescope-fzf-native.nvim", build = 'make' },
		},
      cmd = "Telescope",
      keys = {
	      {"<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Fuzzy Find Files"},
	      {"<leader>fl", "<cmd>Telescope live_grep<cr>", desc = "Live Grep"},
	      {"<leader>fh", "<cmd>Telescope harpoon marks<cr>", desc = "Fuzzy Find Marks"},
      },
      opts = function()
	return {
	  defaults = {
	    vimgrep_arguments = {
	      "rg",
	      "-L",
	      "--color=never",
	      "--no-heading",
	      "--with-filename",
	      "--line-number",
	      "--column",
	      "--smart-case",
	    },
	    prompt_prefix = " ",
	    selection_caret = " ",
	    entry_prefix = "  ",
	    initial_mode = "insert",
	    selection_strategy = "reset",
	    sorting_strategy = "ascending",
	    layout_strategy = "horizontal",
	    layout_config = {
	      horizontal = {
		prompt_position = "top",
		preview_width = 0.55,
		results_width = 0.8,
	      },
	      vertical = {
		mirror = false,
	      },
	      width = 0.87,
	      height = 0.80,
	      preview_cutoff = 120,
	    },
	    file_sorter = require("telescope.sorters").get_fuzzy_file,
	    file_ignore_patterns = { ".git/", "node_modules" },
	    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
	    path_display = { "truncate" },
	    winblend = 0,
	    border = {},
	    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
	    color_devicons = true,
	    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
	    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
	    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
	    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
	    -- Developer configurations: Not meant for general override
	    buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
	    mappings = {
	-- TODO: This doesn't work eight now
	      n = { ["q"] = require("telescope.actions").close },
	      i = {
		    ["<Down>"] = require("telescope.actions").cycle_history_next,
		    ["<Up>"] = require("telescope.actions").cycle_history_prev,
		    ["<C-j>"] = require("telescope.actions").move_selection_next,
		    ["<C-k>"] = require("telescope.actions").move_selection_previous,
	      },
	    },
	  },

	  -- extensions_list = { "themes", "terms", "fzf", "projects" },
	  extensions_list = { "fzf", "harpoon", "persisted" },
--	  extensions_list = { 
--		fzf = {
--		  fuzzy = true,                    -- false will only do exact matching
--		  override_generic_sorter = true,  -- override the generic sorter
--		  override_file_sorter = true,     -- override the file sorter
--		  case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
					       -- the default case_mode is "smart_case"
--		  },
--		harpoon = {},

--		},
	}
end,

      config = function(_, opts)
		local telescope = require("telescope")
		telescope.setup(opts)

		-- load extensions
		for _, ext in ipairs(opts.extensions_list) do
		  telescope.load_extension(ext)
		end
	end,
    }

    -- find
--    ["<leader>ff"] = { "<cmd> Telescope find_files <CR>", "Find files" },
--    ["<leader>fa"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "Find all" },
--    ["<leader>fw"] = { "<cmd> Telescope live_grep <CR>", "Live grep" },
--    ["<leader>fb"] = { "<cmd> Telescope buffers <CR>", "Find buffers" },
--    ["<leader>fh"] = { "<cmd> Telescope help_tags <CR>", "Help page" },
--    ["<leader>fo"] = { "<cmd> Telescope oldfiles <CR>", "Find oldfiles" },
--    ["<leader>fj"] = { "<cmd> Telescope current_buffer_fuzzy_find <CR>", "Find in current buffer" },

    -- git
--    ["<leader>gc"] = { "<cmd> Telescope git_commits <CR>", "Git commits" },
--    ["<leader>gs"] = { "<cmd> Telescope git_status <CR>", "Git status" },

    -- pick a hidden term
--    ["<leader>ft"] = { "<cmd> Telescope terms <CR>", "Pick hidden term" },

--    ["<leader>fm"] = { "<cmd> Telescope marks <CR>", "telescope bookmarks" },
