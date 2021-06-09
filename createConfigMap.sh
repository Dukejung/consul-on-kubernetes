kubectl create configmap consul --from-file=configs/server.json --dry-run=client -o yaml | kubectl apply -f -
