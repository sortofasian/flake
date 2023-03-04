require('nvim-treesitter.configs').setup {
    highlight = { enable = true }
}


require('nvim-highlight-colors').setup {
    render = 'background',
    enable_tailwind = true
}


local gitsigns = require('gitsigns')
gitsigns.setup { signcolumn = true }


require("transparent").setup({
    enable = true,
    extra_groups = {},
    exclude = {}
})


require('trouble').setup({
})


local alpha = require('alpha')
require('alpha.term')
alpha.setup({
    opts = { margin = 44 },
    layout = {
        { type = 'padding', val = 5 },
        {
            type = 'text',
            val = {
                "███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
                "████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
                "██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
                "██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
                "██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
                "╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝"
            },
            opts = { position = 'center' }
        }
    }
})
