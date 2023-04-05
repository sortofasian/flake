{
    custom = {
        user.name = "charlie";
        bootMode = "legacy";
        swapSize = "32G";
    };

    users.users.charlie.openssh.authorizedKeys.keys = [
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIGAZ20Nex1SQQIT0kMZK9mH8GN+kqiMvvShf+iVX+QRMAAAABHNzaDo="
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIJGJEy5RTs9BvlvwTiSV/BmR9IPnH+yGmcPRvHng7ESyAAAABHNzaDo="
    ];

    networking = {
        useDHCP = false;
        defaultGateway = "10.10.1.1";
        nameservers = [
            "1.1.1.1"
            "1.0.0.1"
            "8.8.8.8"
        ];
        interfaces = let
            defaultIp.address = "10.10.1.100";
            defaultIp.prefixLength = 24;
        in {
            enp7s0.ipv4.addresses = [ defaultIp ];
            enp8s0.ipv4.addresses = [ defaultIp ];
            enp12s0f0.ipv4.addresses = [ defaultIp ];
            enp12s0f1.ipv4.addresses = [ defaultIp ];

            enp15s0f0.ipv4.addresses = [ defaultIp ];
            enp15s0f1.ipv4.addresses = [ defaultIp ];
        };
    };


    imports = [
        ./ports.nix
        ./ssl.nix
        ./haproxy.nix
        ./fail2ban.nix

        ./atm8.nix
        ./sshd.nix
        ./velocity.nix
        ./shadowsocks.nix
        ./vaultwarden.nix
    ];
}
