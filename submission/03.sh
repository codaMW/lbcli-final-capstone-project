# Which tx in block 216,351 spends the coinbase output of block 216,128?

coinbase_txid=$(bitcoin-cli -signet getblock $(bitcoin-cli -signet getblockhash 216128) | jq -r '.tx[0]')

blockhash_216351=$(bitcoin-cli -signet getblockhash 216351)

txids=$(bitcoin-cli -signet getblock $blockhash_216351 | jq -r '.tx[]')

for txid in $txids; do
  vin_txids=$(bitcoin-cli -signet getrawtransaction $txid true $blockhash_216351 | jq -r '.vin[].txid')

  for vin_txid in $vin_txids; do
    if [ "$vin_txid" = "$coinbase_txid" ]; then
      echo "$txid"
    fi
  done
done
