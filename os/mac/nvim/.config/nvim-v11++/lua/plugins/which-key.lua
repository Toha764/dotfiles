----------------------------------------
-- which-key — shortcut reference
-- Press <leader>? to see buffer keymaps
----------------------------------------

return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "helix",
		plugins = {
			marks     = false,
			operators = false,
			windows   = false,
			nav       = false,
		},
		win = {
			padding = { 0, 1 },
			title   = false,
			border  = "rounded",
		},
		icons = {
			breadcrumb = ">>=",
			separator  = ":: ",
			group      = " ++ ",
			keys       = {},
		},
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)

		-- group labels shown in the popup
		wk.add({
			{ "<leader>g",  group = "goto / LSP" },
			{ "<leader>f",  group = "find" },
			{ "<leader>h",  group = "git hunk" },
			{ "<leader>s",  group = "split" },
			{ "<leader>n",  group = "new / split" },
			{ "<leader>c",  group = "code" },
			{ "<leader>l",  group = "leet" },
			{ "<leader>m",  group = "markdown" },
		})
	end,
	keys = {
		{
			"<leader>?",
			function() require("which-key").show({ global = false }) end,
			desc = "Buffer keymaps (which-key)",
		},
	},
}
