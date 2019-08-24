#!/bin/bash
path=/home/dony
nodname=essence

file="${nodname}d_$1.sh"

if [ $# -ne 1 ]; then
    echo "команда dir Y"
exit 1

else
sudo  $path/${nodname}-cli_$1.sh stop
sudo $path/${nodname}d_$1.sh -daemon

fi
