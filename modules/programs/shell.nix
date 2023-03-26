{ pkgs, lib, config, system, ... }: let
    inherit (lib)
        mkIf
        types
        mkMerge
        mkOption;
    inherit (lib.custom)
        switchSystem;
    inherit (config.custom)
        user
        shell;
in {
    options.custom.shell.enable = mkOption {
        type = types.bool;
        default = false;
    };

    config = mkIf shell.enable (mkMerge [
        {
            programs.command-not-found.enable = false;
            programs.nix-index.enable = true;
            programs.fish = {
                enable = true;
                useBabelfish = true;
                promptInit = ''
                    any-nix-shell fish | source
                    starship init fish | source
                '';
            };
            users.users.${user.name}.shell = pkgs.fish;
            environment.systemPackages = with pkgs; [
                bat
                exa
                btop
                ouch
                ripgrep
                starship
                tealdeer
                rm-improved
                any-nix-shell
            ];
            environment.shellAliases = {
                la = "ls -a";
                ta = "tr -a";
                tr = "ls --tree -L 3";
                ls = "exa "
                    + "--long "
                    + "--binary "
                    + "--icons "
                    + "--color=auto "
                    + "--group-directories-first "
                    + "--git "
                    + "--time modified";
            };
        }
        (switchSystem system { linux = {}; darwin = {
            security.pam.enableSudoTouchIdAuth = true;
            environment.shells = [ pkgs.fish ];
            environment.loginShell = pkgs.fish;
            programs.fish = {
                babelfishPackage = pkgs.babelfish;
                promptInit = ''
                    fish_add_path --prepend --global \
                        "$HOME/.nix-profile/bin" \
                        /nix/var/nix/profiles/default/bin \
                        /run/current-system/sw/bin

                    any-nix-shell fish | source
                    starship init fish | source
                '';
            };
        }; })
    ]);
}
