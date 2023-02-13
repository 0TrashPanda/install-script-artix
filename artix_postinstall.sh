#!/bin/bash

# functions
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

re() {
    until "$@"; do
        read -p "Something went wrong, do you want to try again? [Y/n/i] : " usr_input
        case $usr_input in
            [N,n,no]* ) break;;
            [I,i,inter]* ) echo "command: $@"; inter;;
            * ) ;;
        esac
    done
}

# update the system
sudo pacman -Syu --noconfirm

curl -k https://raw.githubusercontent.com/0TrashPanda/install-script-artix/master/assets/pacman/pacman.conf | sudo tee -a /etc/pacman.conf > /dev/null

sudo pacman -Sy --noconfirm

sudo pacman -S --noconfirm archlinux-keyring

# pacman installs
re sudo pacman -S --noconfirm neovim neofetch htop wget git openssh ripgrep fzf zsh mandoc tmux python-pip rust doas w3m openssh-runit cmake ufw lf bat exa btop duf openntpd-runit

re doas ntpd

sudo mkdir /packages
sudo chown admin: /packages

cd /packages
re git clone https://github.com/0TrashPanda/install-script-artix

# configure doas
sudo cp /packages/install-script-artix/assets/doas/doas.conf /etc/doas.conf

# remove sudo
re doas pacman -Rs --noconfirm sudo


# install paru
cd /packages
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
re makepkg -si

re paru -S --sudo doas --noconfirm setcolors-git


# set terminal colors
re doas touch /etc/my-colors
re doas chown admin: /etc/my-colors
cat /packages/install-script-artix/assets/set-colors/my-terminal-colors | tr -d '    ' > /etc/my-colors
re doas /usr/bin/setcolors /etc/my-colors

re doas mkdir /etc/scripts
re doas chown admin: /etc/scripts

cp /packages/install-script-artix/scripts/set-colors.sh > /etc/scripts/set-colors.sh
re doas chmod +x /etc/scripts/set-colors.sh

re doas chown admin: /etc/rc.local
echo "/etc/scripts/set-colors.sh" >> /etc/rc.local

# change font
re doas chown admin: /etc/fonts
curl -o /etc/fonts/zap-ext-vga16.psf https://www.zap.org.au/projects/console-fonts-zap/src/zap-ext-vga16.psf

setfont /etc/fonts/zap-ext-vga16.psf

re doas chown admin: /etc/vconsole.conf
echo "FONT=/etc/fonts/zap-ext-vga16.psf" >> /etc/vconsole.conf

# setup ssh
re doas ln -s /etc/runit/sv/sshd /run/runit/service
re doas sv up sshd

# zsh for human installation
if command -v curl >/dev/null 2>&1; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
else
  sh -c "$(wget -O- https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
fi

git clone https://github.com/anatolykopyl/doas-zsh-plugin.git /packages/doas-zsh-plugin

cat /packages/install-script-artix/assets/zsh/.zshrc >> ~/.zshrc

sed -i '/z4h bindkey z4h-backward-kill-word  Ctrl+Backspace     Ctrl+H/d' ~/.zshrc
sed -i "s/command tmux -u new -A -D -t z4h/command tmux -2 -u new -A -D -t z4h/" ~/.zshrc
