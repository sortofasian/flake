{ lib, pkgs, config, system, ... }: let
    inherit (lib)
        mkMerge;
    inherit (lib.generators)
        toGitINI;
    inherit (lib.custom)
        switchSystem;
    inherit (pkgs)
        writeText;
    inherit (config.age)
        secrets;

    systemConfig = {
        url."git@github.com:".insteadOf = [
            "https://github.com/"
            "gh:"
        ];
        gpg.format = "ssh";
        tag.gpgSign = true;
        commit.gpgSign = true;
        pull.rebase = true;
        push.autoSetupRemote = true;
        fetch.prune = true;
        init.defaultBranch = "main";
        status.short = true;
    };
    userConfig = {
        user.name = "Charlie Syvertsen";
        user.email = "charliesyvertsen06@icloud.com";
        alias.yk5 = "config user.signingkey ${secrets.ssh-yubikey-5.path}";
        alias.yk5c = "config user.signingkey ${secrets.ssh-yubikey-5c.path}";
    };
in mkMerge [
    (switchSystem system {
        linux.programs.git = {
            enable = true;
            package = pkgs.gitFull;
            config = systemConfig;
        };
        darwin.environment = {
            systemPackages = [ pkgs.gitFull ];
            variables.GIT_CONFIG_SYSTEM = "${
                writeText "gitconfig" (toGitINI systemConfig)
            }";
        };
    })
    { custom.user.configFile."git/config".text = toGitINI userConfig; }
]
