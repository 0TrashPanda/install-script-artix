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


# pacman installs
sudo pacman -S --noconfirm neovim neofetch htop git wget openssh ripgrep fzf zsh mandoc tmux python-pip rust doas w3m openssh-runit


sudo mkdir /packages
sudo chown admin: /packages

cd /packages
git clone https://github.com/0TrashPanda/install-script-artix

# configure doas
sudo cp /packages/install-script-artix/doas.conf /etc/doas.conf

# remove sudo
re doas pacman -R --noconfirm sudo


# install paru
cd /packages
git clone https://aur.archlinux.org/paru.git
cd paru
re makepkg -si

paru --sudo doas -S --noconfirm exa-git btop-git bat-cat-git lf-git glow-git setcolors-git starship


# set terminal colors
re doas touch /etc/my-colors
re doas chown admin: /etc/my-colors
cat /packages/install-script-artix/my-terminal-colors | tr -d '    ' > /etc/my-colors
setcolors /etc/my-colors

re doas mkdir /etc/scripts
re doas chown admin: /etc/scripts

echo "#!/bin/bash
setcolors /etc/my-colors
clear
" > /etc/scripts/set-colors.sh
re doas chmod +x /etc/scripts/set-colors.sh

re doas chown admin: /etc/rc.local
echo "/etc/scripts/set-colors.sh" >> /etc/rc.local

# change font
re doas chown admin: /etc/fonts
curl -o /etc/fonts/zap-ext-vga16.psf https://www.zap.org.au/projects/console-fonts-zap/src/zap-ext-vga16.psf

setfont /etc/fonts/zap-ext-vga16.psf

re doas chown admin: /etc/vconsole.conf
echo "FONT=/etc/fonts/zap-ext-vga16.psf" >> /etc/vconsole.conf

#configure zsh
cd /packages
git clone https://github.com/zsh-users/zsh-autosuggestions.git

git clone https://github.com/anatolykopyl/doas-zsh-plugin.git

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git

git clone https://github.com/zsh-users/zsh-history-substring-search.git

git clone https://github.com/zsh-users/zsh-completions.git

git clone git://github.com/wting/autojump.git
cd autojump
./install.py


mkdir -p ~/.config
cp /packages/install-script-artix/starship.toml ~/.config/starship.toml


cp /packages/install-script-artix/.zshrc ~/.zshrc

# change default shell to zsh
re doas chsh -s /bin/zsh


# setup ssh
re doas ln -s /etc/runit/sv/sshd /run/runit/service
re doas sv up sshd