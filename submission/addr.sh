#!/bin/bash

# Ensure the wallet is loaded
bitcoin-cli -signet -rpcwallet=codaMW loadwallet codaMW 2>/dev/null

# Generate three new addresses and get their public keys
pubkey1=$(bitcoin-cli -signet -rpcwallet=codaMW getnewaddress | xargs bitcoin-cli -signet -rpcwallet=codaMW getaddressinfo | jq -r '.pubkey')
pubkey2=$(bitcoin-cli -signet -rpcwallet=codaMW getnewaddress | xargs bitcoin-cli -signet -rpcwallet=codaMW getaddressinfo | jq -r '.pubkey')
pubkey3=$(bitcoin-cli -signet -rpcwallet=codaMW getnewaddress | xargs bitcoin-cli -signet -rpcwallet=codaMW getaddressinfo | jq -r '.pubkey')

# Create 2-of-3 multisig address
multisig_output=$(bitcoin-cli -signet -rpcwallet=codaMW createmultisig 2 "[\"$pubkey1\", \"$pubkey2\", \"$pubkey3\"]")

# Extract the multisig address
multisig_address=$(echo "$multisig_output" | jq -r '.address')

# Save the multisig address to multisig-address.txt
echo "$multisig_address" > multisig-address.txt

# Extract the redeem script
redeem_script=$(echo "$multisig_output" | jq -r '.redeemScript')

# Save the redeem script to multisig-redeem.txt
echo "$redeem_script" > multisig-redeem.txt

# Output for verification
echo "Redeem script saved to multisig-redeem.txt: $redeem_script"

# Output for verification
echo "Multisig address created and saved to multisig-address.txt: $multisig_address"
