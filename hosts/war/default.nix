{ pkgs, ... }:
{
    networking.hostName = "War";

    imports = [ ./settings.nix ];

    users.users.charlie.shell = pkgs.fish;
    #users.users.charlie.packages = with pkgs; [];

    homebrew.casks = [
        "utm"
        "discord"
        "firefox"
        "neovide"
        "obsidian"
        "unity-hub"
    ];

    #homebrew.masApps = { mas no longer maintained? https://github.com/mas-cli/mas/issues/486
#        Shadowrocket = 932747118; iOS apps behave weirdly
    #};
}
