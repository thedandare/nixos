#!/bin/sh
rtl_fm -M fm -f $1M -s 171k -A std -l 0 -g 40 | ./result/bin/redsea -r 171k -e | aplay -D plughw:2,0 -t raw -r 171000 -c 1 -f S16_LE


