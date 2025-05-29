-- leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- nerd fonts
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
--  NOTE: For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true

-- mouse enabled
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- make vim clipboard same as system clipboard
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = false

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true
--------------------------------------------------
-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`

-- Configure Goyo specifically for markdown files
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.cmd [[
      function! s:goyo_enter()
        let g:templates_auto_initialize = 0
        set conceallevel=2
        set spell
      endfunction

      function! s:goyo_leave()
        let g:templates_auto_initialize = 1
        set conceallevel=2
        set spell
      endfunction

      autocmd! User GoyoEnter nested call <SID>goyo_enter()
      autocmd! User GoyoLeave nested call <SID>goyo_leave()
    ]]
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'GoyoLeave',
  callback = function()
    vim.g.templates_auto_initialize = 1 -- Re-enable templates
  end,
})
-- Auto-commands for note-taking
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    -- -- Enable spell check in markdown files
    -- vim.opt_local.spell = true
    -- Set text width for nice formatting
    vim.diagnostic.enable(false, { bufnr = 0 })
    vim.opt_local.textwidth = 80
  end,
})
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- cursor animation
  {
    'gen740/SmoothCursor.nvim',
    config = function()
      require('smoothcursor').setup {
        type = 'default', -- "default", "exp", "matrix", etc.
        fancy = {
          enable = true,
          head = { cursor = '', texthl = 'SmoothCursor', linehl = nil },
          body = {
            { cursor = '●', texthl = 'SmoothCursorRed' },
            { cursor = '●', texthl = 'SmoothCursorOrange' },
            { cursor = '●', texthl = 'SmoothCursorYellow' },
          },
          tail = { cursor = nil, texthl = 'SmoothCursor' },
        },
      }
    end,
  },
  -- C plugins
  -- debugger UI
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap' },
    config = function()
      require('dapui').setup()
      -- Automatically open/close UI when debugging starts/stops
      local dap, dapui = require 'dap', require 'dapui'
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },
  {
    'p00f/clangd_extensions.nvim',
    lazy = true,
    config = function()
      require('clangd_extensions').setup {
        extensions = {
          autoSetHints = true,
          hover_with_actions = true,
        },
      }
    end,
    ast = {
      role_icons = {
        type = '',
        declaration = '',
        expression = '',
        specifier = '',
        statement = '',
        ['template argument'] = '',
      },
      kind_icons = {
        Compound = '',
        Recovery = '',
        TranslationUnit = '',
        PackExpansion = '',
        TemplateTypeParm = '',
        TemplateTemplateParm = '',
        TemplateParamObject = '',
      },
    },
  },
  -- {
  --   'simrat3/rust-tools.nvim',
  --   url = 'git@github.com:simrat3/rust-tools.nvim.git',
  --   ft = 'rust', -- Only load for Rust files
  --   config = function()
  --     require('rust-tools').setup()
  --   end
  -- },
  -------------------
  -- {
  --   'xeluxee/competitest.nvim',
  --   dependencies = 'MunifTanjim/nui.nvim',
  --   config = function()
  --     require('competitest').setup {
  --       local_config_file_name = '.competitest.lua',
  --
  --       floating_border = 'rounded',
  --       floating_border_highlight = 'FloatBorder',
  --       picker_ui = {
  --         width = 0.2,
  --         height = 0.3,
  --         mappings = {
  --           focus_next = { 'j', '<down>', '<Tab>' },
  --           focus_prev = { 'k', '<up>', '<S-Tab>' },
  --           close = { '<esc>', '<C-c>', 'q', 'Q' },
  --           submit = '<cr>',
  --         },
  --       },
  --       editor_ui = {
  --         popup_width = 0.4,
  --         popup_height = 0.6,
  --         show_nu = true,
  --         show_rnu = false,
  --         normal_mode_mappings = {
  --           switch_window = { '<C-h>', '<C-l>', '<C-i>' },
  --           save_and_close = '<C-s>',
  --           cancel = { 'q', 'Q' },
  --         },
  --         insert_mode_mappings = {
  --           switch_window = { '<C-h>', '<C-l>', '<C-i>' },
  --           save_and_close = '<C-s>',
  --           cancel = '<C-q>',
  --         },
  --       },
  --       runner_ui = {
  --         interface = 'popup',
  --         selector_show_nu = false,
  --         selector_show_rnu = false,
  --         show_nu = true,
  --         show_rnu = false,
  --         mappings = {
  --           run_again = 'R',
  --           run_all_again = '<C-r>',
  --           kill = 'K',
  --           kill_all = '<C-k>',
  --           view_input = { 'i', 'I' },
  --           view_output = { 'a', 'A' },
  --           view_stdout = { 'o', 'O' },
  --           view_stderr = { 'e', 'E' },
  --           toggle_diff = { 'd', 'D' },
  --           close = { 'q', 'Q' },
  --         },
  --         viewer = {
  --           width = 0.5,
  --           height = 0.5,
  --           show_nu = true,
  --           show_rnu = false,
  --         },
  --       },
  --       popup_ui = {
  --         total_width = 0.8,
  --         total_height = 0.8,
  --         layout = {
  --           { 4, 'tc' },
  --           { 5, { { 1, 'so' }, { 1, 'si' } } },
  --           { 5, { { 1, 'eo' }, { 1, 'se' } } },
  --         },
  --       },
  --       split_ui = {
  --         position = 'right',
  --         relative_to_editor = true,
  --         total_width = 0.3,
  --         vertical_layout = {
  --           { 1, 'tc' },
  --           { 1, { { 1, 'so' }, { 1, 'eo' } } },
  --           { 1, { { 1, 'si' }, { 1, 'se' } } },
  --         },
  --         total_height = 0.4,
  --         horizontal_layout = {
  --           { 2, 'tc' },
  --           { 3, { { 1, 'so' }, { 1, 'si' } } },
  --           { 3, { { 1, 'eo' }, { 1, 'se' } } },
  --         },
  --       },
  --
  --       save_current_file = true,
  --       save_all_files = false,
  --       compile_directory = '.',
  --       compile_command = {
  --         c = { exec = 'gcc', args = { '-Wall', '$(FNAME)', '-o', '$(FNOEXT)' } },
  --         cpp = { exec = 'g++', args = { '-Wall', '$(FNAME)', '-o', '$(FNOEXT)' } },
  --         rust = { exec = 'rustc', args = { '$(FNAME)' } },
  --         java = { exec = 'javac', args = { '$(FNAME)' } },
  --       },
  --       running_directory = '.',
  --       run_command = {
  --         c = { exec = './$(FNOEXT)' },
  --         cpp = { exec = './$(FNOEXT)' },
  --         rust = { exec = './$(FNOEXT)' },
  --         python = { exec = 'python', args = { '$(FNAME)' } },
  --         java = { exec = 'java', args = { '$(FNOEXT)' } },
  --       },
  --       multiple_testing = -1,
  --       maximum_time = 5000,
  --       output_compare_method = 'squish',
  --       view_output_diff = false,
  --
  --       testcases_directory = '.',
  --       testcases_use_single_file = false,
  --       testcases_auto_detect_storage = true,
  --       testcases_single_file_format = '$(FNOEXT).testcases',
  --       testcases_input_file_format = '$(FNOEXT)_input$(TCNUM).txt',
  --       testcases_output_file_format = '$(FNOEXT)_output$(TCNUM).txt',
  --
  --       companion_port = 27121,
  --       receive_print_message = true,
  --       start_receiving_persistently_on_setup = false,
  --       template_file = false,
  --       evaluate_template_modifiers = false,
  --       date_format = '%c',
  --       received_files_extension = 'cpp',
  --       received_problems_path = '$(CWD)/$(PROBLEM).$(FEXT)',
  --       received_problems_prompt_path = true,
  --       received_contests_directory = '$(CWD)',
  --       received_contests_problems_path = '$(PROBLEM).$(FEXT)',
  --       received_contests_prompt_directory = true,
  --       received_contests_prompt_extension = true,
  --       open_received_problems = true,
  --       open_received_contests = true,
  --       replace_received_testcases = false,
  --     }
  --   end,
  -- },

  -- Debug Adapter Protocol
  {
    'mfussenegger/nvim-dap',
    optional = true,
    dependencies = {
      -- Ensure C/C++ debugger is installed
      'williamboman/mason.nvim',
      optional = true,
      opts = { ensure_installed = { 'codelldb' } },
    },
    opts = function()
      local dap = require 'dap'
      if not dap.adapters['codelldb'] then
        require('dap').adapters['codelldb'] = {
          type = 'server',
          host = 'localhost',
          port = '${port}',
          executable = {
            command = 'codelldb',
            args = {
              '--port',
              '${port}',
            },
          },
        }
      end
      for _, lang in ipairs { 'c', 'cpp' } do
        dap.configurations[lang] = {
          {
            type = 'codelldb',
            request = 'launch',
            name = 'Launch file',
            program = function()
              return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
          },
          {
            type = 'codelldb',
            request = 'attach',
            name = 'Attach to process',
            pid = require('dap.utils').pick_process,
            cwd = '${workspaceFolder}',
          },
        }
      end
    end,
  },
  -- C++ Snippets
  {
    'rafamadriz/friendly-snippets',
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  },

  -- multiple cursor
  {
    'jake-stewart/multicursor.nvim',
    branch = '1.0',
    config = function()
      local mc = require 'multicursor-nvim'
      mc.setup()

      local set = vim.keymap.set

      -- Add or skip cursor above/below the main cursor.
      set({ 'n', 'x' }, '<up>', function()
        mc.lineAddCursor(-1)
      end)
      set({ 'n', 'x' }, '<down>', function()
        mc.lineAddCursor(1)
      end)
      set({ 'n', 'x' }, '<leader><up>', function()
        mc.lineSkipCursor(-1)
      end)
      set({ 'n', 'x' }, '<leader><down>', function()
        mc.lineSkipCursor(1)
      end)

      -- Add or skip adding a new cursor by matching word/selection
      set({ 'n', 'x' }, '<leader>n', function()
        mc.matchAddCursor(1)
      end)
      set({ 'n', 'x' }, '<leader>s', function()
        mc.matchSkipCursor(1)
      end)
      set({ 'n', 'x' }, '<leader>N', function()
        mc.matchAddCursor(-1)
      end)
      set({ 'n', 'x' }, '<leader>S', function()
        mc.matchSkipCursor(-1)
      end)

      -- Add and remove cursors with control + left click.
      set('n', '<c-leftmouse>', mc.handleMouse)
      set('n', '<c-leftdrag>', mc.handleMouseDrag)
      set('n', '<c-leftrelease>', mc.handleMouseRelease)

      -- Disable and enable cursors.
      set({ 'n', 'x' }, '<c-q>', mc.toggleCursor)

      -- Mappings defined in a keymap layer only apply when there are
      -- multiple cursors. This lets you have overlapping mappings.
      mc.addKeymapLayer(function(layerSet)
        -- Select a different cursor as the main one.
        layerSet({ 'n', 'x' }, '<left>', mc.prevCursor)
        layerSet({ 'n', 'x' }, '<right>', mc.nextCursor)

        -- Delete the main cursor.
        layerSet({ 'n', 'x' }, '<leader>x', mc.deleteCursor)

        -- Enable and clear cursors using escape.
        layerSet('n', '<esc>', function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)

      -- Customize how cursors look.
      local hl = vim.api.nvim_set_hl
      hl(0, 'MultiCursorCursor', { reverse = true })
      hl(0, 'MultiCursorVisual', { link = 'Visual' })
      hl(0, 'MultiCursorSign', { link = 'SignColumn' })
      hl(0, 'MultiCursorMatchPreview', { link = 'Search' })
      hl(0, 'MultiCursorDisabledCursor', { reverse = true })
      hl(0, 'MultiCursorDisabledVisual', { link = 'Visual' })
      hl(0, 'MultiCursorDisabledSign', { link = 'SignColumn' })
    end,
  },
  -- Core note-taking
  {
    'epwalsh/obsidian.nvim',
    version = '*',
    ft = 'markdown',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('obsidian').setup {
        dir = '$HOME/notes',
        -- notes_subdir = 'notes',
        -- daily_notes = {
        --   folder = 'journal',
        --   date_format = '%Y-%m-%d',
        -- },
        -- templates = {
        --   subdir = 'templates',
        --   date_format = '%Y-%m-%d',
        --   time_format = '%H:%M',
        -- },
        ui = {
          enable = true, -- Keep UI features enabled
        },
        -- Set recommended markdown settings
        -- markdown = {
        --   subdirs = { 'notes', 'journal' },
        --   link_style = 'markdown',
        -- },
      }

      -- Set recommended conceal level for markdown files
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'markdown',
        callback = function()
          vim.opt_local.conceallevel = 2 -- Required for Obsidian's syntax features
          -- vim.opt_local.spell = true -- Optional: enable spell check
          vim.opt_local.wrap = true -- Optional: wrap long lines
        end,
      })
    end,
  },

  -- Distraction-free writing
  { 'junegunn/goyo.vim' },
  { 'junegunn/limelight.vim' },

  -- Todo comments
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = false,
      keywords = {
        TODO = { icon = '', color = 'info' },
        FIX = { icon = '', color = 'error' },
        NOTE = { icon = '', color = 'hint' },
      },
    },
  },

  -- Markdown support
  {
    'preservim/vim-markdown',
    ft = 'markdown',
    init = function()
      vim.g.vim_markdown_conceal = 1
      vim.g.vim_markdown_conceal_code_blocks = 0
    end,
  },

  -- Templates
  {
    'aperezdc/vim-template',
    config = function()
      -- Set template directory and ensure it exists
      local template_dir = vim.fn.expand '$HOME/.config/nvim/templates'
      if vim.fn.isdirectory(template_dir) == 0 then
        vim.fn.mkdir(template_dir, 'p')
      end

      -- Create C++ template if it doesn't exist
      local cpp_template = template_dir .. '/cpp.tpl'
      if vim.fn.filereadable(cpp_template) == 0 then
        local file = io.open(cpp_template, 'w')
        if file then
          file:write [[
//stdc++.h>
using namespace std;

#define DEBUG(x) cerr << #x << " = " << x << '\n'
#define all(x) x.begin(), x.end()
#define pb push_back
#define mp make_pair
#define endl '\n'
#define fi first
#define se second

typedef long long ll;
typedef pair<int, int> pii;
typedef vector<int> vi;

const int INF = 1e9;
const ll LLINF = 4e18;
const int MOD = 1000000007;

void solve() {
    // Your code here
    
}

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);

    int t = 1;
    // cin >> t;
    while (t--) {
        solve();
    }

    return 0;
}
]]
          file:close()
        end
      end

      vim.g.templates_directory = template_dir
      vim.g.templates_no_builtin_templates = 1
      vim.g.templates_global_name_prefix = 'tpl_'

      -- Add C++ specific template mapping
      vim.g.templates_user_variables = {
        ['CPP'] = {
          filename = function()
            return vim.fn.expand '%:t:r'
          end,
          date = function()
            return os.date '%Y-%m-%d'
          end,
        },
      }

      -- Disable template auto-loading in Goyo mode (kept from your original)
      vim.cmd [[
        augroup TemplateGoyo
            autocmd!
            autocmd User GoyoEnter let g:templates_auto_initialize = 0
            autocmd User GoyoLeave let g:templates_auto_initialize = 1
        augroup END
        ]]

      -- Add autocmd for C++ files
      vim.api.nvim_create_autocmd('BufNewFile', {
        pattern = '*.cpp',
        callback = function()
          if vim.fn.line '$' == 1 and vim.fn.getline(1) == '' then
            vim.cmd '0r $HOME/.config/nvim/templates/cpp.tpl'
            -- Position cursor inside solve() function
            vim.cmd 'normal! gg'
            -- vim.cmd '/solve()'
            vim.cmd 'normal! j'
          end
        end,
      })
    end,
  },

  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to automatically pass options to a plugin's `setup()` function, forcing the plugin to be loaded.
  --

  -- Alternatively, use `config = function() ... end` for full control over the configuration.
  -- If you prefer to call `setup` explicitly, use:
  --    {
  --        'lewis6991/gitsigns.nvim',
  --        config = function()
  --            require('gitsigns').setup({
  --                -- Your gitsigns configuration here
  --            })
  --        end,
  --    }
  --
  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`.
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.opt.timeoutlen
      delay = 0,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- CP shit
      vim.keymap.set('n', '<leader>ci', function()
        vim.cmd 'w'
        local filename = vim.fn.expand '%:r'
        vim.cmd('!g++ -std=c++17 -Wall -Wextra -Wshadow -O2 -o ' .. filename .. ' %')
        -- Create input.txt if it doesn't exist
        if vim.fn.filereadable 'input.txt' == 0 then
          vim.fn.writefile({}, 'input.txt')
        end
        vim.cmd('!./' .. filename .. ' < input.txt')
      end, { desc = '[C]++ run with [I]nput' })
      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by nvim-cmp
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- Find references for the word under your cursor.
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        bashls = {},
        clangd = {
          capabilities = {
            offsetEncoding = 'utf-8',
          },
          cmd = {
            'clangd',
            '--background-index',
            '--clang-tidy',
            '--header-insertion=never',
            '--completion-style=detailed',
            '--function-arg-placeholders',
            '--fallback-style=llvm',
          },
          filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
        },
        -- clangd = {},
        -- gopls = {},
        -- pyright = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`ts_ls`) will work just fine
        -- ts_ls = {},
        --

        lua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --
      -- To check the current status of installed tools and/or manually install
      -- other tools, you can run
      --    :Mason
      --
      -- You can press `g?` for help in this menu.
      --
      -- `mason` had to be setup earlier: to configure its options see the
      -- `dependencies` table for `nvim-lspconfig` above.
      --
      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
        sh = { 'shfmt' },
      },
    },
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp-signature-help',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ['<C-y>'] = cmp.mapping.confirm { select = true },

          -- If you prefer more traditional completion keymaps,
          -- you can uncomment the following lines
          ['<CR>'] = cmp.mapping.confirm { select = true },
          ['<Tab>'] = cmp.mapping.confirm { select = true },
          --['<S-Tab>'] = cmp.mapping.select_prev_item(),

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },
        sources = {
          {
            name = 'lazydev',
            -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
            group_index = 0,
          },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'nvim_lsp_signature_help' },
        },
      }
    end,
  },

  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'catppuccin/nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('catppuccin').setup {
        flavour = 'mocha', -- latte, frappe, macchiato, mocha
        background = {
          light = 'latte',
          dark = 'mocha',
        },
        transparent_background = false, -- disables setting the background color.
        show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
        term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
        dim_inactive = {
          enabled = false, -- dims the background color of inactive window
          shade = 'dark',
          percentage = 0.15, -- percentage of the shade to apply to the inactive window
        },
        no_italic = false, -- Force no italic
        no_bold = false, -- Force no bold
        no_underline = false, -- Force no underline
        styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
          comments = { 'italic' }, -- Change the style of comments
          conditionals = { 'italic' },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
          -- miscs = {}, -- Uncomment to turn off hard-coded styles
        },
        color_overrides = {},
        custom_highlights = {},
        default_integrations = true,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          notify = false,
          mini = {
            enabled = true,
            indentscope_color = '',
          },
          -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
        },
      }

      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'catppuccin'
    end,
  },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'cpp',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'dart',
        'java',
        'kotlin',
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },

  -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  require 'kickstart.plugins.debug',
  require 'kickstart.plugins.indent_line',
  require 'kickstart.plugins.lint',
  require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',
  require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  -- { import = 'custom.plugins' },
  --
  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  -- Or use telescope!
  -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
  -- you can continue same window with `<space>sr` which resumes last telescope search
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
vim.api.nvim_create_autocmd('BufNewFile', {
  pattern = '*.cpp',
  callback = function()
    -- Only insert template if file is empty
    if vim.fn.line '$' == 1 and vim.fn.getline(1) == '' then
      vim.cmd '0r $HOME/.config/nvim/templates/cpp.tpl'
      -- Move cursor to solve() function
      vim.cmd '/solve()'
      vim.cmd 'normal! j'
    end
  end,
})
vim.api.nvim_create_autocmd('BufNewFile', {
  pattern = '*.c',
  callback = function()
    if vim.fn.line '$' == 1 and vim.fn.getline(1) == '' then
      vim.cmd '0r $HOME/.config/nvim/templates/c.tpl'
      vim.cmd 'normal! Gk'
    end
  end,
})
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

