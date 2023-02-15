local lspconfig = require('lspconfig')
local cmplsp = require('cmp_nvim_lsp')
local capabilities = cmplsp.default_capabilities()

vim.keymap.set('n', '<Backspace>', vim.lsp.buf.format)
vim.keymap.set('n', '<Leader><Leader>', function()
    for _ = 1, 2 do vim.lsp.buf.hover() end
end)

local servers = {
    'rust_analyzer', 'java_language_server',
    'svelte', 'nil_ls', 'clangd', 'bashls', 'eslint',
    'hls', 'html', 'cssls', 'taplo', 'vimls', 'omnisharp',
    'jsonls', 'yamlls', 'pyright', 'dockerls', 'prismals',
    'tsserver', 'sumneko_lua', 'tailwindcss', 'cssmodules_ls'
}

local override = function(server)
    if server == 'java_language_server' then
        lspconfig[server].setup {
            capabilities = capabilities,
            cmd = { 'java-language-server' },
            root_dir = function(_) return vim.fn.getcwd() end
        }
        return true
    end

    if server == 'omnisharp' then
        lspconfig[server].setup {
            capabilities = capabilities,
            cmd = { 'OmniSharp', '--languageserver', '--hostPID', tostring(vim.fn.getpid()) }
--'mono', '--assembly-loader=strict', 
--'/Users/charlie/Source/omnisharp-roslyn/artifacts/publish/OmniSharp.Stdio.Driver/mono/OmniSharp.exe'
        }
        return true
    end

    return false
end

for _, server in ipairs(servers) do
    if (not override(server)) then
        lspconfig[server].setup { capabilities = capabilities }
    end
end
