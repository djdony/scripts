#!/bin/bash
path=/home/dony
nodname=essence

file="${nodname}d_$1.sh"

if [ $# -ne 1 ]; then
    echo "команда dir Y"
exit 1

else
sudo rm $path/${nodname}-cli_$1.sh
sudo rm $path/${nodname}d_$1.sh
sudo rm -R $path/.${nodname}core$1/ 

fi
