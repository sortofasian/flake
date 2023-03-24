user: {
    masterIdentities = [
        ./age-yubikey-5
        ./age-yubikey-5c
    ];

    secrets = {
        login = {
            file = ./secrets/login.age;
        };
        pam-yubikeys = {
            file = ./secrets/pam-yubikeys.age;
            owner = user.name;
        };
        ssh-yubikey-5 = {
            file = ./secrets/ssh-yubikey-5.age;
            owner = user.name;
        };
        ssh-yubikey-5c = {
            file = ./secrets/ssh-yubikey-5c.age;
            owner = user.name;
        };
    };
}
