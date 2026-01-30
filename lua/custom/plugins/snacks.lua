return {
  'folke/snacks.nvim',
  lazy = false,
  opts = {
    lazygit = { enabled = true },
    gitbrowse = { enabled = true },
    terminal = { enabled = true },
  },
  keys = {
    { '<leader>gB', function() Snacks.gitbrowse() end, desc = '[G]it [B]rowse (open in browser)', mode = { 'n', 'v' } },
    { '<leader>gf', function() Snacks.lazygit.log_file() end, desc = '[G]it log current [f]ile' },
    { '<leader>gg', function() Snacks.lazygit() end, desc = 'Open Lazy[g]it' },
    { '<leader>gl', function() Snacks.lazygit.log() end, desc = '[G]it [l]og' },
    {
      '<leader>gy',
      function()
        Snacks.gitbrowse { open = function(url) vim.fn.setreg('+', url) vim.notify('Copied: ' .. url) end }
      end,
      desc = '[G]it [y]ank permalink',
      mode = { 'n', 'v' },
    },
    { '<leader>tt', function() Snacks.terminal.toggle() end, desc = '[T]oggle [t]erminal' },
  },
}
