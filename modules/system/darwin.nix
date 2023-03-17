{ lib, pkgs, config, system, ... }: let
    inherit (lib)
        mkDefault
        mkForce;
    inherit (lib.custom)
        switchSystem;
in switchSystem system { darwin = {
    system.stateVersion = 4;

    homebrew = {
        enable = mkDefault true;
        onActivation = {
            upgrade = true;
            autoUpdate = true;
            cleanup = "zap";
        };
    };

    services.nix-daemon.enable = true;
    system.activationScripts.applications.text = mkForce ''
        rm -rf /Applications/Nix\ Apps
        mkdir -p /Applications/Nix\ Apps
        for app in $(find ${config.system.build.applications}/Applications -maxdepth 1 -type l); do
            src="$(/usr/bin/stat -f%Y "$app")"
            cp -Lr "$src" /Applications/Nix\ Apps
        done
    '';

    environment.systemPackages = [pkgs.openssh];

    system.defaults = {
        NSGlobalDomain = {
          AppleInterfaceStyle = "Dark";
          AppleKeyboardUIMode = 3;
          AppleMeasurementUnits = "Centimeters";
          AppleMetricUnits = 1;
          AppleShowAllExtensions = true;
          AppleShowScrollBars = "WhenScrolling";
          AppleTemperatureUnit = "Celsius";
          InitialKeyRepeat = 15;
          KeyRepeat = 2;
          "com.apple.trackpad.scaling" = 0.875;
          NSAutomaticCapitalizationEnabled = false;
          NSAutomaticDashSubstitutionEnabled = false;
          NSAutomaticQuoteSubstitutionEnabled = false;
          NSAutomaticPeriodSubstitutionEnabled = false;
          "com.apple.keyboard.fnState" = true;
          "com.apple.mouse.tapBehavior" = 1;
          "com.apple.sound.beep.feedback" = 1;
        };
        SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
        alf = {
          allowdownloadsignedenabled = 1;
          allowsignedenabled = 1;
          globalstate = 1;
          stealthenabled = 1; 
        };
        dock.mineffect = "scale";
        dock.mru-spaces = false;
        dock.orientation = "left";
        dock.show-recents = false;

        finder._FXShowPosixPathInTitle = true;
        trackpad = {
          ActuationStrength = 0;
          Clicking = true;
          Dragging = true;
          FirstClickThreshold = 0;
          SecondClickThreshold = 0;
        };
    };
}; }
