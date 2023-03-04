{ pkgs, lib, config, system, ... }: let
    inherit (lib)
        mkOption
        types
        mkIf
        symlinkJoin;
    inherit (lib.strings)
        makeBinPath;
in {
    options.modules.neovim = {
        enable = mkOption {
            type = types.bool;
            default = false;
        };
        full = mkOption {
            type = types.bool;
            default = false;
        };
        neovide = mkOption {
            type = types.bool;
            default = false;
        };
    };

    config = mkIf config.modules.neovim.enable {
        environment.systemPackages = symlinkJoin {
            name = "neovim";
            paths = [ pkgs.neovim ];

            nvimpath = makeBinPath
                (with pkgs; [
                    nil
                    taplo
                    clang-tools
                    rust-analyzer
                    java-language-server
                    lua-language-server
                    haskell-language-server
                    fd
                    ripgrep
            ] ++ (if system == "x86_64-linux" then [xclip] else [])
                ++ (with pkgs.nodePackages; [
                    pyright
                    vim-language-server
                    bash-language-server
                    vscode-langservers-extracted
                    dockerfile-language-server-nodejs
                    yaml-language-server
                    svelte-language-server
                    typescript-language-server
                ])
                ++ [
                    tailwindcss-language-server
                    omnisharp-roslyn
                    prisma-language-server cssmodules-language-server
                ]
            );
        };
    };
}
