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
  opts = function()
    local always_show = { 'dev-eli', '.tfview' }
    local always_show_by_pattern = {}
    local cwd = vim.loop.cwd()

    local function parse_toml_string_array(value)
      local out = {}
      local body = value:match '^%[(.*)%]$'
      if not body then
        return out
      end
      for token in body:gmatch('"([^"]-)"') do
        table.insert(out, token)
      end
      return out
    end

    local function load_repo_core_config(base_dir)
      local json_path = base_dir .. '/core.json'
      local toml_path = base_dir .. '/core.toml'

      if vim.fn.filereadable(json_path) == 1 then
        local ok_read, lines = pcall(vim.fn.readfile, json_path)
        if not ok_read then
          vim.notify('neo-tree: failed to read ' .. json_path, vim.log.levels.WARN)
          return {}
        end

        local ok_decode, data = pcall(vim.json.decode, table.concat(lines, '\n'))
        if not ok_decode or type(data) ~= 'table' then
          vim.notify('neo-tree: invalid JSON in ' .. json_path, vim.log.levels.WARN)
          return {}
        end

        return data
      end

      if vim.fn.filereadable(toml_path) == 1 then
        local ok_read, lines = pcall(vim.fn.readfile, toml_path)
        if not ok_read then
          vim.notify('neo-tree: failed to read ' .. toml_path, vim.log.levels.WARN)
          return {}
        end

        local data = {}
        local in_neo_tree = false
        for _, raw_line in ipairs(lines) do
          local line = vim.trim(raw_line)
          if line ~= '' and not line:match '^#' then
            if line == '[neo_tree]' or line == '[neotree]' then
              in_neo_tree = true
              data.neo_tree = data.neo_tree or {}
            elseif line:match '^%[.+%]$' then
              in_neo_tree = false
            elseif in_neo_tree then
              local key, value = line:match '^([%w_]+)%s*=%s*(.+)$'
              if key == 'always_show' then
                data.neo_tree.always_show = parse_toml_string_array(vim.trim(value))
              elseif key == 'always_show_by_pattern' then
                data.neo_tree.always_show_by_pattern = parse_toml_string_array(vim.trim(value))
              end
            end
          end
        end

        return data
      end

      return {}
    end

    -- Add repo-specific entries here keyed by repo directory name.
    local per_repo_always_show = {
      -- ['my-repo'] = { '.example-dir' },
    }
    local repo_name = vim.fn.fnamemodify(cwd, ':t')
    for _, name in ipairs(per_repo_always_show[repo_name] or {}) do
      table.insert(always_show, name)
    end

    -- Optional repo-local config in .evim/core.json or .evim/core.toml.
    -- Example:
    -- {
    --   "neo_tree": {
    --     "always_show": [".cool-ignored-folder"],
    --     "always_show_by_pattern": ["*.tfvars"]
    --   }
    -- }
    -- TOML:
    -- [neo_tree]
    -- always_show = [".cool-ignored-folder"]
    -- always_show_by_pattern = ["*.tfvars"]
    local repo_core = load_repo_core_config(cwd .. '/.evim')
    local neo_tree_cfg = repo_core.neo_tree or repo_core.neotree or {}
    if type(neo_tree_cfg.always_show) == 'table' then
      for _, name in ipairs(neo_tree_cfg.always_show) do
        if type(name) == 'string' then
          table.insert(always_show, name)
        end
      end
    end
    if type(neo_tree_cfg.always_show_by_pattern) == 'table' then
      for _, pattern in ipairs(neo_tree_cfg.always_show_by_pattern) do
        if type(pattern) == 'string' then
          table.insert(always_show_by_pattern, pattern)
        end
      end
    end

    return {
      window = {
        mappings = {
          ['<space>'] = 'none', -- pass leader through to global mappings
        },
      },
      filesystem = {
        bind_to_cwd = true,
        cwd_target = {
          sidebar = 'global',
          current = 'global',
        },
        follow_current_file = { enabled = true },
        find_by_full_path_words = true,
        filtered_items = {
          hide_gitignored = true,
          always_show = always_show,
          always_show_by_pattern = always_show_by_pattern,
        },

        window = {
          mappings = {
            ['\\'] = 'close_window',
          },
        },
      },
    }
  end,
}
