# Code Modules Overview (Mesh & Security)

## 1. Languages & Structure
Primarily Python (async + standard libraries). Some placeholders reference external quantum frameworks (Qiskit) not imported.

## 2. Mesh Networking Modules
| Module | Key Classes/Funcs | Purpose | Notes |
|--------|-------------------|---------|-------|
| mesh_network_manager.py | MeshNetworkManager (?) | Orchestrates topology, routes | Import errors in tests suggest export/path issue |
| pathfinder.py | PathFinder, compute paths | Routing strategy selection | Works with k_disjoint_spf |
| k_disjoint_spf.py | KDisjointSPF, Path | Disjoint shortest path sets | Used in MAPE-K plan |
| aodv_router.py | AODVRouter (assumed) | Reactive routing | Review needed |
| batman_adv.py | BATMANAdvProtocol | Layer-2 metrics integration | Used in hybrid tests |
| cjdns_integration.py | CjdnsIntegration (?) | Crypto IPv6 overlay | Placeholder state |
| topology_store.py | TopologyStore | Graph storage (nodes/links) | Persistence strategy unspecified |
| example_usage.py | Demo functions | Illustrative usage | Outdated? |

## 3. Onion / Privacy Layer
Referenced in tests: `x0tta6bl4.mesh.onion_mesh_node` with OnionMeshNode, hidden services, Tor status objects. Source not present in current visible tree → external or missing module. Action: locate/import actual file.

## 4. Security & Trust Modules
| Module | Purpose | Status |
|--------|---------|--------|
| security/policy/policy_engine.py | Allow/Deny evaluation | Working minimal |
| scripts/zt_emit_audit.py | Emit audit events | Working |
| scripts/zt_executor.py | Policy + audit pipeline | Working |
| scripts/mtls_audit.py | Cert inventory | Working (minor type warnings suppressed) |
| scripts/mtls_smoke_test.py | Handshake stress test | Working (requires endpoints/certs) |

## 5. Post-Quantum Cryptography
`src/pqc_adapter.py` provides adapter with hybrid design (Dilithium + Ed25519). Major methods (encrypt/decrypt KEM, RSA hybrid, Dilithium sign) NotImplemented.

Action: implement minimal Kyber encapsulation + AES-GCM flow (when liboqs available) and degrade gracefully.

## 6. Quantum Optimization Placeholders
| File | Role | Gap |
|------|------|-----|
| classical_qaoa.py | Baseline metrics simulation | No actual quantum circuit execution |
| phi_qaoa_implementation.py | Harmonic uplift scheduling | Requires real backend integration |

## 7. Tests Summary (Selected)
| Test File | Focus | Issue |
|-----------|-------|-------|
| tests/mesh_networking/test_mesh_network.py | MeshNetworkManager import | ImportError (module path) |
| tests/test_onion_mesh_integration.py | Onion/Tor + BATMAN | Source for OnionMeshNode missing |
| tests/test_mape_k_integration.py | MAPE-K integration + routing | Path & protocol interplay |
| tests/test_pqc_adapter.py | PQC key generation (Kyber) | Fails w/o liboqs |

## 8. Immediate Fix Targets
1. Export MeshNetworkManager in `mesh_networking/__init__.py` and verify test discovery.
2. Add placeholder OnionMeshNode implementation if external module unavailable.
3. Implement minimal KEM stub (Kyber) for encrypt/decrypt to remove NotImplemented blockers.
4. Create `recovery_loop.py` skeleton with detect/analyze/plan/execute functions.

## 9. Dependency Observations
- Conditional imports (liboqs, cryptography) for PQC.
- No explicit dependency manager file captured (requirements?) except consolidated file outside scope.

## 10. Risk & Technical Debt
| Area | Risk | Mitigation |
|------|------|-----------|
| Missing source (OnionMeshNode) | Test failures | Stub or retrieve source |
| NotImplemented crypto | Security feature gaps | Implement minimal flows |
| Lack of metrics exporter | Observability blind spots | Build Prometheus exporter |
| Unspecified path scoring formula | Unpredictable routing quality | Document & implement scoring function |

---
*File: CODE_MODULES_OVERVIEW.md*
