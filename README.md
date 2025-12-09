# x0tta6bl4 — Zero-Trust Mesh MVP

Minimal pilot-ready Zero-Trust mesh for Kubernetes and community networks.

Includes:
- mTLS smoke test pod: `k8s/zero-trust/tests/spiffe-mtls-smoke.yaml`
- Smoke script: `scripts/mtls-smoke-check.sh`
- Full docs bundle: `docs/` (architecture, operations, roadmap, reality map)

> Note: this MVP assumes you already have SPIRE/SPIRE Agent and Envoy sidecars
> configured in your cluster as in the internal x0tta6bl4 setup. This repo focuses
> on the **pilot bundle** and smoke test for mTLS.

## Quickstart

```bash
# Apply the mTLS smoke pod (namespace mtls-demo must exist and have SPIRE Agent socket mounted)
kubectl apply -f k8s/zero-trust/tests/spiffe-mtls-smoke.yaml

# Run the smoke-check helper (from your own helper script or locally)
chmod +x scripts/mtls-smoke-check.sh
./scripts/mtls-smoke-check.sh   # ожидаем: [OK] mTLS green
```

## Documentation

Key documents (copied from the main x0tta6bl4 project):

- `docs/reality-map.md` — честная карта зрелости и ограничений.
- `docs/ru/implementation-roadmap.md` — дорожная карта реализации.
- `docs/technical/` — техническая архитектура.
- `docs/operations/` — runbooks и эксплуатация.

License: Apache-2.0 (TODO: добавить полный текст лицензии).
