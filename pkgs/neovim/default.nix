{ pkgs, lib, symlinkJoin, makeWrapper }:
let
    prisma-language-server = pkgs.nodePackages."@prisma/language-server";
    tailwindcss-language-server = pkgs.nodePackages."@tailwindcss/language-server";
    omnisharp-roslyn = pkgs.callPackage ./omnisharp-roslyn  {};
    inherit (pkgs.callPackage ./cssmodules-lsp {}) cssmodules-language-server;

    inherit (pkgs.vimUtils) buildVimPlugin;

    nvim-transparent = buildVimPlugin {
        name = "nvim-transparent";
        src = pkgs.fetchFromGitHub {
            owner = "xiyaowong";
            repo = "nvim-transparent";
            rev = "6816751e3d595b3209aa475a83b6fbaa3a5ccc98";
            sha256 = "sha256-j1PO0r2q5w0fJvO7BG0xXDjIdOVl73eGO1rclB221uw=";
        };
    };

    neovim = with lib; (pkgs.neovim.override  {
        configure.customRC = concatMapStrings
            # Read config file contents; supports lua files
            (f: if hasSuffix ".lua" f then
                    "lua << EOF\n ${builtins.readFile f} \nEOF\n"
                else if hasSuffix ".vim" f then
                    builtins.readFile f
            else "")
            # get all files in the config dir
            (filesystem.listFilesRecursive ./config);

        configure.packages.neovimPlugins.start = with pkgs.vimPlugins; [
            plenary-nvim

            alpha-nvim tokyonight-nvim neoformat
            nvim-lspconfig nvim-treesitter.withAllGrammars

            telescope-nvim telescope-fzf-native-nvim
            telescope-file-browser-nvim

            luasnip nvim-cmp cmp-path cmp-emoji cmp_luasnip
            cmp-nvim-lsp lspkind-nvim rust-tools-nvim
            #nvim-jdtls

            gitsigns-nvim lualine-nvim lsp-status-nvim
            nvim-highlight-colors trouble-nvim nvim-web-devicons
        ] ++ [
            nvim-transparent
        ];
    });
in symlinkJoin {
    name = "neovim";
    paths = [ neovim pkgs.neovide ];

    nvimpath = lib.strings.makeBinPath (with pkgs; [
        nil taplo clang-tools rust-analyzer jdt-language-server
        java-language-server lua-language-server
        ripgrep fd
    ] ++ (if pkgs.stdenv.isLinux
        then [ xclip ] else [])
    ++ (with pkgs.nodePackages; [
        pyright vim-language-server bash-language-server
        vscode-langservers-extracted dockerfile-language-server-nodejs
        yaml-language-server svelte-language-server typescript-language-server
    ]) ++ [
        tailwindcss-language-server omnisharp-roslyn
        prisma-language-server cssmodules-language-server
    ]);

    buildInputs = [ makeWrapper ];
    postBuild = ''
        wrapProgram $out/bin/nvim --suffix PATH : $nvimpath
        wrapProgram $out/bin/neovide --set NEOVIDE_MULTIGRID true
    '';
}
