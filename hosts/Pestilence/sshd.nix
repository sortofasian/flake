{
    networking.firewall.allowedTCPPorts = [ 22 ];
    services.openssh.enable = true;
    services.openssh.settings = {
        LogLevel = "VERBOSE";
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
    };
}
