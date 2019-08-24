#!/bin/bash
path=/home/dony
nodname=essence
localbind=91.235.250.118
#не забудь addnode проверить в самом внизу

file="${nodname}d_$1.sh"

if [ $# -ne 2 ]; then
    echo "команда dir key"
exit 1

elif [ -f "$file" ]
then
        echo "$file exist."
		exit 1
		
else
source ${path}/.${nodname}core$(($1-1))/${nodname}.conf
newport=$(($rpcport+2))



        cat > ${nodname}d_$1.sh << EOF
#!/bin/bash
${nodname}d -conf=$path/.${nodname}core$1/${nodname}.conf -datadir=$path/.${nodname}core$1/ \$*

EOF
        cat > ${nodname}-cli_$1.sh << EOF
#!/bin/bash
${nodname}-cli -conf=$path/.${nodname}core$1/${nodname}.conf -datadir=$path/.${nodname}core$1/ \$*

EOF

chmod 755 ${nodname}-cli_$1.sh
chmod 755 ${nodname}d_$1.sh
sudo cp -R .${nodname}core$(($1-1))/ .${nodname}core$1/
sudo rm .${nodname}core$1/${nodname}.conf 
sudo rm .${nodname}core$1/debug.log 
sudo rm .${nodname}core$1/db.log 

cat <<EOF | sudo tee .${nodname}core$1/${nodname}.conf 
rpcuser=$rpcuser
rpcpassword=$rpcpassword
rpcallowip=127.0.0.1
rpcport=$newport
externalip=$externalip
bind=$localbind:$(($newport-1))
server=1
daemon=1
listen=1
maxconnections=$maxconnections
masternode=1
masternodeprivkey=$2

addnode=80.211.182.185:3553
addnode=173.249.14.97:3553
addnode=104.156.252.71:3553
addnode=185.39.195.184:3553
addnode=93.186.254.128:3553
addnode=[2001:19f0:7402:c48:8000::1000]:3553
addnode=45.63.19.201:3553
addnode=103.245.208.79:3553

EOF

sudo ./${nodname}d_$1.sh -daemon

fi

