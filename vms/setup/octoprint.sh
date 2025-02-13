#!/bin/bash

apt update && \
apt upgrade -y && \
apt install -y python3 python3-pip python3-venv python3-dev build-essential && \
mkdir -p /opt/octoprint && \
chown root:root /opt/octoprint && \
cd /opt/octoprint && \
python3 -m venv venv && \
source venv/bin/activate && \
pip install pip --upgrade && \
pip install octoprint && \
cp setup/octoprint.service /etc/systemd/system/ && \
systemctl daemon-reload && \
systemctl enable octoprint && \
systemctl start octoprint && \
systemctl status octoprint


