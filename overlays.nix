{ stable, system }:
(final: prev: let
    call = with builtins; pkg: prev.callPackage pkg (
        let
            args = functionArgs (import pkg);
        in mapAttrs (name: _:
        if name == "pkgs" 
            then prev
        else if name == "stable"
            then import stable { inherit system; }
        else getAttr name prev
        ) args
    );
in {
    i3 = call pkgs/i3;
    rofi = call pkgs/rofi;
    dunst = call pkgs/dunst;
    neovim = call pkgs/neovim;
    gitCustom = call pkgs/git.nix;
    nerdfonts = call pkgs/nerdfonts;
    alacritty = call pkgs/alacritty.nix;
    proton-ge = call pkgs/proton-ge.nix;
    lug-helper = call pkgs/lug-helper.nix;
})
