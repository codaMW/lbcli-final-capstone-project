# What is the hash of block 243,833?

block_hash=$(bitcoin-cli -signet getblockhash 243833)

echo "$block_hash"
