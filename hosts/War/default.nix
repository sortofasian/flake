{ pkgs, ... }: {
    custom = {
        neovim.enable = true;
        neovim.dev = true;
        direnv.enable = true;
        user.name = "charlie";
        user.home = "/Users/charlie";
    };
    homebrew.casks = [
        "utm"
        "discord"
        "firefox"
        "neovide"
        "obsidian"

        "unity-hub"
        "visual-studio-code"
    ];
    environment.systemPackages = with pkgs; [
        jetbrains.rider
        dotnet-sdk
        mono
    ];
}
