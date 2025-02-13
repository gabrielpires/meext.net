#!/bin/bash

mount -t cifs //199.198.0.16/DIR /mnt/DIR -o credentials=/etc/samba/credentials,vers=3.0
