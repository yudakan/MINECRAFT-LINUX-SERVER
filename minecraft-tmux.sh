#!/bin/bash

RUNNING="false"
if tmux ls 2>/dev/null | grep -q minecraft - ; then
    RUNNING="true"
fi

if [[ $1 == "start" ]]; then
    if [[ $RUNNING == "true" ]]; then
        echo "[*] Minecraft Server is already running."
    else
        tmux new -d -s minecraft &&
        tmux send-keys -t minecraft.0 "java -Xms24G -Xmx24G -jar server.jar nogui; exit" ENTER &&
        echo "[*] Minecraft Server started successfully."
        if  [[ $2 == "wait" ]]; then
          while tmux ls | grep -q minecraft - ; do
              sleep 5
          done;
        fi
    fi
elif [[ $1 == "stop" ]]; then
    if [[ $RUNNING == "false" ]]; then
        echo "[*] Minecraft Server was not running."
    else
        tmux send-keys -t minecraft.0 "/say §L§9G§CO§EO§9GL§C§AE §C§NNOS QUITA EL SERVER EN 10s >_< !!!" ENTER &&
        sleep 10 &&
        tmux send-keys -t minecraft.0 "/stop" ENTER &&
        sleep 12 &&
        echo "[*] Minecraft Server stopped successfully."
    fi
elif [[ $1 == "command" ]]; then
    if [[ $RUNNING == "false" ]]; then
        echo "[#] Minecraft Server is not running."
    else
        tmux send-keys -t minecraft.0 "$2" ENTER
    fi
elif [[ $1 == "backup" ]]; then
    if [[ $RUNNING == "true" ]]; then
        echo "[#] Minecraft Server is running."
    elif [[ -z $2 ]] || [[ -z $3 ]]; then
        echo "[#] Needed user@host and file path."
    else
        zip -r backup.zip . &&
        cat backup.zip | ssh $2 "cat > $3" &&
        rm backup.zip &&
        echo "[*] Backup done on $2."
    fi
else
    echo "[#] Bad arguments."
fi
