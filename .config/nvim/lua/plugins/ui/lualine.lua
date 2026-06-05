return {
	"nvim-lualine/lualine.nvim",

	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},

	event = "VeryLazy",

	opts = {
		options = {
			theme = "auto",

			component_separators = {
				left = "│",
				right = "│",
			},

			section_separators = {
				left = "",
				right = "",
			},

			disabled_filetypes = {
				"snacks_dashboard",
			},
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
					mode = 2,

					symbols = {
						modified = " ●",
						alternate_file = "",
						directory = "",
					},

					buffers_color = {
						active = {
							bg = "#7f8cc7",
							fg = "#f8f8f2",
							bold = true,
						},

						inactive = {
							bg = "#21222c",
							fg = "#44475a",
						},
					},
				},
			},

			lualine_c = {
				{
					"filename",
					file_status = true,
					path = 0,
					shorting_target = 40,
				},
			},

			lualine_x = {
				"filesize",
			},

			lualine_y = {
				"searchcount",
				"selectioncount",
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

			lualine_c = {
				"filename",
			},

			lualine_x = {
				"location",
			},

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
