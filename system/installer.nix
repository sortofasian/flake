{ pkgs, lib, name }: let
    inherit (pkgs)
        age
        parted
        age-plugin-yubikey
        writeScript;
    inherit (lib.strings)
        makeBinPath;
    inherit (lib.custom)
        flakePath;
in writeScript "installer" ''
    export PATH="${makeBinPath [age parted age-plugin-yubikey]}:$PATH"
    set -eu

    drive=""
    repeat=true;
    while [[ "$repeat" == true ]]; do
        lsblk -ido KNAME,MODEL,SIZE;
        printf "Select a drive: "
        read -r drive
        drive=/dev/"$drive"
        while test ! -e "$drive"; do
            printf "Please enter a valid drive from the list: "
            read -r drive
            drive=/dev/$drive
        done

        if [[ "$drive" == *"nvme"* ]]; then
            drive="$drive"p
        fi

        echo "Creating GPT label"
        parted -s "$drive" -- mklabel gpt

        echo "Creating partitions"
        parted -s "$drive" -- mkpart boot fat32 0% 513MB

        set +e
        printf "Swap size: ";
        read -r swap
        while ! {
            parted -s "$drive" -- mkpart nixos ext4 513MB -$swap;
            parted -s "$drive" -- mkpart swap linux-swap -$swap 100%;
        }; do
            printf "Please enter a valid size: "
            read -r swap
        done
        set -e

        echo "Setting flags"
        parted -s "$drive" -- set 1 boot on
        if [[ "$swap" != "0" ]]; then
            parted -s "$drive" -- set 3 swap on
        fi
echo "Creating filesystems"
        loop=$(losetup -Pf "$drive" --show)
        sleep 0.1
        mkfs.fat -F32 "$loop"p1 > /dev/null
        mkfs.ext4 -Fq "$loop"p2
        if [[ "$swap" != "0" ]]; then
            mkswap -q "$loop"p3
        fi
        losetup -d "$loop"

        echo ""
        parted -s "$drive" -- print
        printf "Is this partition table correct? (y/n) "; read -r continue

        if [[ "$continue" == "y" ]]; then repeat=false; fi

        while ! [[ "$continue" == "y" ]] || [[ "$continue" == "n" ]]; do
            printf "Please type y/n: "; read -r continue
            if [[ "$continue" == "y" ]]; then repeat=false; fi
        done
    done

    echo "Mounting drive"
    mount "$drive"2 /mnt
    mkdir -p /mnt/boot/efi
    mount "$drive"1 /mnt/boot/efi
    if [[ "$swap" != "0" ]]; then
        swapon "$drive"3
    fi

    echo "Installing NixOS"
    mkdir -p /mnt/etc/nixos
    cp -r ${flakePath}/* /mnt/etc/nixos
    nixos-install \
        --flake ${flakePath}#${name} \
        --no-channel-copy \
        --cores 0 \
        #--no-root-password

    echo "Done! Rebooting in 5"
    sleep 5
    reboot
''
