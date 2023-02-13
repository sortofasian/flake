require('nvim-treesitter.configs').setup {
    highlight = { enable = true }
}


require('colorizer').setup {
    user_default_options = {
        RGB=true,
        RRGGBB=true,
        RRGGBBAA=true,
        rgb_fn=true,
        hsl=true,
        tailwind=true,
        mode="foreground"
    }
}


local gitsigns = require('gitsigns')
gitsigns.setup { signcolumn = true }


require("transparent").setup({
    enable = true,
    extra_groups = {},
    exclude = {}
})


require('lualine').setup({
    sections = { lualine_c = {
        'lsp_progress'
    }}
})


local alpha = require('alpha')
require('alpha.term')
alpha.setup({
    opts={margin=44},
    layout = {
        {type='padding', val=5},
        {
            type='text',
            val = {
                "███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
                "████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
                "██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
                "██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
                "██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
                "╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝"
            },
            opts={position='center'}
        }
    }
})
