# Mesh MVP Examples (Reserved)

This directory is reserved for future, richer examples of the
x0tta6bl4 Zero-Trust mesh (multiple services, advanced routing, etc.).

For the current `v0.1.0-pilot-ready` release, the essential pieces are:

- `k8s/zero-trust/tests/spiffe-mtls-smoke.yaml` — mTLS smoke test pod
- `scripts/mtls-smoke-check.sh` — helper script to validate `[OK] mTLS green`
- `deploy/ZERO-TRUST-QUICKSTART.md` — end-to-end quickstart
- `docs/` — architecture, operations, roadmap, reality map

The goal is to keep this repository lightweight and focused on the
pilot experience. More complex mesh examples will be added here in
future versions.
