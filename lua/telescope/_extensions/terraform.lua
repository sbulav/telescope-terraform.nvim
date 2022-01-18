local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  error "This extension requires telescope.nvim (https://github.com/nvim-telescope/telescope.nvim)"
end

local terraform_builtin = require "telescope._extensions.terraform.builtin"

return require("telescope").register_extension {
  exports = {
    apply = terraform_builtin.apply,
    destroy = terraform_builtin.destroy,
    plan = terraform_builtin.plan,
    plan_targeted = terraform_builtin.plan_targeted,
  },
}
