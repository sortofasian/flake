require('nvim-treesitter.configs').setup {
    highlight = {
        enable = true
    }
}

local gitsigns = require('gitsigns')
gitsigns.setup { signcolumn = true }

require("transparent").setup({
    enable = true,
    extra_groups = {},
    exclude = {}
})
