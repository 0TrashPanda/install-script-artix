doas pacman -S jre-openjdk-headless jre8-openjdk-headless jre11-openjdk-headless jre17-openjdk-headless

doas mkdir -p /srv/minecraft

doas useradd -d /srv/minecraft steve

echo "changing the password for steve"
doas passwd steve

doas chown steve /srv/minecraft

doas su steve #! verry popo, does not work ╚(•⌂•)╝ so i need to slit the script in two parts