-- Keymaps
-- See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, { desc = 'Signature Help' })
-- Keymaps for notes and tasks
local map = vim.keymap.set

-- Note management
map('n', '<leader>nn', ':e $HOME/notes/scratch.md<CR>', { desc = 'New [N]ote' })
map('n', '<leader>nt', ':Template<CR>', { desc = '[N]ote [T]emplate' })
map('n', '<leader>nf', ':Goyo<CR>', { desc = '[N]ote [F]ocus mode' })
map('n', '<leader>nl', ':Limelight!!<CR>', { desc = '[N]ote [L]imelight' })

-- Task management
map('n', '<leader>tt', ':TodoTelescope<CR>', { desc = '[T]odo list' })
map('n', '<leader>td', ':TodoQuickFix<CR>', { desc = '[T]odo [D]etails' })
map('n', '<leader>ta', ':TodoTrouble<CR>', { desc = '[T]odo [A]ll' })

-- CP keymaps
vim.keymap.set('n', '<leader>cc', ':w | !g++ -std=c++17 -O2 -Wall -Wshadow -Wno-sign-compare -DLOCAL -o %:r %<CR>', { desc = 'Tourist-style compile' })
vim.keymap.set('n', '<leader>cr', ':!./%:r<CR>', { desc = '[C]++ [R]un' })
vim.keymap.set('n', '<leader>ct', ':w | !g++ -std=c++17 -Wall -Wextra -Wshadow -g -o %:r %<CR>', { desc = '[C]++ [T]est build (debug)' })

