return {
	"folke/tokyonight.nvim",
	name = "tokyonight",
	priority = 1000,
	config = function()
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				vim.cmd.colorscheme("tokyonight")
			end,
		})
	end,
}

