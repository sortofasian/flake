#!/usr/bin/env nix-shell
#!nix-shell -i bash -p "builtins.trace \"Starting install...\\n\" parted"
set -eu

name=$1
src=$2
drive=""

while test ! -e "$drive"; do
    lsblk -ido KNAME,MODEL,SIZE;
    printf "Select a drive: ";
    read drive;
    drive=/dev/$drive;
done

if [[ "$drive" == *"nvme"* ]]; then
    drive=$drive\p
fi

echo "Creating GPT label"
parted -s $drive -- mklabel gpt

echo "Making partitions"
parted -s $drive -- mkpart boot fat32 0% 513MB
parted -s $drive -- mkpart nixos ext4 513MB -8GB
parted -s $drive -- mkpart swap linux-swap -8GB 100%

echo "Setting flags"
parted -s $drive -- set 1 boot on
parted -s $drive -- set 3 swap on

echo "Creating filesystems"
loop=$(losetup -Pf $drive --show)
sleep 0.1
mkfs.fat -F32 $loop\p1 > /dev/null
mkfs.ext4 -Fq $loop\p2
mkswap -q $loop\p3
losetup -d $loop

parted -s $drive -- print

echo "Mounting drive"
mount $drive\2 /mnt
mkdir -p /mnt/boot/efi
mount $drive\1 /mnt/boot/efi
swapon $drive\3

echo "Installing NixOS"
nixos-install --flake $src\#$name --no-channel-copy --no-root-password --cores 0
sudo cp -r $src/* /etc/nixos/

echo "Done! Rebooting in 3"
sleep 3
reboot