-- For quick testing with input files
vim.keymap.set('n', '<leader>ci', function()
  vim.cmd 'w'
  local filename = vim.fn.expand '%:r'

  -- Create input.txt if it doesn't exist
  if vim.fn.filereadable 'input.txt' == 0 then
    vim.fn.writefile({}, 'input.txt')
    print 'Created empty input.txt'
  end

  local cmd = 'g++ -std=c++17 -Wall -Wextra -Wshadow -O2 -o ' .. filename .. ' % && ./' .. filename .. ' < input.txt'
  vim.cmd('belowright split | terminal ' .. cmd)
  vim.cmd 'startinsert'
end, { desc = '[C]++ run with [I]nput (clean terminal)' })
vim.keymap.set('n', '<leader>co', ':e output.txt<CR>', { desc = '[C]++ open [O]utput' })

-- mapping to compare against expected output
vim.keymap.set('n', '<leader>co', function()
  vim.cmd 'w'
  local filename = vim.fn.expand '%:r'
  vim.cmd('silent !g++ -std=c++17 -Wall -Wextra -Wshadow -O2 -o ' .. filename .. ' %')
  vim.cmd('silent !./' .. filename .. ' < input.txt > output.txt')
  vim.cmd 'vsplit output.txt'
end, { desc = '[C]ompile and save [O]utput' })
-- Create input/output files if they don't exist
vim.keymap.set('n', '<leader>ii', function()
  if vim.fn.filereadable 'input.txt' == 0 then
    vim.fn.writefile({}, 'input.txt')
    print 'Created input.txt'
  else
    print 'input.txt already exists'
  end
end, { desc = '[I]nitialize [I]nput file' })

