# Knowledge Map (Release Week)

## 1. Domains
| Domain | Key Docs | Code | Status |
|--------|---------|------|--------|
| Mesh Core | MESH_CORE.md, ARCH_INDEX.md | mesh_networking/* | PARTIAL (gaps) |
| Security (mTLS/Zero Trust) | MTLS_REMEDIATION.md, SECURITY_ZERO_TRUST.md | scripts/*, security/policy/* | INITIAL COMPLETE |
| Post-Quantum Crypto | QUANTUM_INTEGRATION_SUMMARY.md | src/pqc_adapter.py, tests/test_pqc_adapter.py | PLACEHOLDER IMPLEMENTATIONS |
| Quantum Optimization | benchmarks/phi_qaoa/README.md | classical_qaoa.py, phi_qaoa_implementation.py | EXTERNAL BACKEND MISSING |
| Recovery / Self-Healing | MESH_CORE.md (Section 8) | (loop not implemented) | GAP |
| Observability | metrics_spec.md, audit_format.md | (exporter TBD) | PARTIAL |
| IP & Patents | PATENT_PORTFOLIO.md, FTO_MATRIX.md, IP_POLICY.md | (n/a) | DOCUMENTED |

## 2. Key Relationships
```
MeshNetworkManager → TopologyStore → PathFinder → Routes
        │                                │
        │                                └→ Recovery Loop (future)
        └→ Security (mTLS certs, Policy Engine)
Security Policy → Audit → Metrics → Observability Dashboard
PQC Adapter → Future handshake / key rotation integration
Quantum Benchmarks → Patent Evidence (φ-QAOA, NMP claims)
```

## 3. Critical Gaps
| Gap | Impact | Mitigation |
|-----|--------|-----------|
| Recovery loop missing | No automated healing | Implement skeleton + metrics triggers |
| Missing OnionMeshNode source | Privacy overlay unverified | Stub or retrieve source file |
| PQC KEM encrypt/decrypt absent | Incomplete post-quantum channel | Implement minimal AES-GCM encapsulation |
| Quantum backend integration absent | Patent enablement risk | Add Qiskit baseline circuits |
| Path scoring formula undefined | Unclear routing quality | Define and document formula |

## 4. Suggested Near-Term Additions
| Artifact | Purpose |
|----------|---------|
| recovery_loop.py | MAPE-K operational code |
| mesh_metrics_exporter.py | Prometheus metrics exposure |
| ONION_LAYER.md | Document privacy overlay architecture |
| PATH_SCORING.md | Formal scoring (latency, loss, jitter, capacity weights) |
| pqc_encrypt_flow.md | Detailing KEM + symmetric session sequence |

## 5. Prioritized Implementation Queue (Post-Release Week)
1. Mesh recovery loop (Phase 1 automated detection)
2. Path scoring & selection improvements
3. Kyber KEM encrypt/decrypt flow
4. Baseline QAOA circuits with reproducible seed
5. Metrics exporter integration (Prometheus + Grafana dashboard spec)

## 6. Open Questions
- Единственный storage backend для TopologyStore? In-memory vs persistent?
- Нужно ли многодоменное разделение trust zones сразу?
- Уровень детализации аудита: нужен ли subject-resource diff?
- Источник реальных latency metrics (packet probes?)

## 7. Map Legend
| Status | Meaning |
|--------|---------|
| PARTIAL | Some code present; missing integration/tests |
| GAP | No implementation yet |
| INITIAL COMPLETE | Minimum viable docs + scripts present |
| PLACEHOLDER | Stub logic; needs production implementation |
| EXTERNAL | Lives outside current repo; pending import |

---
*File: KNOWLEDGE_MAP.md*
