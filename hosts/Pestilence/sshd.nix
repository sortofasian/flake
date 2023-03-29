{
    networking.firewall.allowedTCPPorts = [ 22 ];
    services.openssh.enable = true;
    services.openssh.settings = {
        permitRootLogin = "no";
        passwordAuthentication = false;
        logLevel = "VERBOSE";
    };
}
