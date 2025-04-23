# How many satoshis did this transaction pay for fee?: b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb

tx="b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb"

raw_tx=$(bitcoin-cli -signet getrawtransaction $tx)

vin_txid=$(bitcoin-cli -signet decoderawtransaction $raw_tx | jq -r '.vin[].txid')

raw_in=$(bitcoin-cli -signet getrawtransaction $vin_txid)

input_value=$(bitcoin-cli -signet decoderawtransaction $raw_in | jq '.vout[0].value * 100000000')

output_value=$(bitcoin-cli -signet decoderawtransaction $raw_tx | jq '[.vout[].value] | add * 100000000 | round')

fees=$((input_value - output_value))

echo "$fees"


