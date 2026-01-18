
return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "mocha", -- mocha, frappe, macchiato, latte
			transparent_background = true,
			term_colors = true,
			integrations = {
				treesitter = true,
				neotree = true,
				telescope = true,
				cmp = true,
				gitsigns = true,
				lsp_trouble = true,
				which_key = true,
				notify = true,
				snacks = true,
			},
			styles = {
				comments = { "italic" },
				keywords = { "bold" },
				functions = { "italic" },
				strings = {},
				variables = {},
			},
		})

		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				vim.cmd.colorscheme("catppuccin")
			end,
		})
	end,
}

