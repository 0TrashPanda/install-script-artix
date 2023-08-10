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

pacman -S --noconfirm grub dhcpcd connman-runit 

# Configure the system clock
ln -sf /usr/share/zoneinfo/Europe/Brussels /etc/localtime
hwclock --systohc

# Localization
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen;

locale-gen

# Boot Loader (BIOS)
echo ;
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# Add user(s)
echo "enter root password:"
passwd

useradd -m -G wheel admin
echo "enter admin password:"
passwd admin

# beep -f 5000 -l 50 -r 2
echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers;

# Network configuration
echo "$hostname" > /etc/hostname;

echo "127.0.0.1        localhost
::1              localhost
127.0.1.1        $hostname.localdomain  $hostname" > /etc/hosts

ln -s /etc/runit/sv/connmand /etc/runit/runsvdir/default

echo "please exit and reboot the system, after: log in as admin to do the post install."
# Reboot the system