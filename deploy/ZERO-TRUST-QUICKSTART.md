# Zero-Trust Mesh MVP — Quickstart

This quickstart shows how to go from a clean Kubernetes cluster with
SPIRE/SPIRE Agent + Envoy sidecars already configured to a **green mTLS
smoke test** using the `x0tta6bl4-mesh-mvp` repository.

> This document focuses on the **pilot bundle** and smoke test for mTLS.
> It does not cover provisioning or operating SPIRE itself.

---

## 1. Prerequisites

- Kubernetes cluster (1.20+)
- `kubectl` configured to talk to the cluster
- SPIRE Server and SPIRE Agent deployed
- Envoy sidecars injected for the demo services
- Namespace `mtls-demo` with the SPIRE Agent socket mounted

For a full architecture overview see `docs/SECURITY_ZERO_TRUST.md` and
`docs/MESH_CORE.md`.

---

## 2. Get the repository

```bash
git clone https://github.com/x0tta6bl4-ai/x0tta6bl4-mesh-mvp.git
cd x0tta6bl4-mesh-mvp
```

---

## 3. Deploy the mTLS smoke pod

```bash
# apply the mTLS smoke pod to the mtls-demo namespace
kubectl apply -f k8s/zero-trust/tests/spiffe-mtls-smoke.yaml
```

This creates the `spiffe-mtls-smoke` pod with two containers:

- `svid-fetch` — fetches SVIDs from the SPIRE Agent
- `mtls-curl` — performs an mTLS HTTP request between demo services

---

## 4. Run the smoke-check helper

```bash
chmod +x scripts/mtls-smoke-check.sh
./scripts/mtls-smoke-check.sh
```

Expected output:

```text
[OK] mTLS green
```

If the script times out or prints `[ERROR]`, inspect pod logs and
`docs/TROUBLESHOOTING.md`.

---

## 5. Next steps

- Integrate your own services by following the Envoy sidecar pattern
- Use the internal metrics from Pilot-0 (MTTR ~3.1s, ~82 ms latency
  overhead, 100% smoke-test success) as a **reference**, then measure
  your own SLOs.
- If you are running a pilot with the x0tta6bl4 team, share your
  results and feedback to influence the roadmap.
