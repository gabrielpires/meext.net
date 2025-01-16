#!/bin/bash

apt update && \
apt upgrade -y && \
apt install cifs-utils && \
apt install curl apt-transport-https ca-certificates gnupg lsb-release -y && \
curl https://downloads.plex.tv/plex-keys/PlexSign.key | apt-key add - && \
touch /etc/apt/sources.list.d/plexmediaserver.list && \
echo "deb https://downloads.plex.tv/repo/deb public main" | tee /etc/apt/sources.list.d/plexmediaserver.list && \
apt update && \
apt install plexmediaserver -y && \
mkdir -p /mnt/media && \
mkdir -p /etc/samba && \
touch -p /etc/samba/credentials && \
echo "username=plex\npassword=<VALUE>" >> /etc/samba/credentails && \
