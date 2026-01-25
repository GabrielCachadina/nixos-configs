#!/usr/bin/env bash
set -euo pipefail

lsblk
echo
read -rp "Enter disk name (e.g. sda or nvme0n1): " disk_name
disk="/dev/$disk_name"

echo
echo "THIS WILL ERASE ALL DATA ON $disk"
read -rp "Type YES to continue: " confirm
if [[ "$confirm" != "YES" ]]; then
  echo "Aborted."
  exit 1
fi

sudo parted --script "$disk" \
  mklabel gpt \
  mkpart ESP fat32 1MiB 1GiB \
  set 1 esp on \
  mkpart root ext4 1GiB -2GiB \
  mkpart swap linux-swap -2GiB 100%

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
sudo nixos-install
