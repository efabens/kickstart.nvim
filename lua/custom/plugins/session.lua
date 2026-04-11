-- Session management - auto-saves and restores sessions per directory
return {
  'folke/persistence.nvim',
  event = 'BufReadPre',
  opts = {
    pre_save = function()
      local function should_drop_buffer(buf)
        local name = vim.api.nvim_buf_get_name(buf)
        local filetype = vim.bo[buf].filetype
        if name:match 'neo%-tree' or filetype == 'neo-tree' then
          return true
        end
        if filetype == 'netrw' then
          return true
        end
        return name ~= '' and vim.fn.isdirectory(name) == 1
      end

      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if should_drop_buffer(buf) then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end
    end,
  },
  init = function()
    local function should_drop_buffer(buf)
      local name = vim.api.nvim_buf_get_name(buf)
      local filetype = vim.bo[buf].filetype
      if name:match 'neo%-tree' or filetype == 'neo-tree' then
        return true
      end
      if filetype == 'netrw' then
        return true
      end
      return name ~= '' and vim.fn.isdirectory(name) == 1
    end

    vim.api.nvim_create_autocmd('VimEnter', {
      group = vim.api.nvim_create_augroup('restore_session', { clear = true }),
      callback = function()
        if vim.fn.argc() == 0 and not vim.g.started_with_stdin then
          require('persistence').load()
          vim.schedule(function()
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if should_drop_buffer(buf) then
                vim.api.nvim_buf_delete(buf, { force = true })
              end
            end
          end)
        end
      end,
      nested = true,
    })
  end,
  keys = {
    {
      '<leader>Sr',
      function()
        require('persistence').load()
      end,
      desc = '[S]ession [r]estore',
    },
    {
      '<leader>Sl',
      function()
        require('persistence').load { last = true }
      end,
      desc = '[S]ession [l]ast',
    },
    {
      '<leader>Ss',
      function()
        require('persistence').stop()
      end,
      desc = '[S]ession [s]top saving',
    },
  },
}
