let
    Yubikey-5c = "age1yubikey1qwkqxsgmxgsqjl2pkr5g6vlyeuj5vvnrxehfr9ucyqfsd2nlxryzx5w7ud9";
    Yubikey-5  = "age1yubikey1qfxcffqt85khf3s0ysdw8cuqxqll777hj3uv87edglnff09yxxmqwwrtcvt";
    Famine     = "age1nm72rl5qvmxlame9szcv24urufnzcqyf952tcsjmzjxx2pc57eesdh3x3s";
    War        = "age152q033p8wej0v0833yv45hf85f4e69dd925zshgktccxndptpdvq75dpvf";
    Pestilence = "age1c7l2afugswu44qxnxyp840avxul6dheljtu6rjx7xfpmkqwxud8skevzg2";
    Death      = "age1v3ag7vy63cm5cyc66ajmux8y4w3rudmc0gd3np0xtm4qv44feqvqwg48yh";

    masterKeys = [ Yubikey-5c Yubikey-5 ];
    allSystems = [ Famine War Pestilence Death ] ++ masterKeys;
in {
    "login.age".publicKeys          = allSystems;
    "pam-yubikeys.age".publicKeys   = allSystems;
    "ssh-yubikey-5.age".publicKeys  = allSystems;
    "ssh-yubikey-5c.age".publicKeys = allSystems;

    "vpn-privkey.age".publicKeys  = [ Pestilence ] ++ masterKeys;
    "vpn-password.age".publicKeys = [ Pestilence ] ++ masterKeys;
}
