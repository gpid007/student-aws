#!/bin/bash
set -e

SSH_CONFIG=/etc/ssh/ssh_config
CLIENT="# Client KeepAlive\nServerAliveInterval 100"
SERVER="# Server KeepAlive\nClientAliveInterval 60\nTCPKeepAlive yes\nClientAliveCountMax 10000"

tail $SSH_CONFIG
sudo echo -e "
Enter integer to set AliveInterval for
    1) Client
    2) Server
    3) Exit"
read CHOICE

case $CHOICE in
    1|[Cc]lient)  echo Client
        if ! grep -Plz $CLIENT $SSH_CONFIG; then
            echo -e $CLIENT | sudo sh -c "cat >> $SSH_CONFIG"
        fi
    ;;
    2|[Ss]erver)  echo Server    
        if ! grep -Plz $SERVER $SSH_CONFIG; then
            echo -e $SERVER | sudo sh -c "cat >> $SSH_CONFIG"
        fi
    ;;
    3|[Ee]xit)  echo Abort.
        exit
    ;;
esac

tail $SSH_CONFIG
echo -e "\nDone."
