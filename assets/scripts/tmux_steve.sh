#!/bin/bash

tmux has-session -t minecraft
if [ $? != 0 ]
then
    tmux new-session -d -s minecraft -n Win0 -c /srv/minecraft
fi
tmux neww -n waterfall -c /srv/minecraft/waterfall -d -t minecraft -k
tmux neww -n lobby -c /srv/minecraft/lobby -d -t minecraft -k
tmux neww -n survival -c /srv/minecraft/suvival -d -t minecraft -k
tmux neww -n skyblock -c /srv/minecraft/skyblock -d -t minecraft -k
tmux attach -t minecraft
