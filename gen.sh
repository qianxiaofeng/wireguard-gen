#!/bin/bash
private_ip=$(cat config.json | jq -r '.private_ip')
public_ip=$(cat config.json | jq -r '.public_ip')
port=$(cat config.json | jq -r '.port')

if [ ! -f privatekey ] && [ ! -f publickey ]; then
  echo -e "Generating wireguard keys..."
  wg genkey | tee privatekey | wg pubkey > publickey
fi

sleep 1;

private_key=$(cat privatekey)
public_key=$(cat publickey)

echo $private

sed -e "s@<port>@$port@" -e "s@<private_ip>@$private_ip@"  -e "s@<private_key>@$private_key@"    interface.template > interface
sed -e "s@<port>@$port@" -e "s@<private_ip>@$private_ip@"  -e "s@<public_ip>@$public_ip@" -e "s@<public_key>@$public_key@"   peer.template > peer
