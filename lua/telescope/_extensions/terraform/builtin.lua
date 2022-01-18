local actions = require "telescope.actions"
local conf = require("telescope.config").values
local finders = require "telescope.finders"
local log = require "telescope.log"
local pickers = require "telescope.pickers"
local popup = require "plenary.popup"
local terraform_actions = require "telescope._extensions.terraform.actions"
local terraform_make_entry = require "telescope._extensions.terraform.make_entry"
local terraform_previewers = require "telescope._extensions.terraform.previewers"
local terraform_utils = require "telescope._extensions.terraform.utils"

local B = {}

local function msgLoadingPopup(msg, cmd, complete_fn)
  local row = math.floor((vim.o.lines - 5) / 2)
  local width = math.floor(vim.o.columns / 1.5)
  local col = math.floor((vim.o.columns - width) / 2)
  for _ = 1, (width - #msg) / 2, 1 do
    msg = " " .. msg
  end
  local prompt_win, prompt_opts = popup.create(msg, {
    border = {},
    borderchars = conf.borderchars,
    height = 5,
    col = col,
    line = row,
    width = width,
  })
  vim.api.nvim_win_set_option(prompt_win, "winhl", "Normal:TelescopeNormal")
  vim.api.nvim_win_set_option(prompt_win, "winblend", 0)
  local prompt_border_win = prompt_opts.border and prompt_opts.border.win_id
  if prompt_border_win then
    vim.api.nvim_win_set_option(prompt_border_win, "winhl", "Normal:TelescopePromptBorder")
  end
  vim.defer_fn(
    vim.schedule_wrap(function()
      local results = terraform_utils.get_os_command_output(cmd)
      if not pcall(vim.api.nvim_win_close, prompt_win, true) then
        log.trace("Unable to close window: ", "Terraform", "/", prompt_win)
      end
      complete_fn(results)
    end),
    10
  )
end

B.plan = function(opts)
  opts = opts or {}
  opts.limit = opts.limit or 100
  opts.wincmd = opts.wincmd or "botright vnew"
  opts.wrap = opts.wrap or "nowrap"
  opts.filetype = opts.filetype or "bash"
  opts.timeout = opts.timeout or 1000
  opts.wait_interval = opts.wait_interval or 2
  opts.mode = "async"

  local cmd = vim.tbl_flatten { "terraform", "plan", "-json", "-no-color", "-input=false" }
  local title = "Terraform plan"
  msgLoadingPopup("Loading " .. title, cmd, function(results)
    if results[1] == "" then
      print("Empty " .. title)
      return
    end
    pickers.new(opts, {
      prompt_title = title,
      finder = finders.new_table {
        results = results,
        entry_maker = terraform_make_entry.gen_from_plan(opts),
      },
      previewer = terraform_previewers.plan_preview.new(opts),
      sorter = conf.file_sorter(opts),
      attach_mappings = function(_, map)
        actions.select_default:replace(terraform_actions.append_resource_addr)
        map("i", "<c-a>", terraform_actions.apply(opts))
        map("i", "<c-d>", terraform_actions.destroy(opts))
        return true
      end,
    }):find()
  end)
end

B.plan_targeted = function(opts)
  opts = opts or {}
  opts.limit = opts.limit or 100
  local cmd = vim.tbl_flatten { "terraform", "plan", "-json", "-no-color", "-input=false" }
  local title = "Terraform plan targeted"
  msgLoadingPopup("Loading " .. title, cmd, function(results)
    if results[1] == "" then
      print("Empty " .. title)
      return
    end
    pickers.new(opts, {
      prompt_title = title,
      finder = finders.new_table {
        results = results,
        entry_maker = terraform_make_entry.gen_from_plan(opts),
      },
      previewer = terraform_previewers.plan_targeted_preview.new(opts),
      sorter = conf.file_sorter(opts),
    }):find()
  end)
end

B.destroy = function(opts)
  opts = opts or {}
  opts.limit = opts.limit or 100
  opts.wincmd = opts.wincmd or "botright vnew"
  opts.wrap = opts.wrap or "nowrap"
  opts.filetype = opts.filetype or "bash"
  opts.timeout = opts.timeout or 10000
  opts.wait_interval = opts.wait_interval or 5
  opts.mode = opts.mode or "async"

  terraform_actions.destroy(opts)()
end

B.apply = function(opts)
  opts = opts or {}
  opts.limit = opts.limit or 100
  opts.wincmd = opts.wincmd or "botright vnew"
  opts.wrap = opts.wrap or "nowrap"
  opts.filetype = opts.filetype or "bash"
  opts.timeout = opts.timeout or 10000
  opts.wait_interval = opts.wait_interval or 5
  opts.mode = opts.mode or "async"

  terraform_actions.apply(opts)()
end

B.init = function(opts)
  opts = opts or {}
  opts.limit = opts.limit or 100
  opts.wincmd = opts.wincmd or "botright vnew"
  opts.wrap = opts.wrap or "nowrap"
  opts.filetype = opts.filetype or "bash"
  opts.timeout = opts.timeout or 10000
  opts.wait_interval = opts.wait_interval or 5
  opts.mode = opts.mode or "async"

  terraform_actions.init(opts)()
end

return B
