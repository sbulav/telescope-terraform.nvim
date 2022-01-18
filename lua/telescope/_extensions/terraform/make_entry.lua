local entry_display = require "telescope.pickers.entry_display"
local terraform_utils = require "telescope._extensions.terraform.utils"
local terraform_make_entry = {}

function terraform_make_entry.gen_from_plan(opts)
  opts = opts or {}
  local icons = {
    create = "+",
    destroy = "-",
    change = "~",
  }

  local displayer = entry_display.create {
    separator = "|",
    items = {
      { width = 2 },
      { width = 30 },
      { width = 30 },
      { remaining = true },
    },
  }

  local status_map = {
    ["create"] = { icon = icons.create, hl = "TelescopeResultsDiffAdd" },
    ["destroy"] = { icon = icons.destroy, hl = "TelescopeResultsDiffDelete" },
    ["change"] = { icon = icons.change, hl = "TelescopeResultsDiffChange" },
    ["update"] = { icon = icons.change, hl = "TelescopeResultsDiffChange" },
  }

  local make_display = function(entry)
    local status_x = {}
    status_x = status_map[entry.action] or {}

    local empty_space = ""
    return displayer {
      { status_x.icon or empty_space, status_x.hl },
      entry.resource_type,
      entry.resource_name,
      entry.resource_addr,
    }
  end

  return function(entry)
    if entry == "" then
      return nil
    end
    local supported_types = { planned_change = "", resource_drift = "" }
    local tmp_table = terraform_utils.json_decode(entry)
    if supported_types[tmp_table.type] == nil then
      return nil
    end

    local action = tmp_table.change.action or ""
    local resource_type = tmp_table.change.resource.resource_type or ""
    local resource_name = tmp_table.change.resource.resource_name or ""
    local resource_provider = tmp_table.change.resource.implied_provider or ""
    local resource_addr = tmp_table.change.resource.addr or ""

    return {
      resource_name = resource_name,
      resource_type = resource_type,
      resource_provider = resource_provider,
      resource_addr = resource_addr,
      value = resource_addr,
      action = action,
      ordinal = entry,
      display = make_display,
      change = tmp_table.change,
    }
  end
end

return terraform_make_entry
