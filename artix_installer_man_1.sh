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

# Partition your disk (BIOS)
read -rsn1 -p "create two partitions
    1) 1Mib boot partition
        and change the type to BIOS boot

    2) the rest of the disk for root

    cfdisk

    # Format partitions (BIOS)
    mkfs.ext4 /dev/sda2

    # Mount Partitions
    mount /dev/sda2 /mnt
    mount --mkdir /dev/sda1 /mnt/boot

    press any key to continue
";

# Enter interactive prompt
inter

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