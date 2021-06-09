#!/bin/bash
CONSUL_BOOT_TOKEN=$(uuidgen)

cat << EOF > configs/server-acl-config.json
{
  "acl": {
    "tokens": {
      "master": "$CONSUL_BOOT_TOKEN",
      "agent": "$CONSUL_BOOT_TOKEN"
    }
  }
}
EOF

cat << EOF > configs/client-acl-config.json
{
  "acl": {
    "tokens": {
      "agent": "$CONSUL_BOOT_TOKEN"
    }
  }
}
EOF

echo "CONSUl_BOOT_TOKEN=$CONSUL_BOOT_TOKEN" && echo $CONSUL_BOOT_TOKEN > aclToken.txt
