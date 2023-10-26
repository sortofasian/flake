{ pkgs, lib, config, system, ... }: let
    inherit (lib)
        mkMerge;
    inherit (lib.custom)
        switchSystem;
    inherit (config.custom)
        user;
in {
    config = mkMerge [
        {
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
                eza
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
                ls = "eza "
                    + "--long "
                    + "--binary "
                    + "--icons "
                    + "--color=auto "
                    + "--group-directories-first "
                    + "--git "
                    + "--time modified";
            };
        }
        (switchSystem system {
            linux = {
                programs.command-not-found.enable = false;
            };
            darwin = {
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
            };
        })
    ];
}
