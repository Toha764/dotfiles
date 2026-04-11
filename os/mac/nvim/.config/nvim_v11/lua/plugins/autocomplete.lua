--------------------------------------------------
-- Autocomplete (nvim-cmp) Configuration
--------------------------------------------------
return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-buffer",
		"onsails/lspkind.nvim", -- kind icons
	},
	config = function()
		local cmp = require("cmp")
		local lspkind = require("lspkind")

		-- Insert mode completion
		cmp.setup({
			mapping = cmp.mapping.preset.insert({
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					else
						fallback() -- lets tabout handle it
					end
				end, { "i", "s" }),

				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					else
						fallback()
					end
				end, { "i", "s" }),

				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<C-e>"] = cmp.mapping.abort(),
				["<C-d>"] = cmp.mapping.scroll_docs(4),
				["<C-u>"] = cmp.mapping.scroll_docs(-4),
			}),
			window = {
				completion = cmp.config.window.bordered({
					winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual",
					scrollbar = false,
					col_offset = -3,
					side_padding = 1,
				}),
				documentation = cmp.config.window.bordered({
					winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
					max_width = 60,
					max_height = 15,
				}),
			},

			formatting = {
				expandable_indicator = false,
				fields = { "kind", "abbr", "menu" },
				format = lspkind.cmp_format({
					mode = "symbol_text",
					maxwidth = 40, -- caps the completion item width
					ellipsis_char = "…",
					menu = {
						nvim_lsp = "[LSP]",
						path = "[Path]",
						buffer = "[Buf]",
					},
				}),
			},

			performance = {
				max_view_entries = 10, -- only show 10 items at a time
			},

			sources = {
				{ name = "nvim_lsp" },
				{ name = "path" },
			},
		})

		-- Command-line (:) completion
		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "path" },
				{ name = "cmdline" },
			},
		})

		-- Search (/) completion
		cmp.setup.cmdline("/", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})

		-- Autopairs integration
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
}
