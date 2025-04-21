# what is the coinbase tx in this block 243,834

block_count=243834

block_hash=$(bitcoin-cli -signet getblockhash $block_count)

coinbase_tx=$(bitcoin-cli -signet getblock $block_hash | jq -r '.tx[0]')

echo "$coinbase_tx"


