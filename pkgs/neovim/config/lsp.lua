local lspconfig = require('lspconfig')
local cmplsp = require('cmp_nvim_lsp')
local capabilities = cmplsp.default_capabilities()

local servers = {
    'hls',
    'html',
    'cssls',
    'taplo',
    'vimls',
    'svelte',
    'nil_ls',
    'clangd',
    'bashls',
    'eslint',
    'jsonls',
    'yamlls',
    'pyright',
    'dockerls',
    'prismals',
    'tsserver',
    'sumneko_lua',
    'tailwindcss',
    'cssmodules_ls',
    'rust_analyzer',
    'java_language_server'
}
for _, server in ipairs(servers) do
    if server == 'java_language_server' then
        lspconfig[server].setup {
            capabilities = capabilities,
            cmd = { 'java-language-server' }
        }
        break
    end
    lspconfig[server].setup {
        capabilities = capabilities
    }
end
