#!/bin/bash

# functions
re_doas() {
    until doas "$@"; do
        read -p "Something went wrong, do you want to try again? [Y/n] : " usr_input
        case $usr_input in
            [N,n,no]* ) break;;
            * ) ;;
        esac
    done
}


# update the system
sudo pacman -Syu --noconfirm


# pacman installs
sudo pacman -S --noconfirm neovim neofetch htop git wget openssh ripgrep fzf zsh mandoc tmux python-pip rust doas

sudo mkdir /packages
sudo chown admin: /packages

cd /packages
git clone https://github.com/0TrashPanda/install-script-artix

# configure doas
sudo cp /packages/install-script-artix/doas.conf /etc/doas.conf

# remove sudo
re_doas pacman -R --noconfirm sudo


# install paru
cd /packages
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

paru -S --noconfirm exa-git btop-git bat-cat-git lf-git glow-git setcolors-git


# set terminal colors
re_doas touch /etc/my-colors
re_doas chown admin: /etc/my-colors
cat /packages/install-script-artix/my-terminal-colors | tr -d '    ' > /etc/my-colors
setcolors /etc/my-colors

re_doas mkdir /etc/scripts
re_doas chown admin: /etc/scripts

echo "#!/bin/bash
setcolors /etc/my-colors
clear
" > /etc/scripts/set-colors.sh
re_doas chmod +x /etc/scripts/set-colors.sh

re_doas chown admin: /etc/rc.local
echo "/etc/scripts/set-colors.sh" >> /etc/rc.local

# change font
re_doas chown admin: /etc/fonts
curl -o /etc/fonts/zap-ext-vga16.psf https://www.zap.org.au/projects/console-fonts-zap/src/zap-ext-vga16.psf

setfont /etc/fonts/zap-ext-vga16.psf

re_doas chown admin: /etc/vconsole.conf
echo "FONT=/etc/fonts/zap-ext-vga16.psf" >> /etc/vconsole.conf

# # zsh configs
# cd /packages
# re_doas git clone --depth 1 https://github.com/qoomon/my-zsh.git "$HOME/.zsh" && $HOME/.zsh/install.zsh

#configure zsh
cp /packages/install-script-artix/.zshrc ~/.zshrc

# # start zsh
# echo ;
# echo -e "${RED}EXIT THE SHELL${NORMAL}"
# echo ;
# zsh

# change default shell to zsh
re_doas chsh -s /bin/zsh

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
