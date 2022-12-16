echo "     _    _         _                   _____ _           _           "
echo "    / \  (_)_ __ __| |_ __ ___  _ __   |  ___(_)_ __   __| | ___ _ __ "
echo "   / _ \ | | '__/ _\` | '__/ _ \| '_ \  | |_  | | '_ \ / _\` |/ _ \ '__|"
echo "  / ___ \| | | | (_| | | | (_) | |_) | |  _| | | | | | (_| |  __/ |   "
echo " /_/   \_\_|_|  \__,_|_|  \___/| .__/  |_|   |_|_| |_|\__,_|\___|_|   "
echo "                               |_|                                    "

echo "Website  : https://www.airdropfinder.com"
echo "Telegram : https://t.me/airdropfind"
echo "Facebook : https://www.facebook.com/groups/744001332439290"
echo "Twitter  : https://twitter.com/AirdropfindX"
sleep 5

echo -e "\n==========INSTALLING DEPENDENCIES==========\n"
sleep 2

if [ -s /usr/local/bin/humansd ]; then
    sudo rm -rf /usr/local/bin/humansd
fi

if [ -s humans_latest_linux_amd64.tar.gz ]; then
    rm $HOME/humans_latest_linux_amd64.tar.gz
fi

wget https://github.com/humansdotai/humans/releases/download/latest/humans_latest_linux_amd64.tar.gz
tar -xvf humans_latest_linux_amd64.tar.gz
sudo mv humansd /usr/local/bin/humansd
rm -rf humans_latest_linux_amd64.tar.gz

if [ ! $HUMAN_MONIKER ]; then
    read -p "Enter node name: " HUMAN_MONIKER
    echo 'export HUMAN_MONIKER='\"${HUMAN_MONIKER}\" >> $HOME/.bashrc
    echo 'export HUMAN_CHAIN_ID=testnet-1' >> $HOME/.bashrc
fi

source $HOME/.bashrc
if [ -d $HOME/.humans ]; then
    rm -rf $HOME/.humans
fi

if [ -s $HOME/persistent_peers.txt ]; then
    rm $HOME/persistent_peers.txt
fi

humansd init $HUMAN_MONIKER --chain-id=$HUMAN_CHAIN_ID --home $HOME/.humans
curl -s https://rpc-testnet.humans.zone/genesis | jq -r .result.genesis > $HOME/.humans/config/genesis.json
echo "1df6735ac39c8f07ae5db31923a0d38ec6d1372b@45.136.40.6:26656
9726b7ba17ee87006055a9b7a45293bfd7b7f0fc@45.136.40.16:26656
6e84cde074d4af8a9df59d125db3bf8d6722a787@45.136.40.18:26656
eda3e2255f3c88f97673d61d6f37b243de34e9d9@45.136.40.13:26656
4de8c8acccecc8e0bed4a218c2ef235ab68b5cf2@45.136.40.12:26656
5c27e54b2b8a597cbbd1c43905d2c18a67637644@142.132.231.118:36656
3d1e89341f64df76599748b634cbabbb8ba3d1b2@65.21.170.3:43656
c7181941789884d6c468bfca31778b10f83a388e@95.217.12.217:26656
981e9829afd1679cd9fafc90edc4ff918057e6fe@217.13.223.167:60556
69822c67487d4907f162fdd6d42549e1df60c82d@65.21.224.248:26656
5e41a64298ca653af5297833c6a47eb1ad1bf367@154.38.161.212:36656
fa57a5bd809eb234f0135e2e62039b5ea09d3992@65.108.250.241:36656
aac683209559ca9ea48de4c47f3806483a5ec13f@185.244.180.97:26656
3fc2c2e3a4b11d540c736a4ae4c9c247fb05fbae@168.119.186.161:26656
c40acba57194521c2d16d59e9dcb2250bb8f2db2@162.55.245.219:36656
295be5393e99c60763c85987fa3f8045af20d828@95.214.53.178:36656
d55876bc04e363bbe68a7fb344dd65632e310f45@138.201.121.185:26668
3f13ad6e8795479b051d147a5049bf4bd0a63817@65.108.142.47:22656" > persistent_peers.txt
export PEERS=$(cat persistent_peers.txt| tr '\n' '_' | sed 's/_/,/g;s/,$//;s/^/"/;s/$/"/') && sed -i "s/persistent_peers = \"\"/persistent_peers = ${PEERS}/g" $HOME/.humans/config/config.toml
sed -i 's/minimum-gas-prices =.*/minimum-gas-prices = "0.025uheart"/g' $HOME/.humans/config/app.toml
CONFIG_TOML="$HOME/.humans/config/config.toml"
sed -i 's/timeout_propose =.*/timeout_propose = "100ms"/g' $CONFIG_TOML
sed -i 's/timeout_propose_delta =.*/timeout_propose_delta = "500ms"/g' $CONFIG_TOML
sed -i 's/timeout_prevote =.*/timeout_prevote = "100ms"/g' $CONFIG_TOML
sed -i 's/timeout_prevote_delta =.*/timeout_prevote_delta = "500ms"/g' $CONFIG_TOML
sed -i 's/timeout_precommit =.*/timeout_precommit = "100ms"/g' $CONFIG_TOML
sed -i 's/timeout_precommit_delta =.*/timeout_precommit_delta = "500ms"/g' $CONFIG_TOML
sed -i 's/timeout_commit =.*/timeout_commit = "1s"/g' $CONFIG_TOML
sed -i 's/skip_timeout_commit =.*/skip_timeout_commit = false/g' $CONFIG_TOML
PRUNING="custom"
PRUNING_KEEP_RECENT="100"
PRUNING_INTERVAL="10"
sed -i -e "s/^pruning *=.*/pruning = \"$PRUNING\"/" $HOME/.humans/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \
\"$PRUNING_KEEP_RECENT\"/" $HOME/.humans/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \
\"$PRUNING_INTERVAL\"/" $HOME/.humans/config/app.toml

echo -e "\n==========SETUP FINISH==========\n"
sleep 2

echo -e "To start node run \`humansd start\`"
echo -e "To check node status run \`humansd status 2>&1 | jq .SyncInfo\`"