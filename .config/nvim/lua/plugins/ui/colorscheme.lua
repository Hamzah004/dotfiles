-- return {
--   "Mofiqul/dracula.nvim",
--   priority = 1000,
--   config = function()
--     require("dracula").setup({
--       transparent_bg = true,
--     })
--     vim.cmd.colorscheme("dracula")
--   end,
-- }

-- return {
--   "savq/melange-nvim",
--   priority = 1000, -- make sure to load this before all the other start plugins
--   config = function()
--     -- vim.g.matrix_contrast = true
--     -- vim.g.matrix_borders = false
--     -- vim.g.matrix_disable_background = false
--     -- vim.g.matrix_italic = true
--     require("melange").set()
--   end
-- }

-- return {
--     "samharju/synthweave.nvim",
--     lazy = false, -- make sure we load this during startup if it is your main colorscheme
--     priority = 1000,
--     config = function()
--         vim.cmd.colorscheme("synthweave")
--         -- transparent version
--         -- vim.cmd.colorscheme("synthweave-transparent")
--     end
-- }

return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "mocha", -- mocha, frappe, macchiato, mocha
			transparent_background = false,
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
