return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",

	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		"nvim-telescope/telescope-ui-select.nvim",
	},

	keys = {
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Files" },
		{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
		{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },

		-- Theme picker
		{ "<leader>ft", "<cmd>Telescope colorscheme<cr>", desc = "Themes" },
	},

	opts = function()
		return {
			defaults = {
				sorting_strategy = "ascending",
				layout_strategy = "horizontal",
				layout_config = {
					prompt_position = "top",
				},

				file_ignore_patterns = {
					"node_modules",
					".git/",
					"dist",
					"build",
				},

				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden",
					"--glob",
					"!**/.git/*",
				},
			},

			pickers = {
				find_files = {
					hidden = true,
					find_command = {
						"fd",
						"--type",
						"f",
						"--strip-cwd-prefix",
					},
				},
				colorscheme = {
					enable_preview = true,
				},
			},

			extensions = {
				["ui-select"] = require("telescope.themes").get_dropdown({}),
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		}
	end,

	config = function(_, opts)
		local telescope = require("telescope")
		telescope.setup(opts)

		telescope.load_extension("fzf")
		telescope.load_extension("ui-select")
	end,
}
