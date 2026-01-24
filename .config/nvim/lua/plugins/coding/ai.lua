return {
	"NickvanDyke/opencode.nvim",
	dependencies = {
		-- Recommended for `ask()` and `select()`.
		-- Required for `snacks` provider.
		---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
		{ "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
	},
	config = function()
		---@type opencode.Opts
		vim.g.opencode_opts = {
			-- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
		}

		-- Required for `opts.events.reload`.
		vim.o.autoread = true

		-- AI Assistant keymaps following grimmvim conventions
		vim.keymap.set({ "n", "x" }, "<leader>aa", function()
			require("opencode").ask("@this: ", { submit = true })
		end, { desc = "AI [A]sk" })
		vim.keymap.set({ "n", "x" }, "<leader>as", function()
			require("opencode").select()
		end, { desc = "AI [S]elect action" })
		vim.keymap.set({ "n", "t" }, "<leader>at", function()
			require("opencode").toggle()
		end, { desc = "AI [T]oggle" })

		-- Operator mode for adding context
		vim.keymap.set({ "n", "x" }, "<leader>ao", function()
			return require("opencode").operator("@this ")
		end, { expr = true, desc = "AI [O]perator range" })
		vim.keymap.set("n", "<leader>aO", function()
			return require("opencode").operator("@this ") .. "_"
		end, { expr = true, desc = "AI [O]perator line" })

		-- Navigation within AI session
		vim.keymap.set("n", "<leader>ak", function()
			require("opencode").command("session.half.page.up")
		end, { desc = "AI scroll up" })
		vim.keymap.set("n", "<leader>aj", function()
			require("opencode").command("session.half.page.down")
		end, { desc = "AI scroll down" })

		-- Quick access shortcuts (optional)
		vim.keymap.set({ "n", "x" }, "<M-a>", function()
			require("opencode").ask("@this: ", { submit = true })
		end, { desc = "Quick AI ask" })
		vim.keymap.set({ "n", "t" }, "<M-t>", function()
			require("opencode").toggle()
		end, { desc = "Quick AI toggle" })
	end,
}
