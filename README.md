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

## Architecture (high-level)

```text
[Client/Service A]        [Service B]
      |                         |
   Envoy sidecar            Envoy sidecar
      |                         |
   SPIRE Agent              SPIRE Agent
       \                      /
        \---- SPIRE Server / CA
```

`x0tta6bl4-mesh-mvp` provides the mTLS smoke pod and helper script that plug
into this SPIFFE/SPIRE + Envoy topology. You reuse your own SPIRE setup and
only adapt the test pod / script to your cluster.

## Troubleshooting

- `spiffe-mtls-smoke` pod is not Ready:
  - check namespace `mtls-demo` exists and SPIRE Agent socket is mounted.
  - check SPIRE Agent is running and can reach SPIRE Server.
- Logs do not show `[SUCCESS] mTLS probe completed successfully`:
  - describe the pod: `kubectl describe pod spiffe-mtls-smoke -n mtls-demo`.
  - inspect full logs (both containers) for TLS or DNS errors.
- `mtls-smoke-check.sh` times out:
  - verify Kubernetes context/namespace.
  - increase `MAX_WAIT_SECONDS` in the script if your cluster is slow.

License: Apache-2.0 (TODO: добавить полный текст лицензии).

