-- plugin
return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = { "VeryLazy" },
	opts = {
		options = {
			theme = "auto",
			component_separators = { left = "│", right = "│" },
			section_separators = { left = "", right = "" },
			disabled_filetypes = { "snacks_dashboard" },
		},
		sections = {
			lualine_a = {
				"mode",
			},
			lualine_b = {
				"branch",
				"diff",
				"diagnostics",
				{
					"buffers",
					symbols = {
						modified = " ●",
						alternate_file = "",
						directory = "",
					},
					mode = 2,
				},
			},
			lualine_c = {
				{
					"filename",
					file_status = true,
					path = 3,
					shorting_target = 0,
				},
			},
			lualine_x = {
				"filesize",
			},
			lualine_y = {
				"searchcount",
				"selectioncount",
				-- "encoding",
				"filetype",
			},
			lualine_z = {
				"progress",
				"location",
			},
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { "filename" },
			lualine_x = { "location" },
			lualine_y = {},
			lualine_z = {},
		},
		tabline = {},
		winbar = {},
		inactive_winbar = {},
		extensions = {},
	},
	config = function(_, opts)
		require("lualine").setup(opts)
		vim.opt.laststatus = 3
	end,
}
