#!/bin/bash

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
# Fresh Artix installation from bootable media
echo "Please make sure this machine is connected to the internet.";

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

while true; do
    read -p "Do you automatically want to curl the second and third part of the installer? [Y/n] : " curl_next
    case $curl_next in
        [Y,y,yes]* ) DOWNLOAD_NEXT=true; break;;
        [N,n,no]* ) break;;
        * ) echo "yes or no";read ip_adress break;;
    esac
done



EFI=0

DIR="/sys/firmware/efi/efivars/"
if [ -d "$DIR" ]; then
    # Take action if $DIR exists. #
    echo "you are in efi boot mode"
    EFI=1
fi


# Partition your disk (BIOS)
read -rsn1 -p "create two partitions
    1) 1Mib boot partition
        and change the type to BIOS boot

    2) the rest of the disk for root

    press any key to continue";
cfdisk

# Format partitions (BIOS)
mkfs.ext4 /dev/sda2

# Mount Partitions
mount /dev/sda2 /mnt
mount --mkdir /dev/sda1 /mnt/boot

# Update the system clock
ln -s /etc/runit/sv/ntpd/ /run/runit/service
sv up ntpd

# Install base system
basestrap /mnt base base-devel runit elogind-runit

# Install a kernel
basestrap /mnt linux-lts linux-firmware

fstabgen -U /mnt >> /mnt/etc/fstab

# download the installer_part_2.sh and installer_part_3.sh if -c is used
if ! [ -z ${DOWNLOAD_NEXT+x} ]; then
    echo "downloading installer_part_2.sh and installer_part_3.sh from $ip_adress"
    cd /mnt/

    curl -o installer_part_2.sh https://raw.githubusercontent.com/0TrashPanda/install-script-artix/master/artix_installer-2.sh
    chmod +x installer_part_2.sh

    curl -o installer_part_3.sh https://raw.githubusercontent.com/0TrashPanda/install-script-artix/master/artix_postinstall.sh
    chmod +x installer_part_3.sh
fi

# beep -f 5000 -l 50 -r 2
read -rsn1 -p "Press any key to continue"
echo ;
echo "activate the 2nd installer script";
artix-chroot /mnt

