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
    proton-ge = call pkgs/proton-ge.nix;
    lug-helper = call pkgs/lug-helper.nix;
    gitCustom = call pkgs/git.nix;
    alacritty = call pkgs/alacritty.nix;
    rofi = call pkgs/rofi;
    nerdfonts = call pkgs/nerdfonts;
    neovim = call pkgs/neovim;
    i3 = call pkgs/i3;
    dunst = call pkgs/dunst;
})
