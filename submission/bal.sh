#!/bin/bash

# Read the multisig address from file
multisig_address=$(cat multisig-address.txt)

# Validate the multisig address
address_info=$(bitcoin-cli -signet -rpcwallet=codaMW validateaddress "$multisig_address")
if [ "$(echo "$address_info" | jq -r '.isvalid')" != "true" ]; then
  echo "Error: Invalid multisig address: $multisig_address"
  exit 1
fi

# Set the amount to request (as specified in your script)
amount=0.00101210

# Fetch CAPTCHA from the faucet
captcha_url="https://signetfaucet.com/captcha"
captcha_response=$(curl -s "$captcha_url")

# Check if CAPTCHA fetch was successful
if [ -z "$captcha_response" ]; then
  echo "Error: Failed to fetch CAPTCHA from $captcha_url"
  exit 1
fi

# Save CAPTCHA image (assuming it's an SVG, as per getcoins.py)
captcha_file="captcha.svg"
echo "$captcha_response" > "$captcha_file"

# Convert SVG to a viewable format (e.g., PNG) using ImageMagick
convert_cmd="convert"
if ! command -v "$convert_cmd" &> /dev/null; then
  echo "Error: ImageMagick not installed. Please install it (e.g., sudo apt-get install imagemagick)"
  exit 1
fi
captcha_png="captcha.png"
$convert_cmd "$captcha_file" "$captcha_png"

# Prompt user to view and solve the CAPTCHA
echo "CAPTCHA image saved as $captcha_png"
echo "Please open $captcha_png, solve the CAPTCHA, and enter the solution below."
read -p "Enter CAPTCHA solution: " captcha_solution

# Send request to the Signet faucet with address, amount, and CAPTCHA
faucet_url="https://signetfaucet.com/claim/$multisig_address/$amount/$captcha_solution"
faucet_response=$(curl -s "$faucet_url")

# Print raw response for debugging
echo "Faucet response: $faucet_response"

# Extract the transaction ID (assuming the response is plain text or JSON)
# Based on typical faucet behavior, it might return the txid directly or in JSON
txid=$(echo "$faucet_response" | jq -r '.txid' 2>/dev/null || echo "$faucet_response" | grep -oE '[0-9a-f]{64}')

# Check if txid is valid (64-character hex string)
if [ -z "$txid" ] || ! [[ "$txid" =~ ^[0-9a-f]{64}$ ]]; then
  echo "Error: Failed to get valid txid from faucet. Response: $faucet_response"
  exit 1
fi

# Save the transaction ID to multisig-transaction.txt
echo "$txid" > multisig-transaction.txt

# Output for verification
echo "Transaction ID saved to multisig-transaction.txt: $txid"

# Clean up temporary files
rm -f "$captcha_file" "$captcha_png"
