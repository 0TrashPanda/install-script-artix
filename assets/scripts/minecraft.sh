mkdir /srv/minecraft/jars
mkdir /srv/minecraft/waterfall
mkdir /srv/minecraft/lobby
mkdir /srv/minecraft/skyblock
mkdir /srv/minecraft/suvival

curl https://api.papermc.io/v2/projects/paper/versions/1.19.2/builds/290/downloads/paper-1.19.2-290.jar > /srv/minecraft/jars/paper-1192.jar
curl https://api.papermc.io/v2/projects/waterfall/versions/1.19/builds/507/downloads/waterfall-1.19-507.jar > /srv/minecraft/jars/waterfall-19.jar

cp /srv/minecraft/jars/paper-1192.jar /srv/minecraft/lobby/paper-1192.jar
cp /srv/minecraft/jars/waterfall-19.jar /srv/minecraft/waterfall/waterfall-19.jar

echo "java -Xms512M -Xmx1G -jar paper-1192.jar" > /srv/minecraft/lobby/start.sh
chmod u+x /srv/minecraft/lobby/start.sh

echo "java -jar waterfall-19.jar" > /srv/minecraft/waterfall/start.sh
chmod u+x /srv/minecraft/waterfall/start.sh

cp /packages/minecraft/assets/scripts/tmux_steve.sh /srv/minecraft/start.sh
chmod u+x /srv/minecraft/start.sh