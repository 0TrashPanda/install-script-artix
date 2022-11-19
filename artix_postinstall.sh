#!/bin/bash

# functions
re() {
    until "$@"; do
        read -p "Something went wrong, do you want to try again? [Y/n] : " usr_input
        case $usr_input in
            [N,n,no]* ) break;;
            * ) ;;
        esac
    done
}


# update the system
sudo pacman -Syu --noconfirm

curl https://raw.githubusercontent.com/0TrashPanda/install-script-artix/paru-to-pacman/assets/pacman/pacman.conf | sudo tee -a /etc/pacman.conf > /dev/null

sudo pacman -Sy --noconfirm

sudo pacman -S --noconfirm archlinux-keyring

# pacman installs
re sudo pacman -S --noconfirm neovim neofetch htop wget git openssh ripgrep fzf zsh mandoc tmux python-pip rust doas w3m openssh-runit cmake ufw lf bat exa btop


sudo mkdir /packages
sudo chown admin: /packages

cd /packages
re git clone --branch paru-to-pacman https://github.com/0TrashPanda/install-script-artix

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
setcolors /etc/my-colors

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

cat /packages/install-script-artix/assets/zsh/.zshrc >> ~/.zshrc
