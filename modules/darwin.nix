{ pkgs, config, ... }:
{
    services.nix-daemon.enable = true;
    environment.systemPackages = with pkgs; [
        gnupg
    ];

}
