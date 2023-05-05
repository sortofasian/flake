{ pkgs, ... }: {
    custom = {
        neovim.enable = true;
        neovim.dev = true;
        direnv.enable = true;
        user.name = "charlie";
        user.home = "/Users/charlie";
        theme.colorscheme = "darkviolet";
    };
    homebrew.casks = [
        "utm"
        "discord"
        "firefox"
        "neovide"
        "clockify"
        "obsidian"
        "bitwarden"
        "docker"
        "docker-completion"
        "docker-compose"

        "unity-hub"
        "visual-studio-code"
    ];
    environment.systemPackages = with pkgs; [
        jetbrains.rider
        dotnet-sdk
        mono
    ];
}
