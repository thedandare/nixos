#!/bin/sh
sudo rsync -aHAXxv --exclude='**/.git/' --progress --stats /etc/nixos/ /osnix/nixos/leonix
