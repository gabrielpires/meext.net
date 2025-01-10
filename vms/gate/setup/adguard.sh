#!/bin/bash

apt-get install -y curl && \
curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh -o adguard_install.sh && \
bash adguard_install.sh

