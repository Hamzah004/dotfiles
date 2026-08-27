return {
  "Diogo-ss/42-C-Formatter.nvim",
  cmd = "CFormat42", -- This makes the plugin lazy-load when the CFormat42 command is used.
  config = function()
    local formatter = require("42-formatter")
    formatter.setup({
      formatter = 'c_formatter_42', -- Specifies the formatter to be used.
      filetypes = {
        c = true,   -- Enable formatting for C files
        h = true,   -- Enable formatting for C header files
        cpp = true,  -- Enable formatting for C++ files
        hpp = true   -- Enable formatting for C++ header files
      },
    })
  end
}
