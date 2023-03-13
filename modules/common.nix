{ pkgs, lib, ... }:
{

    environment.variables = {
        EDITOR          = "nvim";
        GNUPGHOME = "$XDG_DATA_HOME/gnupg";
    };

    environment.systemPackages = with pkgs; [
        hex
        hurl
        xplr
        neovim
        alacritty
        diskonaut
        gitCustom
    ];
#    programs.gnupg.agent.enable = true;
}
