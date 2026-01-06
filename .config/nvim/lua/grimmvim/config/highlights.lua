local hl = vim.api.nvim_set_hl
local cmd = vim.cmd

-- Catppuccin Mocha color palette
local palette = {
	rosewater = "#f5e0dc",
	flamingo = "#f2cdcd",
	pink = "#f5c2e7",
	mauve = "#cba6f7",
	red = "#f38ba8",
	maroon = "#eba0ac",
	peach = "#fab387",
	yellow = "#f9e2af",
	green = "#a6e3a1",
	teal = "#94e2d5",
	sky = "#89dceb",
	sapphire = "#74c7ec",
	blue = "#89b4fa",
	lavender = "#b4befe",
	text = "#cdd6f4",
	subtext1 = "#bac2de",
	subtext0 = "#a6adc8",
	overlay2 = "#9399b2",
	overlay1 = "#7f849c",
	overlay0 = "#6c7086",
	surface2 = "#585b70",
	surface1 = "#45475a",
	surface0 = "#313244",
	base = "#1e1e2e",
}

-- changing bg and border colors
hl(0, "FloatBorder", { link = "Normal" })
hl(0, "LspInfoBorder", { link = "Normal" })
hl(0, "NormalFloat", { link = "Normal" })
hl(0, "Pmenu", { link = "Normal" })
hl(0, "PmenuSel", { link = "Search" })

-- blink cmp
hl(0, "BlinkCmpMenu", { link = "Normal" })
hl(0, "BlinkCmpMenuBorder", { link = "Normal" })
hl(0, "BlinkCmpMenuSelection", { link = "Search" })
hl(0, "BlinkCmpLabelMatch", { link = "Search" })

-- snacks dashboard
hl(0, "SnacksDashboardHeader", { fg = palette.yellow })
hl(0, "SnacksDashboardDesc", { fg = palette.sky })
hl(0, "SnacksDashboardFooter", { fg = palette.peach })

-- snacks indentline (using vibrant accent colors)
hl(0, "SnacksIndent1", { fg = palette.red })
hl(0, "SnacksIndent2", { fg = palette.peach })
hl(0, "SnacksIndent3", { fg = palette.yellow })
hl(0, "SnacksIndent4", { fg = palette.green })
hl(0, "SnacksIndent5", { fg = palette.teal })
hl(0, "SnacksIndent6", { fg = palette.blue })
hl(0, "SnacksIndent7", { fg = palette.mauve })

-- snacks picker
hl(0, "SnacksPickerDir", { fg = palette.overlay2 })

-- rainbow delimiter (cycling through accent colors)
hl(0, "RainbowDelimiter1", { fg = palette.red })
hl(0, "RainbowDelimiter2", { fg = palette.peach })
hl(0, "RainbowDelimiter3", { fg = palette.yellow })
hl(0, "RainbowDelimiter4", { fg = palette.green })
hl(0, "RainbowDelimiter5", { fg = palette.teal })
hl(0, "RainbowDelimiter6", { fg = palette.blue })
hl(0, "RainbowDelimiter7", { fg = palette.mauve })