vim.keymap.set('n', '<leader>io', function()
  if vim.fn.filereadable 'output.txt' == 0 then
    vim.fn.writefile({}, 'output.txt')
    print 'Created output.txt'
  else
    print 'output.txt already exists'
  end
end, { desc = '[I]nitialize [O]utput file' })

-- Quickly open input/output files
vim.keymap.set('n', '<leader>vi', ':e input.txt<CR>', { desc = '[V]iew [I]nput' })
vim.keymap.set('n', '<leader>vo', ':e output.txt<CR>', { desc = '[V]iew [O]utput' })
------

vim.keymap.set('n', '<leader>ri', function()
  -- Save and compile
  vim.cmd 'w | !g++ -std=c++17 -Wall -Wextra -Wshadow -O2 -o %:r %'

  -- Run with input.txt and show clean output
  local output = vim.fn.system('./' .. vim.fn.expand '%:r' .. ' < input.txt')
  print('\nProgram output:\n' .. output)
end, { desc = '[R]un with [I]nput (clean output)' })
-----------------------------------------

-- C-specific keymaps
vim.keymap.set('n', '<leader>gc', ':w | !gcc -Wall -Wextra -Werror -g -o %:r %<CR>', { desc = '[G]CC [C]ompile' })
vim.keymap.set('n', '<leader>gr', ':!./%:r<CR>', { desc = '[G]CC [R]un' })

