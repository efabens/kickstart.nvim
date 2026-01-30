return {
  'romgrk/barbar.nvim',
  dependencies = {
    'lewis6991/gitsigns.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  event = 'VeryLazy',
  init = function()
    vim.g.barbar_auto_setup = false
  end,
  opts = {
    animation = false,
    auto_hide = false,
    sidebar_filetypes = {
      ['neo-tree'] = { event = 'BufWipeout', text = 'File Explorer' },
    },
  },
  keys = {
    { '<S-h>', '<cmd>BufferPrevious<CR>', desc = 'Prev buffer' },
    { '<S-l>', '<cmd>BufferNext<CR>', desc = 'Next buffer' },
    { '<leader>bp', '<cmd>BufferPin<CR>', desc = '[B]uffer [p]in' },
    { '<leader>bc', '<cmd>BufferPickDelete<CR>', desc = '[B]uffer pick [c]lose' },
    { '<leader>bx', '<cmd>BufferClose<CR>', desc = '[B]uffer close' },
    { '<leader>bb', '<cmd>BufferPick<CR>', desc = '[B]uffer pick' },
  },
}
