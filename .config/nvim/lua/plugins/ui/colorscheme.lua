return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "latte", -- latte, frappe, macchiato, mocha
			-- transparent_background = true,
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

-- {
-- 	"sainnhe/gruvbox-material",
-- 	priority = 1000,
-- 	config = function()
-- 		vim.o.background = "dark" -- or "light" for light mode
--
-- 		local cmds = {
-- 			"let g:gruvbox_material_background = 'hard'",
-- 			"let g:gruvbox_material_transparent_background = 2",
-- 			"let g:gruvbox_material_diagnostic_line_highlight = 1",
-- 			"let g:gruvbox_material_diagnostic_virtual_text = 'colored'",
-- 			"let g:gruvbox_material_enable_bold = 1",
-- 			"let g:gruvbox_material_enable_italic = 1",
-- 			"colorscheme gruvbox-material",
-- 		}
--
-- 		for _, cmd in ipairs(cmds) do
-- 			vim.cmd(cmd)
-- 		end
-- 	end,
-- }
-- return {
-- 	"folke/tokyonight.nvim",
-- 	name = "tokyonight",
-- 	priority = 1000,
-- 	config = function()
-- 		vim.api.nvim_create_autocmd("VimEnter", {
-- 			callback = function()
-- 				vim.cmd.colorscheme("tokyonight")
-- 			end,
-- 		})
-- 	end,
-- }
--
