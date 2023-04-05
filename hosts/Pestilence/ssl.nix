{ pkgs, config, ... }: let
    inherit (config.age)
        secrets;
in {
    systemd.timers."lego" = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
            Persistent = true;
            OnCalendar = "Sunday 3:00";
            Unit = "lego.service";
        };
    };

    systemd.services = let
        lego = ''
            ${pkgs.lego}/bin/lego -a \
                -m charliesyvertsen06@icloud.com \
                -d sortofasian.io -d *.sortofasian.io \
                --dns cloudflare \
                --path /srv \
                --filename sortofasian.io --pem \
        '';
        serviceConfig = {
            Type = "oneshot";
            After = "network-online.target";
            EnvironmentFile = secrets.acme-cloudflare;
        };
    in {
        "lego-register" = {
            script = "${lego} run";
            serviceConfig = serviceConfig
            // { ConditionPathExists = "!/srv/.lego/accounts/*/charliesyvertsen06@icloud.com"; };
        };
        "lego" = {
            script = "${lego} renew";
            requires = [ "lego.register.service" ];
            inherit serviceConfig;
        };
    };
}
