#!/bin/bash

# Functions
inter() {
    until false; do
        read -p "Do you want to return to the script? [y/N] : " usr_input
        case $usr_input in
            [Y,y,yes]* ) break;;
            * ) ;;
        esac
        $usr_input
    done
}

while getopts 'h' OPTION; do
  case "$OPTION" in
    h)
      help
      exit 0
      ;;
    ?)
      echo "script usage: $(basename \$0) [-c] [-h]" >&2
      exit 1
      ;;
  esac
done

help() {
  echo "script usage: $(basename $0) [-c] [-h]" >&2
  echo "  -c  curl installer_part_2.sh from your ip adress" >&2
  echo "  -h  display help" >&2
}

RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
LIGHT_BLEU='\033[0;36m'
NORMAL='\033[0m'


clear

echo -e "
${NORMAL}
    ██████  ██    ██ ██████  ██    ██
    ██   ██ ██    ██ ██   ██  ██  ██
    ██████  ██    ██ ██████    ████
    ██   ██ ██    ██ ██   ██    ██
    ██   ██  ██████  ██████     ██

    ${RED} █████  ${GREEN}██████  ${BLUE}████████ ${MAGENTA}██ ${LIGHT_BLEU}██   ██
    ${RED}██   ██ ${GREEN}██   ██ ${BLUE}   ██    ${MAGENTA}██ ${LIGHT_BLEU} ██ ██
    ${RED}███████ ${GREEN}██████  ${BLUE}   ██    ${MAGENTA}██ ${LIGHT_BLEU}  ███
    ${RED}██   ██ ${GREEN}██   ██ ${BLUE}   ██    ${MAGENTA}██ ${LIGHT_BLEU} ██ ██
    ${RED}██   ██ ${GREEN}██   ██ ${BLUE}   ██    ${MAGENTA}██ ${LIGHT_BLEU}██   ██

${ORANGE}
    ██ ███    ██ ███████ ████████  █████  ██      ██      ███████ ██████
    ██ ████   ██ ██         ██    ██   ██ ██      ██      ██      ██   ██
    ██ ██ ██  ██ ███████    ██    ███████ ██      ██      █████   ██████
    ██ ██  ██ ██      ██    ██    ██   ██ ██      ██      ██      ██   ██
    ██ ██   ████ ███████    ██    ██   ██ ███████ ███████ ███████ ██   ██
${NORMAL}
"

echo "Thank you for choosing our Artix Linux instalation script!";

# Set the keyboard layout
while true; do
    read -p "Colemak(C) | qwerty(Q) | azerty(A) | skip(S) : " kb_layout
    case $kb_layout in
        [Cc]* ) loadkeys colemak;echo "keymap set to colemak"; break;;
        [Qq]* ) loadkeys us;echo "keymap set to us"; break;;
        [Aa]* ) loadkeys azerty;echo "keymap set to azerty"; break;;
        [Ss]* ) echo "keymap unchanged"; break;;
        * ) echo "Please chose a layout.";;
    esac
done

# List available disks
lsblk

# Prompt the user to select a disk for installation
read -rp "Enter the disk where you want to install (e.g., /dev/sda): " install_disk

# Create partitions using fdisk
(echo o; echo n; echo p; echo 1; echo ''; echo +512M; echo t; echo 1; echo n; echo p; echo 2; echo ''; echo ''; echo w) | fdisk "$install_disk"

# Format partitions
mkfs.fat -F32 "${install_disk}1"
mkfs.ext4 "${install_disk}2"

# Mount Partitions
mount "${install_disk}2" /mnt
mkdir -p /mnt/boot/efi
mount "${install_disk}1" /mnt/boot/efi

# Update the system clock
ln -s /etc/runit/sv/ntpd/ /run/runit/service
sv up ntpd

# Install base system
basestrap /mnt base base-devel runit elogind-runit

# Install a kernel
basestrap /mnt linux-lts linux-firmware

fstabgen -U /mnt >> /mnt/etc/fstab

# download the installer_part_2.sh and installer_part_3.sh
cd /mnt/

curl -o installer_p2.sh https://raw.githubusercontent.com/0TrashPanda/install-script-artix/master/artix_installer_man_2.sh
chmod +x installer_p2.sh

curl -o installer_pp.sh https://raw.githubusercontent.com/0TrashPanda/install-script-artix/master/artix_postinstall.sh
chmod +x installer_pp.sh

# beep -f 5000 -l 50 -r 2
read -rsn1 -p "Press any key to continue"
echo ;
echo "activate the 2nd installer script";
artix-chroot /mnt