#!/bin/bash

#Set the keyboard layout permanently
while true; do
    read -p "chose a permanent keyboard layout - Colemak(C) | qwerty(Q) | azerty(A) | skip(S) : " kb_layout
    case $kb_layout in
        [Cc]* ) echo "KEYMAP=colemak" > /etc/vconsole.conf;echo "keymap permanently set to colemak"; break;;
        [Qq]* ) echo "KEYMAP=us" > /etc/vconsole.conf;echo "keymap permanently set to us"; break;;
        [Aa]* ) echo "KEYMAP=azerty" > /etc/vconsole.conf;echo "keymap permanently set to azerty"; break;;
        [Ss]* ) echo "keymap unchanged"; break;;
        * ) echo "Please chose a layout.";;
    esac
done

echo "enter hostname:"
read hostname
echo "you entered $hostname"

pacman -S --noconfirm grub dhcpcd connman-runit connman-gtk

# Configure the system clock
ln -sf /usr/share/zoneinfo/Europe/Brussels /etc/localtime
hwclock --systohc

# Localization
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen;

locale-gen

# Boot Loader (BIOS)
read -rsn1 -p "grub-install --target=i386-pc /dev/sda
    grub-mkconfig -o /boot/grub/grub.cfg

    press any key to continue
";
