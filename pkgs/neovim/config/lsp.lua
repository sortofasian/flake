local lspconfig = require('lspconfig')
local cmplsp = require('cmp_nvim_lsp')
local capabilities = cmplsp.default_capabilities()

vim.keymap.set('n', '<Backspace>', vim.lsp.buf.format)
vim.keymap.set('n', '<Leader><Leader>', function()
    for _=1,2 do vim.lsp.buf.hover() end
end)

local servers = {
    'rust_analyzer', 'java_language_server',
    'hls', 'html', 'cssls', 'taplo', 'vimls',
    'svelte', 'nil_ls', 'clangd', 'bashls', 'eslint',
    'jsonls', 'yamlls', 'pyright', 'dockerls', 'prismals',
    'tsserver', 'sumneko_lua', 'tailwindcss', 'cssmodules_ls'
}

local override = function(server)
    if server == 'java_language_server' then
        lspconfig[server].setup {
            capabilities = capabilities,
            cmd = { 'java-language-server' },
            root_dir = lspconfig.util.root_pattern(vim.fn.getcwd())
        }
        return true
    end
    return false
end

for _, server in ipairs(servers) do
    if not override(servers) then
        lspconfig[server].setup {capabilities = capabilities}
    end
end
