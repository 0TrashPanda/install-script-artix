#!/bin/bash

RED='\033[0;31m'
NORMAL='\033[0m'

sudo pacman -Syu

# pacman installs
sudo pacman -S neovim neofetch htop git wget openssh ripgrep fzf zsh mandoc tmux python-pip rust


sudo mkdir /packages
sudo chown admin: /packages
# exa -l -F --header --icons -s type #? why are we doing this

# install paru
cd /packages
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

paru -S exa-git btop-git bat-cat-git lf-git glow-git setcolors-git

# cd /packages
# git clone https://aur.archlinux.org/exa-git.git
# cd exa-git
# makepkg -si

# cd /packages
# git clone https://aur.archlinux.org/btop-git.git
# cd btop-git
# makepkg -si

# cd /packages
# git clone https://aur.archlinux.org/bat-cat-git.git
# cd bat-cat-git
# makepkg -si

# cd /packages
# git clone https://aur.archlinux.org/lf-git.git
# cd lf-git
# makepkg -si

# cd /packages
# git clone https://aur.archlinux.org/glow-git.git
# cd glow-git
# makepkg -si

# # set terminal colors

# cd /packages
# git clone https://aur.archlinux.org/setcolors-git.git
# cd setcolors-git
# makepkg -si
sudo touch /etc/my-colors
sudo chown admin: /etc/my-colors
echo "0#1D1F21
8#373B41

1#A54242
9#CC6666

2#8C9440
10#B5BD68

3#DE935F
11#F0C674

4#5F819D
12#81A2BE

5#85678F
13#B294BB

6#5E8D87
14#8ABEB7

7#C5C8C6
15#EEEEEE" > /etc/my-colors
setcolors /etc/my-colors

sudo mkdir /etc/scripts
sudo chown admin: /etc/scripts

echo "#!/bin/bash
setcolors /etc/my-colors
clear" > /etc/scripts/set-colors.sh
sudo chmod +x /etc/scripts/set-colors.sh

sudo chown admin: /etc/rc.local
echo "/etc/scripts/set-colors.sh" >> /etc/rc.local

# change font
sudo chown admin: /etc/fonts
curl -o /etc/fonts/zap-ext-vga16.psf https://www.zap.org.au/projects/console-fonts-zap/src/zap-ext-vga16.psf

setfont /etc/fonts/zap-ext-vga16.psf

sudo chown admin: /etc/vconsole.conf
echo "FONT=/etc/fonts/zap-ext-vga16.psf" >> /etc/vconsole.conf

# # zsh configs
# cd /packages
# sudo git clone --depth 1 https://github.com/qoomon/my-zsh.git "$HOME/.zsh" && $HOME/.zsh/install.zsh


# start zsh
echo ;
echo -e "${RED}EXIT THE SHELL${NORMAL}"
echo ;
zsh

# # create zsh aliases
# sudo chown admin: $HOME/.zsh/zshrc.zsh
# sudo chmod u+w $HOME/.zsh/zshrc.zsh
# echo 'alias ls="exa -l -F --header -s type"
# alias cl="clear"
# alias us="loadkeys us"
# alias be="loadkeys azerty"
# alias colemak="loadkeys colemak"
# alias ..="cd .."' >> $HOME/.zsh/zshrc.zsh;

# change default shell to zsh
chsh -s /bin/zsh

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

# echo "%owner ALL=(ALL:ALL) ALL" >> /etc/sudoers;
