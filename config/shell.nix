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

    config = let
        shellPackages = with pkgs; [
            bat
            exa
            btop
            ouch
            ripgrep
            gitFull
            starship
            tealdeer
            rm-improved
            any-nix-shell
        ];
    in mkIf shell.enable (mkMerge [
        {
            users.users.${user.name}.shell = pkgs.fish;
            environment.systemPackages = shellPackages;
            environment.shellAliases = {
                la = "ls -a";
                ta = "tr -a";
                tr = "ls --tree -L 3";
                ls = ''exa ''\
                    --long ''\
                    --binary ''\
                    --icons ''\
                    --color=auto ''\
                    --group-directories-first ''\
                    --git ''\
                    --time modified'';
                programs.fish = {
                    enable = true;
                    useBabelfish = true;
                    promptInit = ''
                        any-nix-shell fish | source
                        starship init fish | source
                    '';
                };
            };
        }
        (switchSystem system { darwin = {
            environment.shells = [ pkgs.fish ];
            environtment.loginShell = pkgs.fish;
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
