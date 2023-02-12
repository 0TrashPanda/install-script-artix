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

curl -o installer_part_3.sh -k https://raw.githubusercontent.com/0TrashPanda/install-script-artix/master/artix_installer_ufi_3.sh
chmod +x installer_part_3.sh

curl -o installer_part_4.sh -k https://raw.githubusercontent.com/0TrashPanda/install-script-artix/master/artix_installer_ufi_4.sh
chmod +x installer_part_4.sh

curl -o installer_part_post.sh -k https://raw.githubusercontent.com/0TrashPanda/install-script-artix/master/artix_postinstall.sh
chmod +x installer_part_post.sh

# beep -f 5000 -l 50 -r 2
read -rsn1 -p "Press any key to continue"
echo ;
echo "activate the 2nd installer script";
artix-chroot /mnt