{ lib, system, ... }: let
    inherit (lib.custom)
        switchSystem;
in switchSystem system {
    darwin.system.defaults = {
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
}
