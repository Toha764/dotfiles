--------------------------------------------------
-- Telescope Configuration
--------------------------------------------------

return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		"nvim-telescope/telescope-ui-select.nvim",
	},

	config = function()
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")

		telescope.setup({
			defaults = {
				sorting_strategy = "ascending",
				layout_config = {
					prompt_position = "top",
				},

				-- Ignore heavy folders globally
				file_ignore_patterns = {
					"node_modules",
					".git/",
					"dist",
					"build",
					"%.jpg",
					"%.png",
				},

				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
				},
			},

			pickers = {
				find_files = {
					search_dirs = {
						"~/300 Resources/Markdown_Notes/",
						"~/100 Projects/",
					},
					hidden = false, -- keep fast by default
					find_command = {
						"fd",
						"--type",
						"f",
						"--exclude",
						".git",
						"--exclude",
						"node_modules",
						"--exclude",
						"dist",
						"--exclude",
						"build",
					},
				},
			},

			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown({}),
				},
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("ui-select")

		vim.keymap.set("n", "<leader>ff", function()
			builtin.find_files()
		end, { desc = "Find Files" })

		vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
		-- vim.keymap.set("n", "<leader>cd", builtin.diagnostics, { desc = "Diagnostics" })
		vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent Files" })
		vim.keymap.set("n", "<leader>ch", builtin.help_tags, { desc = "Help Tags" })
	end,
}
