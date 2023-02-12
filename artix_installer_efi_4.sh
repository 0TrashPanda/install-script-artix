
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