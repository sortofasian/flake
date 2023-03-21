{ lib, pkgs, config, system, ... }: let
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
    userConfig = { user = {
        name = "Charlie Syvertsen";
        email = "charliesyvertsen06@icloud.com";
        signingKey = secrets.ssh.path;
    }; };
in (switchSystem system ({
    linux.programs.git = { inherit config; };
    darwin.environment.variables.GIT_CONFIG_SYSTEM = "${
        writeText "gitconfig" systemConfig
    }";
})) // {
    environment.systemPackages = [ pkgs.gitFull ];
    custom.user.configFile."git/config".text = toGitINI userConfig;
}
