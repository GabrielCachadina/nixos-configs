#!/usr/bin/env bash
set -euo pipefail

if [[ "$EUID" -ne 0 ]]; then
  echo "Please run as root."
  exit 1
fi

lsblk
echo
read -rp "Enter disk name (e.g. sda or nvme0n1): " disk_name

if [[ -z "$disk_name" ]]; then
  echo "No disk entered. Aborting."
  exit 1
fi

disk="/dev/$disk_name"

if [[ ! -b "$disk" ]]; then
  echo "Disk $disk does not exist."
  exit 1
fi

echo
echo "THIS WILL ERASE ALL DATA ON $disk"
read -rp "Type YES to continue: " confirm

if [[ "$confirm" != "YES" ]]; then
  echo "Aborted."
  exit 1
fi

sudo parted "$disk"<<EOF
mklabel gpt
mkpart ESP fat32 1MiB 1GiB
set 1 esp on
mkpart root ext4 1GiB -2GiB
mkpart swap linux-swap -2GiB 100%
quit
EOF

# Handle nvme vs sata naming automatically
if [[ "$disk_name" == nvme* ]]; then
  p1="${disk}p1"
  p2="${disk}p2"
  p3="${disk}p3"
else
  p1="${disk}1"
  p2="${disk}2"
  p3="${disk}3"
fi

sudo mkfs.fat -F 32 -n boot "$p1"
sudo mkfs.ext4 -L nixos "$p2"
sudo mkswap -L swap "$p3"

sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount -o umask=077 /dev/disk/by-label/boot /mnt/boot
sudo swapon /dev/disk/by-label/swap

sudo nixos-generate-config --root /mnt
sudo nixos-generate-config --root /mnt

# Patch configuration.nix for UEFI systemd-boot
CONFIG="/mnt/etc/nixos/configuration.nix"

# Disable GRUB
sudo sed -i \
  -e 's/^\s*boot\.loader\.grub\.enable\s*=.*/boot.loader.grub.enable = false;/' \
  "$CONFIG"

# Enable systemd-boot right after grub.disable line
if grep -q "boot.loader.systemd-boot.enable" "$CONFIG"; then
    sudo sed -i 's/^\s*boot\.loader\.systemd-boot\.enable\s*=.*/boot.loader.systemd-boot.enable = true;/' "$CONFIG"
else
    # Insert after grub.disable line
    sudo sed -i '/boot\.loader\.grub\.enable = false;/a \
boot.loader.systemd-boot.enable = true;' "$CONFIG"
fi

sudo nixos-install
