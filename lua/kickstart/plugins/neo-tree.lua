-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    { '<leader>e', ':Neotree toggle<CR>', desc = 'Toggle file [E]xplorer', silent = true },
    {
      '<leader>o',
      function()
        local manager = require 'neo-tree.sources.manager'
        local state = manager.get_state 'filesystem'
        local window_exists = state.winid and vim.api.nvim_win_is_valid(state.winid)

        if not window_exists then
          vim.cmd 'Neotree focus'
        elseif vim.bo.filetype == 'neo-tree' then
          vim.cmd 'wincmd p'
        else
          vim.cmd 'Neotree focus'
        end
      end,
      desc = '[O]pen/focus file browser',
      silent = true,
    },
  },
  opts = {
    window = {
      mappings = {
        ['<space>'] = 'none', -- pass leader through to global mappings
      },
    },
    filesystem = {
      follow_current_file = { enabled = true },
      find_by_full_path_words = true,
      filtered_items = {
        hide_gitignored = true,
        always_show = { 'dev-eli' },
      },

      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
}
