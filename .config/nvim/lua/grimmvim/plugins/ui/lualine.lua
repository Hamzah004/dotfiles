-- define colors
local colors = {
  blue = "#7aa2f7",
  green = "#9ece6a",
  violet = "#bb9af7",
  yellow = "#e0af68",
  red = "#f7768e",
  cream = "#c0caf5",
  black = "#1a1b26",
  grey = "#414868",
  dark = "#24283b",
}

-- custom modifications
local tokyonight = {
	normal = {
		a = { bg = colors.dark, fg = colors.cream, gui = "bold" },
		b = { bg = colors.grey, fg = colors.cream, gui = "bold" },
		c = { bg = colors.blue, fg = colors.black, gui = "bold" },
	},
	insert = {
		a = { bg = colors.blue, fg = colors.black, gui = "bold" },
		c = { bg = colors.violet, fg = colors.black, gui = "bold" },
	},
	visual = {
		a = { bg = colors.violet, fg = colors.black, gui = "bold" },
		c = { bg = colors.dark, fg = colors.cream, gui = "bold" },
	},
	command = {
		a = { bg = colors.green, fg = colors.black, gui = "bold" },
		c = { bg = colors.black, fg = colors.cream, gui = "bold" },
	},
	terminal = {
		a = { bg = colors.red, fg = colors.black, gui = "bold" },
		c = { bg = colors.black, fg = colors.cream, gui = "bold" },
	},
	replace = {
		a = { bg = colors.blue, fg = colors.black, gui = "bold" },
		c = { bg = colors.violet, fg = colors.black, gui = "bold" },
	},
	inactive = {
		a = { bg = colors.green, fg = colors.black, gui = "bold" },
		c = { bg = colors.black, fg = colors.cream, gui = "bold" },
	},
}

-- plugin
return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = { "VeryLazy" },
	opts = {
		options = {
			theme = "catppuccin",
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
					buffers_color = {
						active = { bg = colors.yellow, fg = colors.black, gui = "bold" },
						inactive = { bg = colors.grey, fg = colors.cream, gui = "italic" },
					},
					symbols = {
						modified = " ●",
						alternate_file = "",
						directory = "",
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
