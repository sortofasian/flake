{ pkgs, lib, ... }:
{

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
        GNUPGHOME = "$XDG_DATA_HOME/gnupg";
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
