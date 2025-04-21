# Which public key signed input 0 in this tx: d948454ceab1ad56982b11cf6f7157b91d3c6c5640e05c041cd17db6fff698f7


tx="d948454ceab1ad56982b11cf6f7157b91d3c6c5640e05c041cd17db6fff698f7"

raw_tx=$(bitcoin-cli -signet getrawtransaction $tx)

pubKey=$(bitcoin-cli -signet decoderawtransaction $raw_tx | jq -r '.vin[0].txinwitness[1]')

echo "$pubKey"
