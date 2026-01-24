
return {
  -- Core note-taking
  {
    'epwalsh/obsidian.nvim',
    version = '*',
    ft = 'markdown',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('obsidian').setup {
        dir = '~/notes',
        ui = {
          enable = true,
        },
      }
    end,
  },


  { 'junegunn/goyo.vim' },

  {
    'plasticboy/vim-markdown',
    ft = 'markdown',
    dependencies = {
      'godlygeek/tabular', -- Required for vim-markdown tables
    },
    config = function()
      vim.g.vim_markdown_folding_disabled = 1 -- Disable folding
      vim.g.vim_markdown_conceal = 1 -- Enable concealing
      vim.g.vim_markdown_conceal_code_blocks = 0
    end,
  },
  {
    'iamcco/markdown-preview.nvim',
    ft = 'markdown',
    build = function()
      vim.fn['mkdp#util#install']()
    end,
    config = function()
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
    end,
  },
}
