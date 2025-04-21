# Only one tx in block 243,821 signals opt-in RBF. What is its txid?

block=243821

block_hash=$(bitcoin-cli -signet getblockhash 243821)

txid_1=$(bitcoin-cli -signet getblock $block_hash | jq -r '.tx[0]')

txid_2=$(bitcoin-cli -signet getblock $block_hash | jq -r '.tx[1]')

rawtx_1=$(bitcoin-cli -signet getrawtransaction $txid_1)

rawtx_2=$(bitcoin-cli -signet getrawtransaction $txid_2)

seq_1=$(bitcoin-cli -signet decoderawtransaction $rawtx_1 | jq '.vin[].sequence')

seq_2=$(bitcoin-cli -signet decoderawtransaction $rawtx_2 | jq '.vin[].sequence')


#echo "$seq_1"

#echo "$seq_2"

echo "$txid_2"
