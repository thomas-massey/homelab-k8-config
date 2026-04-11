#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="web"
SECRET_NAME="nginx-hello-secret"
SECRET_VALUE="${1:-Hello from Bitnami Sealed Secrets!}"
OUT_FILE="apps/nginx-hello/base/sealed-secret.yaml"

kubectl -n "${NAMESPACE}" create secret generic "${SECRET_NAME}" \
  --from-literal=hello="${SECRET_VALUE}" \
  --dry-run=client -o json \
  | kubeseal \
      --controller-name=sealed-secrets \
      --controller-namespace=sealed-secrets \
      --format=yaml \
  > "${OUT_FILE}"

echo "Wrote ${OUT_FILE}"
