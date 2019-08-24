#make sure we have enough memory
dd if=/dev/zero of=/mnt/myswap.swap bs=1M count=4000
mkswap /mnt/myswap.swap
chmod 0600 /mnt/myswap.swap
swapon /mnt/myswap.swap

#get all that we need
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get install software-properties-common wget curl nano git pwgen -y
sudo apt-get install build-essential libtool automake autoconf -y
sudo apt-get install autotools-dev autoconf pkg-config libssl-dev -y
sudo apt-get install libgmp3-dev libevent-dev bsdmainutils libboost-all-dev -y
sudo apt-get install libzmq3-dev -y
sudo apt-get install libminiupnpc-dev -y
sudo add-apt-repository ppa:bitcoin/bitcoin -y
sudo apt-get update -y
sudo apt-get install libdb4.8-dev libdb4.8++-dev -y

#install the SPEDO client
sudo mkdir $HOME/spedo
git clone https://github.com/spedo-tech/spedo.git spedo
cd $HOME/spedo
chmod 777 autogen.sh
chmod 777 share/genbuild.sh
./autogen.sh
./configure --disable-tests --disable-gui-tests
sudo make
sudo make install

#finish setting up VPS for the Masternode
sudo mkdir $HOME/.spedocore
EXIP=`wget -qO- eth0.me`
PASS=`pwgen -1 20 -n`

echo "Please paste your masternode key in the terminal and hit enter.";
read MASTERNODEKEY

printf "rpcuser=SPOuser\nrpcpassword=$PASS\nrpcallowip=127.0.0.1\nrpcport=5336\nserver=1\ndaemon=1\nlisten=1\nmaxconnections=400\nexternalip=$EXIP:5335\nmasternode=1\nmasternodeprivkey=$MASTERNODEKEY\naddnode=81.4.101.218:5335\naddnode=81.4.101.186:5335\naddnode=81.4.101.185:5335\naddnode=81.4.101.180:5335\naddnode=81.4.101.191:5335\naddnode=81.4.101.189:5335\naddnode=81.4.101.187:5335" > /$HOME/.spedocore/spedo.conf

spedod
echo "Client started. Please wait for the network to sync.";
until spedo-cli mnsync status | grep -m 1 '"IsSynced": true'; do sleep 1 ; done > /dev/null 2>&1
echo "Finished! Terminal may now be closed.";