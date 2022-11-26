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

tmx () {
    # Use -d to allow the rest of the function to run
    tmux new-session -d -s minecraft
    tmux new-window -n extra-window
    # -d to prevent current window from changing
    tmux new-window -d -n waterfall
    tmux new-window -d -n lobby
    tmux new-window -d -n skyblock
    tmux new-window -d -n survival
}

echo "tmux attach-session -d -t minecraft" > /srv/minecraft/start.sh