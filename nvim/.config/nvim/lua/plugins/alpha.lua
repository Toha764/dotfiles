-------------------------------------------------
-- Dashboard Configuration
--------------------------------------------------

return {
	"goolord/alpha-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")
		dashboard.section.header.val = {
			[[                                ]],
			[[              /\_/\             ]],
			[[             ( o.o )            ]],
			[[              > ^ <             ]],
			[[                                ]],
			[[       Just give up and die     ]],
			[[                                ]],
			[[                         ~ Meow ]],
			[[                                ]],
			[[                                ]],
			[[                                ]],
			[[                                ]],
		}

		dashboard.section.buttons.val = {
			dashboard.button("e", "📁 Browse files", ":Yazi<CR>"),
			dashboard.button("z", "📁 Cached directories", ":Telescope zoxide list<CR>"),
			dashboard.button(
				"n",
				"📝 Browse Notes",
				":cd /Users/toha/300\\ Resources/00\\ Books/000\\ Markdown_Notes | Yazi<CR>"
			),
			dashboard.button("l", "< >Leet code", ":Leet<CR>"),
			dashboard.button("r", "⏱  Recent", ":Telescope oldfiles<CR>"),
			dashboard.button("qa", "⏻ Quit", ":qa<CR>"),
		}

		alpha.setup(dashboard.opts)
	end,
}
