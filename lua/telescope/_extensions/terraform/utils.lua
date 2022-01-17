local Job = require("plenary.job")

local terraform_utils = {}

--- Decodes from JSON.
---
---@param data table of strings Data to decode
---@returns table json_obj Decoded JSON object
terraform_utils.json_decode = function(data)
	local decoded_value = {}
	ok, decoded_value = pcall(vim.fn.json_decode, data)

	return decoded_value
end

--- Decodes from JSON.
---
---@param data table of strings Data to decode
---@returns table json_obj Decoded JSON object
terraform_utils.json_decode_file = function(data)
	local tmp_table = {}
	local decoded_value = {}
	for _, value in pairs(data) do
		ok, decoded_value = pcall(vim.fn.json_decode, value)
		if ok then
			table.insert(tmp_table, decoded_value)
		end
	end

	return tmp_table
end

--- load changes from saved plan
---@param path string
---@return table : json data
---@return boolean : error
terraform_utils.load = function(path)
	vim.validate({
		path = { path, "s" },
	})

	if vim.fn.filereadable(path) == 0 then
		return {}
	end

	local decoded, err = terraform_utils.json_decode_file(vim.fn.readfile(path))
	if err ~= nil then
		print("error", err)
		return {}, true
	end
	if decoded == nil then
		return {}
	end

	return decoded or {}
end

--- Execute command
function terraform_utils.get_os_command_output(cmd, cwd, timeout)
	timeout = timeout or 20000
	if type(cmd) ~= "table" then
		print("Telescope: [get_os_command_output]: cmd has to be a table")
		return {}
	end
	local command = table.remove(cmd, 1)
	local stderr = {}
	local stdout, ret = Job
		:new({
			command = command,
			args = cmd,
			cwd = cwd,
			on_stderr = function(_, data)
				table.insert(stderr, data)
			end,
		})
		:sync(timeout, 20)
	return stdout, ret, stderr
end

return terraform_utils
