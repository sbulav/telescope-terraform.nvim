local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local flatten = vim.tbl_flatten
local Job = require "plenary.job"

local A = {}

A.append_resource_addr = function(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  actions.close(prompt_bufnr)
  if selection.resource_addr == "" then
    return
  end
  if vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), "modifiable") then
    vim.api.nvim_put({ selection.resource_addr }, "b", true, true)
  end
end

A.apply = function(opts)
  return function(prompt_bufnr)
    if prompt_bufnr ~= nil then
      actions.close(prompt_bufnr)
    end
    local apply_output = {}
    local args = { "apply", "-auto-approve", "-no-color", "-input=false" }
    vim.api.nvim_command(opts.wincmd)
    local buf = vim.api.nvim_get_current_buf()

    vim.api.nvim_buf_set_name(0, "result #" .. buf)

    vim.api.nvim_buf_set_option(0, "buftype", "nofile")
    vim.api.nvim_buf_set_option(0, "swapfile", false)
    vim.api.nvim_buf_set_option(0, "filetype", opts.filetype)
    vim.api.nvim_buf_set_option(0, "bufhidden", "wipe")
    vim.api.nvim_command("setlocal " .. opts.wrap)
    vim.api.nvim_command "setlocal cursorline"

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Retrieving log, please wait..." })

    local on_output = function(_, line)
      table.insert(apply_output, line)

      pcall(vim.schedule_wrap(function()
        if vim.api.nvim_buf_is_valid(buf) then
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, apply_output)
        end
      end))
    end

    local job = Job:new {
      enable_recording = true,
      command = "terraform",
      args = flatten(args),
      on_stdout = on_output,
      on_stderr = on_output,

      on_exit = function(_, status)
        if status == 0 then
          print "Terraform apply completed!"
        end
      end,
    }
    if opts.mode == "sync" then
      job:sync(opts.timeout, opts.wait_interval)
    else
      job:start()
    end
  end
end

A.destroy = function(opts)
  return function(prompt_bufnr)
    if prompt_bufnr ~= nil then
      actions.close(prompt_bufnr)
    end
    local ans = vim.fn.input "[TF] are you sure you want to destroy infrastructure? y/n: "
    if ans == "n" then
      return
    end

    local apply_output = {}
    local args = { "apply", "-destroy", "-auto-approve", "-no-color", "-input=false" }
    vim.api.nvim_command(opts.wincmd)
    local buf = vim.api.nvim_get_current_buf()

    vim.api.nvim_buf_set_name(0, "result #" .. buf)

    vim.api.nvim_buf_set_option(0, "buftype", "nofile")
    vim.api.nvim_buf_set_option(0, "swapfile", false)
    vim.api.nvim_buf_set_option(0, "filetype", opts.filetype)
    vim.api.nvim_buf_set_option(0, "bufhidden", "wipe")
    vim.api.nvim_command("setlocal " .. opts.wrap)
    vim.api.nvim_command "setlocal cursorline"

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Retrieving log, please wait..." })
    table.insert(apply_output, "")

    local on_output = function(_, line)
      table.insert(apply_output, line)

      pcall(vim.schedule_wrap(function()
        if vim.api.nvim_buf_is_valid(buf) then
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, apply_output)
        end
      end))
    end

    local job = Job:new {
      enable_recording = true,
      command = "terraform",
      args = flatten(args),
      on_stdout = on_output,
      on_stderr = on_output,

      on_exit = function(_, status)
        if status == 0 then
          print "Terraform apply completed!"
        end
      end,
    }

    if opts.mode == "sync" then
      job:sync(opts.timeout, opts.wait_interval)
    else
      job:start()
    end
  end
end
return A
