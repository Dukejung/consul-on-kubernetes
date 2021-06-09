GOSSIP_ENCRYPTION_KEY=$(consul keygen) && kubectl create secret generic consul \
  --from-literal="gossip-encryption-key=${GOSSIP_ENCRYPTION_KEY}" \
  --from-file=configs/server-acl-config.json \
  --from-file=configs/client-acl-config.json \
  --dry-run=client -o yaml | kubectl apply -f -
