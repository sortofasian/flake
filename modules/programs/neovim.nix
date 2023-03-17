{ pkgs, lib, config, system, ... }: let
    inherit (lib)
        mkOption
        types
        mkIf;
    inherit (pkgs)
        symlinkJoin;
    inherit (lib.strings)
        makeBinPath;
    inherit (lib.custom)
        switchSystem;
    inherit (config.custom.neovim)
        enable;
in {
    options.custom.neovim = {
        enable = mkOption {
            type = types.bool;
            default = false;
        };
    };

    config = mkIf enable {
        environment.systemPackages = [(symlinkJoin {
            name = "neovim";
            paths = [ pkgs.neovim ];

            nvimpath = makeBinPath (
                (with pkgs; [
                    nil
                    taplo
                    clang-tools
                    rust-analyzer
                    java-language-server
                    lua-language-server
                  # haskell-language-server
                    fd
                    ripgrep
                ])
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
               # ++ [
                 #  tailwindcss-language-server
                 #  omnisharp-roslyn
                 #  prisma-language-server cssmodules-language-server
               # ]
                ++ (switchSystem system {linux = [pkgs.xclip]; darwin = [];})
            );
        })];
    };
}
