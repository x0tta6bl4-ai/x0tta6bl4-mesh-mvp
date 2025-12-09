# Helm Chart Placeholder

The full production Helm chart for the x0tta6bl4 Zero-Trust mesh lives
in the main project repository and is **not** bundled here to keep this
MVP repository lightweight.

For pilots, this repository focuses on:

- The mTLS smoke test pod:
  - `k8s/zero-trust/tests/spiffe-mtls-smoke.yaml`
- The smoke-check helper script:
  - `scripts/mtls-smoke-check.sh`
- Documentation around Zero-Trust mesh design and operations:
  - `docs/`

If you need the full Helm chart:

- See the main project: `https://github.com/x0tta6bl4/x0tta6bl4_paradox_zone`
- Or contact the x0tta6bl4 team for a pilot-specific Helm bundle.
