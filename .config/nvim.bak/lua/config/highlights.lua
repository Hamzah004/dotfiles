local hl = vim.api.nvim_set_hl

-- Use theme defaults - no custom colors
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
