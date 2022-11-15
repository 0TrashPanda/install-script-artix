#!/bin/bash

# update the system
sudo pacman -Syu

# pacman installs
sudo pacman -S neovim neofetch htop git wget openssh ripgrep fzf zsh mandoc tmux python-pip rust doas

sudo mkdir /packages
sudo chown admin: /packages

cd /packages
git clone https://github.com/0TrashPanda/install-script-artix

# configure doas
sudo cp /packages/install-script-artix/doas.conf /etc/doas.conf

# remove sudo
doas pacman -R sudo


# install paru
cd /packages
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

paru -S exa-git btop-git bat-cat-git lf-git glow-git setcolors-git


# set terminal colors
doas touch /etc/my-colors
doas chown admin: /etc/my-colors
cat /packages/install-script-artix/my-terminal-colors | tr -d '    ' > /etc/my-colors
setcolors /etc/my-colors

doas mkdir /etc/scripts
doas chown admin: /etc/scripts

echo "#!/bin/bash
setcolors /etc/my-colors
clear" > /etc/scripts/set-colors.sh
doas chmod +x /etc/scripts/set-colors.sh

doas chown admin: /etc/rc.local
echo "/etc/scripts/set-colors.sh" >> /etc/rc.local

# change font
doas chown admin: /etc/fonts
curl -o /etc/fonts/zap-ext-vga16.psf https://www.zap.org.au/projects/console-fonts-zap/src/zap-ext-vga16.psf

setfont /etc/fonts/zap-ext-vga16.psf

doas chown admin: /etc/vconsole.conf
echo "FONT=/etc/fonts/zap-ext-vga16.psf" >> /etc/vconsole.conf

# # zsh configs
# cd /packages
# doas git clone --depth 1 https://github.com/qoomon/my-zsh.git "$HOME/.zsh" && $HOME/.zsh/install.zsh

#configure zsh
cp /packages/install-script-artix/.zshrc ~/.zshrc

# # start zsh
# echo ;
# echo -e "${RED}EXIT THE SHELL${NORMAL}"
# echo ;
# zsh

# change default shell to zsh
doas chsh -s /bin/zsh

# Make usergroups
# groupadd owner
# groupadd admin

# useradd -m -G owner treesee
# echo "treesee:"
# passwd treesee
# useradd -m -G owner jonah
# echo "jonah:"
# passwd jonah
# useradd -m -G admin sompie
# echo "sompie:"
# passwd sompie