{ pkgs, lib, ... }:
{
    nix.gc.automatic = true;
    nix.settings = {
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = true;
    };

    nixpkgs = {
        config = {
            allowUnfree = true;
            allowUnsupportedSystem = true;
            allowBroken = true;
        };
    };

    fonts = {
        fontDir.enable = true;
        fonts = with pkgs; [
            (nerdfonts.override { fonts = [ "FiraCode" "Noto" ]; })
            noto-fonts
            noto-fonts-emoji
            noto-fonts-cjk-sans
            noto-fonts-cjk-serif
        ];
    };

    environment.variables = {
        EDITOR          = "nvim";
        XDG_CACHE_HOME  = "$HOME/.cache";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_BIN_HOME    = "$HOME/.local/bin";
        XDG_DATA_HOME   = "$HOME/.local/share";
        XDG_STATE_HOME  = "$HOME/.local/state";
        GNUPGHOME = "$XDG_DATA_HOME/gnupg";
        LESSHISTFILE="$XDG_STATE_HOME/lesshst";
        HISTFILE="$XDG_STATE_HOME/bash/history";
    };

    programs.fish = {
        enable = true;
        useBabelfish = true;
        promptInit = ''
            any-nix-shell fish | source
            starship init fish | source
        '';
    };

    environment.systemPackages = with pkgs; [
        bat
        exa
        hex
        hurl
        btop
        ouch
        xplr
        neovim
        ripgrep
        starship
        tealdeer
        alacritty
        diskonaut
        gitCustom
        rm-improved
        any-nix-shell
    ];

    environment.shellAliases = {
        la = "ls -a";
        ta = "tr -a";
        tr = "ls --tree -L 3";
        ls = "exa --long --binary --icons --color=auto --group-directories-first --git --time modified";
    };

#    programs.gnupg.agent.enable = true;
}
