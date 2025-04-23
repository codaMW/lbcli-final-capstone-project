set -e

WALLET="codaMW"
TXID="6497cd97f00dcdde8e4ac00ec4f4d9387812e7cf2ae83b3516093f6fb432dcf9"
VOUT=2034
SEQUENCE=4294967293
DEST="tb1qddpcyus3u603n63lk7m5epjllgexc24vj5ltp7"
AMOUNT=0.00010000  # 10,000 sats

rawtx=$(bitcoin-cli -signet createrawtransaction \
"[{\"txid\":\"$TXID\",\"vout\":$VOUT,\"sequence\":$SEQUENCE}]" \
"{\"$DEST\":$AMOUNT}")

funded=$(bitcoin-cli -signet -rpcwallet=$WALLET fundrawtransaction "$rawtx" \
'{"subtractFeeFromOutputs":[0]}')
funded_hex=$(echo "$funded" | jq -r '.hex')

signed=$(bitcoin-cli -signet -rpcwallet=$WALLET signrawtransactionwithwallet "$funded_hex")
signed_hex=$(echo "$signed" | jq -r '.hex')

txid=$(bitcoin-cli -signet -rpcwallet=$WALLET sendrawtransaction "$signed_hex")
echo "✅ TX sent: $txid"
echo "$txid" > transaction-2.txt

echo "⏳ Waiting for confirmation..."
while true; do
  blockhash=$(bitcoin-cli -signet -rpcwallet=$WALLET gettransaction "$txid" | jq -r '.blockhash')
  if [[ "$blockhash" != "null" ]]; then
    break
  fi
  sleep 10
done

echo "$blockhash" > block-2.txt

coinbase_txid=$(bitcoin-cli -signet getblock "$blockhash" | jq -r '.tx[0]')
echo "$coinbase_txid" > coinbase-2.txt

echo "✅ Done. Files:"
ls -1 transaction-2.txt block-2.txt coinbase-2.txt

