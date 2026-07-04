#!/bin/sh
sudo rsync -aHAXxv --exclude='**/.git/' --delete --progress --stats /etc/nixos/ /osnix/nixos/ocnix
