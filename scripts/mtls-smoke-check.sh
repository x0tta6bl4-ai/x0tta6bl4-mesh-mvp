#!/usr/bin/env bash
set -euo pipefail

NS="${NS:-mtls-demo}"
POD_NAME="spiffe-mtls-smoke"
MANIFEST="k8s/zero-trust/tests/spiffe-mtls-smoke.yaml"

echo "[INFO] Deleting previous pod if exists..."
kubectl -n "$NS" delete pod "$POD_NAME" --ignore-not-found=true >/dev/null 2>&1 || true

echo "[INFO] Applying manifest $MANIFEST..."
kubectl -n "$NS" apply -f "$MANIFEST" >/dev/null

echo "[INFO] Waiting for pod to be Ready..."
if ! kubectl -n "$NS" wait --for=condition=Ready "pod/$POD_NAME" --timeout=120s; then
  echo "[WARN] Pod $POD_NAME did not become Ready within 120s, continuing to check logs..."
fi

echo "[INFO] Waiting for pod to start..."
sleep 5

END=$((SECONDS + 300))
while (( SECONDS < END )); do
  logs=$(kubectl -n "$NS" logs "$POD_NAME" -c mtls-curl 2>/dev/null || true)

  if grep -q "[SUCCESS] mTLS probe completed successfully" <<<"$logs"; then
    echo "[OK] mTLS green"
    exit 0
  fi

  if grep -q "[ERROR] mTLS probe failed" <<<"$logs"; then
    echo "[ERROR] mTLS probe failed"
    echo "$logs"
    exit 1
  fi

  if [[ -z "$logs" ]]; then
    echo "[INFO] Waiting for mtls-curl logs..."
  else
    echo "[INFO] Still running, no SUCCESS/ERROR yet..."
  fi

  sleep 5
done

echo "[ERROR] Timeout waiting for mTLS smoke result"
kubectl -n "$NS" get pod "$POD_NAME" -o wide || true
exit 1
