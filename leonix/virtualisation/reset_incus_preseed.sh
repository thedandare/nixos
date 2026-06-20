#!/bin/sh
 sudo systemctl stop incus
sudo rm -f /var/lib/incus/cluster.yaml
sudo systemctl start incus
sudo systemctl restart incus-preseed.service
