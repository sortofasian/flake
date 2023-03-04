{ pkgs, ... }:
{
    networking.hostName = "War";

    imports = [ ./settings.nix ];

    users.users.charlie.shell = pkgs.fish;

    homebrew.casks = [
        "utm"
        "steam"
        "docker"
        "blender"
        "discord"
        "firefox"
        "neovide"
        "obsidian"
        "unity-hub"
        "transmission"
    ];

    #homebrew.masApps = { mas no longer maintained? https://github.com/mas-cli/mas/issues/486
#        Shadowrocket = 932747118; iOS apps behave weirdly
    #};
}
