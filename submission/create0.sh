rawTxn="02000000000101f9dc32b46f3f0916353be82acfe7127838d9f4c40ec04a8edecd0df097cd9764f207000000fdffffff02536001000000000016001493e78964f54b7422f31c55ded6ad094fa7e49cc283260000000000001600146b43827211e69f19ea3fb7b74c865ffa326c2aac024730440220562ee6c5dd57cd274cd585c85645c0cdfa75351ff3b5e15f90f7e6fb2f377914022057e079185e766354a0aaaabc1647ecbd09580d81cae460a1f409949d67045e92012103b5c4f59ed9797f45973d4cc2a3327ea7524e0ab8662232f7d60a3dccf0808ec700000000"

txn_id=$(bitcoin-cli -signet decoderawtransaction $rawTxn | jq -r '.txid')

echo $txn_id

TARGET_ADDRESS="tb1q2faxyf4yk99hutqjrgth4yn25fsgs3k6tlmsdq"

echo "getting the the vout....."

vouts=$(bitcoin-cli -signet decoderawtransaction $rawTxn | jq -r '.vout[]')

echo "$vouts"

utxo_vout_1=$(bitcoin-cli -signet decoderawtransaction $rawTxn | jq -r --arg addr "$TARGET_ADDRESS" '.vout[] | select(.scriptPubKey.address == $addr) | .n')

echo "$utxo_vout"