-- Debugger keymaps
vim.keymap.set('n', '<F5>', function()
  require('dap').continue()
end, { desc = 'Debug: Start/Continue' })
vim.keymap.set('n', '<F10>', function()
  require('dap').step_over()
end, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F11>', function()
  require('dap').step_into()
end, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F12>', function()
  require('dap').step_out()
end, { desc = 'Debug: Step Out' })
vim.keymap.set('n', '<leader>lp', function()
  require('dap').set_breakpoint(nil, nil, vim.fn.input 'Log point message: ')
end, { desc = 'Debug: Set Log Point' })
vim.keymap.set('n', '<leader>dr', function()
  require('dap').repl.open()
end, { desc = 'Debug: Open REPL' })
vim.keymap.set('n', '<leader>dl', function()
  require('dap').run_last()
end, { desc = 'Debug: Run Last' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have coliding keymaps or are not able to send distinct keycodes
vim.keymap.set('n', '<C-S-h>', '<C-w>H', { desc = 'Move window to the left' })
vim.keymap.set('n', '<C-S-l>', '<C-w>L', { desc = 'Move window to the right' })
vim.keymap.set('n', '<C-S-j>', '<C-w>J', { desc = 'Move window to the lower' })
vim.keymap.set('n', '<C-S-k>', '<C-w>K', { desc = 'Move window to the upper' })
