#get masternode key from user
echo "Before we proceed with the installation please paste here your masternode key (right mouse click) and confirm with Enter";
read KEYM

#setup swap to make sure there's enough memory for compiling the daemon 
dd if=/dev/zero of=/mnt/myswap.swap bs=1M count=5000
mkswap /mnt/myswap.swap
chmod 0600 /mnt/myswap.swap
swapon /mnt/myswap.swap

#download and install required packages
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get install software-properties-common -y
sudo apt-get install git -y
sudo apt-get install wget -y
sudo apt-get install curl -y
sudo apt-get install nano -y

sudo apt-get install build-essential libtool automake autoconf -y
sudo apt-get install autotools-dev autoconf pkg-config libssl-dev -y
sudo apt-get install libgmp3-dev libevent-dev bsdmainutils libboost-all-dev -y
sudo apt-get install libzmq3-dev -y
sudo apt-get install libminiupnpc-dev -y

sudo add-apt-repository ppa:bitcoin/bitcoin -y
sudo apt-get update -y
sudo apt-get install libdb4.8-dev libdb4.8++-dev -y

#get essence client from github, compile the client
sudo mkdir $HOME/essence
git clone https://github.com/essencecoin/essence.git essence
cd $HOME/essence
chmod +x autogen.sh
./autogen.sh
./configure --disable-tests
chmod +x share/genbuild.sh
sudo make
sudo make install

#setup config file for the masternode
sudo apt-get install pwgen -y

sudo mkdir $HOME/.essencecore
PASSWORD=`pwgen -1 20 -n`
EXTIP=`wget -qO- eth0.me`
printf "rpcuser=essenceuser\nrpcpassword=$PASSWORD\nrpcallowip=127.0.0.1\nrpcport=3554\nexternalip=$EXTIP:3553\nserver=1\ndaemon=1\nlisten=1\nmaxconnections=512\nmasternode=1\nmasternodeprivkey=$KEYM" > /$HOME/.essencecore/essence.conf


#start the client and make sure it's synced before confirming completion
essenced --daemon
sleep 3
echo "Waiting for your Essence client to fully sync with the network. Once it's done, you will receive the confirmation.";
until essence-cli mnsync status | grep -m 1 '"IsSynced": true'; do sleep 1 ; done > /dev/null 2>&1
echo "Done setting up your VPS. You may now close the connection.";