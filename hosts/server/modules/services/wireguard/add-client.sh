#!/usr/bin/env bash
# Usage: sudo ./add-client.sh <CLIENT_NAME> <IP_LAST_OCTET>
# Example: sudo ./add-client.sh ipad 3

# --- CONFIGURATION ---
ENDPOINT="vpn.lassance.net.br:51820"
DNS="1.1.1.1"

NAME=$1
OCTET=$2

if [ -z "$NAME" ] || [ -z "$OCTET" ]; then
  echo "Usage: sudo $0 <name> <ip-suffix>"
  echo "Example: sudo $0 ipad 3   (for 10.100.0.3)"
  exit 1
fi

# If wg0 is down, replace this line with: SERVER_PUB="YOUR_SERVER_PUBLIC_KEY_MANUALLY"
SERVER_PUB=$(wg show wg0 public-key)

if [ -z "$SERVER_PUB" ]; then
  echo "Error: Could not read Server Public Key. Is WireGuard running?"
  exit 1
fi

CLIENT_PRIV=$(wg genkey)
CLIENT_PUB=$(echo "$CLIENT_PRIV" | wg pubkey)
CLIENT_IP="10.100.0.$OCTET"

echo "========================================================"
echo "       STEP 1: PASTE THIS INTO configuration.nix"
echo "========================================================"
echo ""
echo "        {"
echo "          # $NAME"
echo "          publicKey = \"$CLIENT_PUB\";"
echo "          allowedIPs = [ \"$CLIENT_IP/32\" ];"
echo "        }"
echo ""

echo "========================================================"
echo "        STEP 2: SCAN THIS QR CODE OR COPY CONFIG"
echo "========================================================"
echo ""

read -r -d '' CLIENT_CONF <<EOF
[Interface]
PrivateKey = $CLIENT_PRIV
Address = $CLIENT_IP/24
MTU = 1280
DNS = $DNS

[Peer]
PublicKey = $SERVER_PUB
Endpoint = $ENDPOINT
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25
EOF

echo "$CLIENT_CONF" | qrencode -t ansiutf8

echo ""
echo "--- CONFIG FILE CONTENT ---"
echo "$CLIENT_CONF"
echo "-----------------------------------------"
echo "Don't forget to rebuild"