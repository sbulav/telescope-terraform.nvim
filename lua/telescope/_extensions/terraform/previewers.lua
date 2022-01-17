local previewers = require("telescope.previewers")
local utils = require("telescope.utils")
local defaulter = utils.make_default_callable
local putils = require("telescope.previewers.utils")
local P = {}

P.plan_preview = defaulter(function(opts)
	return previewers.new_buffer_previewer({
		get_buffer_by_name = function(_, entry)
			return entry.id
		end,

		define_preview = function(self, entry)
			-- local terraform_command = {}

			-- if entry.resource_addr then
			-- 	terraform_command = { "terraform", "plan", "-target=" .. entry.resource_addr }
			-- else
			-- 	terraform_command({ "echo", "empty" })
			-- end

			vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, vim.split(entry.ordinal, ","))
			putils.regex_highlighter(self.state.bufnr, "action")
		end,
	})
end, {})

return P
