# How many new outputs were created by block 243,825?

block_hash=$(bitcoin-cli -signet getblockhash 243825)

outputs=$(bitcoin-cli -signet getblock | jq '.nTx')

echo "$outputs"
