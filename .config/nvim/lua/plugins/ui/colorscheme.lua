return {
  "folke/tokyonight.nvim",
  name = "tokyonight",
  priority = 1000,
  config = function()
    require("tokyonight").setup({
      transparent = true,
      on_colors = function(colors) end,  -- Required by type definition
      on_highlights = function(highlights, colors) end,  -- Required by type definition
    })
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        vim.cmd.colorscheme("tokyonight")
      end,
    })
  end,
}
