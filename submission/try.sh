hex=$(bitcoin-cli -signet createrawtransaction \
"[{\"txid\":\"6497cd97f00dcdde8e4ac00ec4f4d9387812e7cf2ae83b3516093f6fb432dcf9\",\"vout\":2034,\"sequence\":4294967293}]" \
"{\"tb1qddpcyus3u603n63lk7m5epjllgexc24vj5ltp7\":0.00010000}")

fund=$(bitcoin-cli -signet -rpcwallet=codaMW fundrawtransaction $hex '{"feeRate":0.00000005}')


signed=$(bitcoin-cli -signet -rpcwallet=codaMW signrawtransactionwithwallet $fund)

echo "$signed"
#bitcoin-cli -signet -rpcwallet=codaMW sendrawtransaction $signed

