return {
	"jake-stewart/multicursor.nvim",
	branch = "1.0",
	config = function()
		local mc = require("multicursor-nvim")
		mc.setup()

		local set = vim.keymap.set

		local mouse_enabled = false
		local function enable_mouse_support()
			set("n", "<c-leftmouse>", mc.handleMouse)
			set("n", "<c-leftdrag>", mc.handleMouseDrag)
			set("n", "<c-leftrelease>", mc.handleMouseRelease)
			mouse_enabled = true
			vim.notify("Multicursor mouse support enabled", vim.log.levels.INFO, { title = "Multicursor" })
		end

		local function disable_mouse_support()
			pcall(vim.keymap.del, "n", "<c-leftmouse>")
			pcall(vim.keymap.del, "n", "<c-leftdrag>")
			pcall(vim.keymap.del, "n", "<c-leftrelease>")
			mouse_enabled = false
			vim.notify("Multicursor mouse support disabled", vim.log.levels.INFO, { title = "Multicursor" })
		end

		local function toggle_mouse_support()
			if mouse_enabled then
				disable_mouse_support()
			else
				enable_mouse_support()
			end
		end

		set("n", "<leader>mm", toggle_mouse_support, { desc = "Multi-cursor toggle mouse" })

		set("n", "<A-j>", function()
			mc.lineAddCursor(1)
		end, { desc = "Multi-cursor add cursor below" })
		set("n", "<A-k>", function()
			mc.lineAddCursor(-1)
		end, { desc = "Multi-cursor add cursor above" })


		-- Add or skip adding a new cursor by matching word/selection
		set({ "n", "x" }, "<leader>mn", function()
			mc.matchAddCursor(1)
		end, { desc = "Multi-cursor add next match" })
		set({ "n", "x" }, "<leader>ms", function()
			mc.matchSkipCursor(1)
		end, { desc = "Multi-cursor skip next match" })
		set({ "n", "x" }, "<leader>mN", function()
			mc.matchAddCursor(-1)
		end, { desc = "Multi-cursor add prev match" })
		set({ "n", "x" }, "<leader>mS", function()
			mc.matchSkipCursor(-1)
		end, { desc = "Multi-cursor skip prev match" })

		-- Disable and enable cursors.
		set({ "n", "x" }, "<leader>mq", mc.toggleCursor, { desc = "Multi-cursor toggle" })

		mc.addKeymapLayer(function(layerSet)
			-- Select a different cursor as the main one.
			layerSet({ "n", "x" }, "<left>", mc.prevCursor)
			layerSet({ "n", "x" }, "<right>", mc.nextCursor)

			-- Delete the main cursor.
			layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

			-- Enable and clear cursors using escape.
			layerSet("n", "<esc>", function()
				if not mc.cursorsEnabled() then
					mc.enableCursors()
				else
					mc.clearCursors()
				end
			end)
		end)

		-- Customize how cursors look.
		local hl = vim.api.nvim_set_hl
		hl(0, "MultiCursorCursor", { reverse = true })
		hl(0, "MultiCursorVisual", { link = "Visual" })
		hl(0, "MultiCursorSign", { link = "SignColumn" })
		hl(0, "MultiCursorMatchPreview", { link = "Search" })
		hl(0, "MultiCursorDisabledCursor", { reverse = true })
		hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
		hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
	end,
}