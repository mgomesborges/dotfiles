local themes = require('telescope.themes')
local actions = require('telescope.actions')
local path = require('telescope.path')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values

local M = {}

function open_existing_or_new_tab(prompt_bufnr)
  local entry = actions.get_selected_entry()
  actions.close(prompt_bufnr)

  if not entry then
    print("[telescope] Nothing currently selected")
    return
  end

  local filename = entry.path or entry.filename
  filename = path.normalize(filename, vim.fn.getcwd())

  for _,tabnum in ipairs(vim.api.nvim_list_tabpages()) do
    local wins = vim.api.nvim_tabpage_list_wins(tabnum)
    for _,winid in ipairs(wins) do
      local bufnr = vim.api.nvim_win_get_buf(winid)
      local bufname = path.normalize(vim.api.nvim_buf_get_name(bufnr), vim.fn.getcwd())
      if bufname == filename or bufnr == entry.bufnr then
        vim.api.nvim_set_current_tabpage(tabnum)
        vim.api.nvim_set_current_win(winid)
        return
      end
    end
  end

  if entry.bufnr then
    vim.cmd(string.format(":tab sb %d", entry.bufnr))
  else
    vim.cmd(string.format(":tabedit %s", filename))
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_option(bufnr, "buflisted", true)
  end
end

M.find_files = function()
  require('telescope.builtin').find_files({
    attach_mappings = function(prompt_bufnr, map)
      map('i', '<C-t>', open_existing_or_new_tab)
      return true
    end
  })
end

M.myles_find_files = function()
  require('myles').find_files({
    previewer = false,
    attach_mappings = function(prompt_bufnr, map)
      map('i', '<C-t>', open_existing_or_new_tab)
      return true
    end
  })
end

M.buffers = function()
  local opts = {
    previewer = false,
  }
  opts.attach_mappings = function(prompt_bufnr, map)
    map('i', '<C-t>', open_existing_or_new_tab)
    return true
  end
  require('telescope.builtin').buffers(opts)
end

M.select = function(title, items, callback)
  local opts = themes.get_dropdown{
    previewer = false,
  }
  pickers.new(opts, {
    prompt = title,
    finder = finders.new_table {
      results = items
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions.goto_file_selection_edit:replace(function()
        local selection = actions.get_selected_entry()
        actions.close(prompt_bufnr)
        if type(callback) == "string" then
          vim.call(callback, selection.value)
        else
          callback(selection.value)
        end
      end)

      return true
    end
  }):find()
end

return M
