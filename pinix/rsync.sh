#!/bin/sh
sudo rsync -aHAXxv --delete --progress --stats /etc/nixos/* /osnix/nixos/pinix

