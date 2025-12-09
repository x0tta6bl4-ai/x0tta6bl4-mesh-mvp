# Quantum & Post-Quantum Integration Summary (Draft)

## 1. Scope
Обзор текущих артефактов, заявленных возможностей и реальных реализаций квантовых (QAOA/φ-QAOA) и постквантовых (Kyber/Dilithium) компонентов.

## 2. Quantum Optimization (QAOA / φ-QAOA)
| Aspect | Status | Evidence | Gap |
|--------|--------|----------|-----|
| Baseline QAOA | Placeholder simulation | `classical_qaoa.py` | No circuit backend |
| φ-QAOA Harmonic Scheduling | Placeholder | `phi_qaoa_implementation.py` | Unconfirmed patent claim |
| 7653× performance claim | Extraordinary | Patent draft text | Needs benchmark validation |
| RSA-4096 factoring via QAOA | Claim (unverified) | Patent draft mention | Likely infeasible (remove) |
| Benchmark suite scaffold | Present | `benchmarks/phi_qaoa/README.md` | Needs real runs |

## 3. Planned Quantum Backend Integration
| Backend | Integration Path | Status |
|---------|------------------|--------|
| Qiskit Aer | Local simulator for circuits | NOT STARTED |
| Qiskit Runtime | Cloud performance tests | NOT STARTED |
| IonQ / Rigetti / AWS Braket | Multi-provider API | NOT STARTED |
| Golden Ratio parameter scheduler | Custom layer | DESIGN ONLY |

## 4. Post-Quantum Cryptography
| Algorithm | File | Status | Notes |
|-----------|------|--------|-------|
| Kyber512/1024 KEM | `pqc_adapter.py` | Keypair OK (if liboqs) | Encrypt/Decrypt NotImplemented |
| Dilithium2/5 Signature | `pqc_adapter.py` | Keypair OK (if liboqs) | Sign/Verify NotImplemented |
| Hybrid Dilithium+Ed25519 | `pqc_adapter.py` | Partial (placeholder combine) | Placeholder Dilithium signature content |
| Ed25519 fallback | `pqc_adapter.py` | Implemented | Works via cryptography |
| RSA4096 fallback | `pqc_adapter.py` | Keypair OK | Encryption NotImplemented |

## 5. Test Artifacts
| Test | Purpose | Result |
|------|---------|--------|
| tests/test_pqc_adapter.py | PQC adapter usage | Fails if liboqs missing |
| tests/test_mape_k_integration.py | MAPE-K + routing references | Assumes PQC availability? |

## 6. Risks
| Risk | Impact | Mitigation |
|------|--------|-----------|
| Unvalidated φ-QAOA claim | Patent rejection | Conservative framing + benchmarks |
| Missing crypto implementations | Security gap | Implement minimal AES-GCM + KEM flow |
| External quantum repo absence | Integration delay | Add backend tasks to roadmap Q1 2026 |

## 7. Roadmap
| Phase | Quantum Tasks | PQC Tasks | Exit |
|-------|---------------|----------|------|
| 1 | Implement real baseline QAOA (Qiskit) | Kyber encrypt/decrypt stub | Run sample circuits |
| 2 | φ scheduling layer with param mapping | Dilithium sign/verify integration | Comparative benchmarks |
| 3 | Multi-backend (IonQ/Rigetti) | Hybrid signature finalization | Cross-provider perf matrix |

## 8. Immediate Actions
- Remove or freeze RSA-4096 factoring claim from public materials.
- Implement Kyber KEM encrypt/decrypt stub when liboqs available (store encapsulated key).
- Add `quantum_backend_tasks.md` with concrete backlog (optional).

## 9. Open Questions
- Что является метрикой 7653×? (Approximation ratio? Depth? Runtime?)
- Необходима ли φ-QAOA реальная новизна или лучше адаптивный schedule ML?
- Целевой набор задач (MaxCut, TSP, portfolio selection)?

---
*File: QUANTUM_INTEGRATION_SUMMARY.md*
