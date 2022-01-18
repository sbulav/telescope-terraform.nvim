# telescope-terraform.nvim

[WIP] Integration with terraform CLI

## Installation

### Vim-Plug

```viml
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-terraform.nvim'
```

### Packer

```lua
use {
    "nvim-telescope/telescope.nvim",
    requires = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope-terraform.nvim" },
    },
}
```

## Setup and Configuration

```lua
require('telescope').load_extension('terraform')
```

## Usage

```viml
Telescope terraform init
Telescope terraform apply
Telescope terraform destroy
Telescope terraform plan
Telescope terraform plan_targeted

"Using lua function
lua require('telescope').extensions.terraform.init()<cr>
lua require('telescope').extensions.terraform.apply()<cr>
lua require('telescope').extensions.terraform.destroy()<cr>
lua require('telescope').extensions.terraform.plan()<cr>
lua require('telescope').extensions.terraform.plan_targeted()<cr>

```

## Options

//TODO

## terraform init
[Detail](https://www.terraform.io/cli/commands/init)  

| Query         | filter                                                |
|---------------|-------------------------------------------------------|
| wincmd        | Command to open log window, default = 'botright vnew' |
| wrap          | Wrap lines in log window, default = 'nowrap'          |
| filetype      | Filetype to use on log window, default='bash'         |
| timeout       | Timeout for sync mode, default = '10000'              |
| wait_interval | Wait interval for sync mode, default = '5'            |
| mode          | Mode to populate log window, default = 'async'        |

## terraform apply
[Detail](https://www.terraform.io/cli/commands/apply)

| Query         | filter                                                |
|---------------|-------------------------------------------------------|
| wincmd        | Command to open log window, default = 'botright vnew' |
| wrap          | Wrap lines in log window, default = 'nowrap'          |
| filetype      | Filetype to use on log window, default='bash'         |
| timeout       | Timeout for sync mode, default = '10000'              |
| wait_interval | Wait interval for sync mode, default = '5'            |
| mode          | Mode to populate log window, default = 'async'        |

## terraform destroy

[Detail](https://www.terraform.io/cli/commands/destroy)

| Query         | filter                                                |
|---------------|-------------------------------------------------------|
| wincmd        | Command to open log window, default = 'botright vnew' |
| wrap          | Wrap lines in log window, default = 'nowrap'          |
| filetype      | Filetype to use on log window, default='bash'         |
| timeout       | Timeout for sync mode, default = '10000'              |
| wait_interval | Wait interval for sync mode, default = '5'            |
| mode          | Mode to populate log window, default = 'async'        |

## terraform plan

[Detail](https://www.terraform.io/cli/commands/plan)

| Query         | filter                                                |
|---------------|-------------------------------------------------------|
| wincmd        | Command to open log window, default = 'botright vnew' |
| wrap          | Wrap lines in log window, default = 'nowrap'          |
| filetype      | Filetype to use on log window, default='bash'         |
| timeout       | Timeout for sync mode, default = '10000'              |
| wait_interval | Wait interval for sync mode, default = '5'            |
| mode          | Mode to populate log window, default = 'async'        |

### Key mappings

| key     | Usage                                        |
|---------|----------------------------------------------|
| `<cr>`  | append resource address to the buffer        |
| `<c-a>` | start terraform apply                        |
| `<c-d>` | start terraform destroy                      |
| `<c-i>` | start terraform init                         |

## terraform plan_targeted

//TODO
[Detail](https://www.terraform.io/cli/commands/plan)
