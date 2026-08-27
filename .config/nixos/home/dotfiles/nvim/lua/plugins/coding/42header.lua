return {
	"Diogo-ss/42-header.nvim",
	cmd = { "Stdheader" },
	keys = { "<F1>" },
	opts = {
		default_map = true,
		auto_update = true,
		user = "hbani-at",
		mail = "hbani-at@student.42amman.com",
	},
	config = function(_, opts)
		require("42header").setup(opts)
	end,
}

