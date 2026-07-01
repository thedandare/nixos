#!/bin/sh
chgrp users /ubunix -R
chgrp users /etc/nixos -R
chmod 770 /ubunix -R
chmod 770 /etc/nixos -R
chown leo -R /ubunix
