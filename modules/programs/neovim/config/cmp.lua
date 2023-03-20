local cmp = require('cmp')
local lspkind = require('lspkind')
local luasnip = require('luasnip')

local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
    snippet = {expand = function(args) luasnip.lsp_expand(args.body) end},
    window = {
        documentation = cmp.config.window.bordered(),
        completion = cmp.config
    },
    completion = {
        autocomplete = false
    },
    sources = cmp.config.sources({
        {name = 'path'},
        {name = 'emoji'},
        {name = 'luasnip'},
        {name = 'nvim_lsp'},
    }),
    formatting = {
        format = lspkind.cmp_format({
            mode = 'symbol_text',
            menu = ({
                path = 'Path',
                emoji = 'Emoji',
                luasnip = 'Snip',
                nvim_lsp = 'Lsp',
            })
        })
    },
    mapping = {
        ["<C-Space>"] = cmp.mapping(function(_)
               cmp.complete()
            end,
            {"i"}),
        ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end,
            {"i"}),
        ["<S-Tab>"] = cmp.mapping(function (fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end,
            {"i"}),
        ['<Esc>'] = cmp.mapping.abort(),
        ['<C-u>'] = cmp.mapping.scroll_docs(4),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(8),
        ['<C-b>'] = cmp.mapping.scroll_docs(-8),
        ['<CR>'] = cmp.mapping.confirm({select = true}),
    },
})
