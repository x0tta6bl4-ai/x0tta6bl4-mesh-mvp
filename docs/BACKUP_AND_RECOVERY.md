# Backup & Recovery Procedures (x0tta6bl4)

## Scope
- Vector DB (ChromaDB) and configs
- K8s manifests and monitoring
- Release artifacts (SBOM, snapshots, reports)

## Backup
```bash
# Minimal snapshot (docs, manifests, tests, configs)
cd /mnt/AC74CC2974CBF3DC/x0tta6bl4_paradox_zone
SNAP=x0tta6bl4_minimal_snapshot_$(date +%Y%m%d_%H%M%S).tar.gz
 tar -czf $SNAP docs *.md k8s-manifests monitoring chaos integration tests scripts \
  --warning=no-file-changed --ignore-failed-read

# Vector DB PVC backup (inside cluster)
kubectl -n x0tta6bl4-production exec deploy/x0tta6bl4-integration-orchestrator -- \
  sh -lc 'tar -czf - /data/vector_db' > vector_db_backup_$(date +%Y%m%d).tar.gz

# SBOM (if syft available)
syft dir:. -o cyclonedx-json > SBOM.json || true
```

## Recovery
```bash
# Restore vector DB
kubectl -n x0tta6bl4-production cp vector_db_backup_YYYYMMDD.tar.gz \
  deploy/x0tta6bl4-integration-orchestrator:/tmp/
kubectl -n x0tta6bl4-production exec deploy/x0tta6bl4-integration-orchestrator -- \
  sh -lc 'mkdir -p /data/vector_db && tar -xzf /tmp/vector_db_backup_YYYYMMDD.tar.gz -C /'

# Re-apply production manifests
kubectl apply -f k8s-manifests/production/
```

## IPFS & DAO (optional)
```bash
# Publish artifact to IPFS
./scripts/publish_to_ipfs.sh x0tta6bl4_minimal_snapshot_YYYYMMDD_HHMMSS.tar.gz
# Then (if credentials available) record CID on-chain via Foundry cast
```

## Verification
- Prometheus targets up, Grafana SLO within thresholds
- MAPE-K loop cycles healthy, no degraded components
- Alerts green
