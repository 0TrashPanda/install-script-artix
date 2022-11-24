doas pacman -S jre-openjdk-headless jre8-openjdk-headless jre11-openjdk-headless jre17-openjdk-headless

doas mkdir -p /srv/minecraft

doas useradd -d /srv/minecraft steve

doas chown steve /srv/minecraft

su steve

if command -v curl >/dev/null 2>&1; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
else
  sh -c "$(wget -O- https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
fi

git clone https://github.com/anatolykopyl/doas-zsh-plugin.git /packages/doas-zsh-plugin

cat /packages/install-script-artix/assets/zsh/.zshrc >> ~/.zshrc

sed -i '/z4h bindkey z4h-backward-kill-word  Ctrl+Backspace     Ctrl+H/d' ~/.zshrc
sed -i "s/command tmux -u new -A -D -t z4h/command tmux -2 -u new -A -D -t z4h/" ~/.zshrc


mkdir /srv/minecraft/jars
mkdir /srv/minecraft/waterfall
mkdir /srv/minecraft/lobby
mkdir /srv/minecraft/skyblock
mkdir /srv/minecraft/suvival

curl https://api.papermc.io/v2/projects/paper/versions/1.19.2/builds/282/downloads/paper-1.19.2-282.jar > /srv/minecraft/jars/paper-1192.jar
curl https://api.papermc.io/v2/projects/waterfall/versions/1.19/builds/507/downloads/waterfall-1.19-507.jar > /srv/minecraft/jars/waterfall-19.jar

echo "java -Xms512M -Xmx1G -jar paper-1192.jar" > /srv/minecraft/lobby/start.sh
chmod u+x /srv/minecraft/lobby/start.sh

echo "java -jar waterfall-19.jar" > /srv/minecraft/waterfall/start.sh
chmod u+x /srv/minecraft/waterfall/start.sh

exit
