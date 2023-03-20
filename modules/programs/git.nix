{ lib, pkgs, system, ... }: let
    inherit (lib.generators)
        toGitINI;
    inherit (lib.custom)
        switchSystem;
    inherit (pkgs)
        writeText;
    inherit (config.age)
        secrets;
    config = {
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
    userConfig = { user = {
        name = "Charlie Syvertsen";
        email = "charliesyvertsen06@icloud.com";
        signingKey = switchSystem system {
            linux = secrets.ssh.path;
            darwin = "~/.ssh/identity.pub";
        };
    }; };
    configText = writeText "gitconfig-system" (toGitINI config);
    userConfigText = writeText "gitconfig-global" (toGitINI userConfig);
in (switchSystem system ({
    linux.programs.git = { inherit config; };
    darwin.environment.variables.GIT_CONFIG_SYSTEM = "${configText}";
})) // { custom.user.configFile."git/config".source = userConfigText; }
