# Experiments & Results Summary (Draft)

## 1. Existing Reports (Legacy Folder)
Numerous high-level visionary and phase completion reports under `x0tta6bl4_previous/`:
- SYSTEM_LAUNCH_REPORT.md
- METRICS_VALIDATION_REPORT.md / METRICS_CORRECTION_REPORT.md
- PROJECT_READINESS_ANALYSIS_REPORT.md
- BEYOND_LIMITS_PLAN.md
- MULTIVERSAL_EXPANSION_PLAN.md
- COMPLETE/FINAL evolution reports

Classification: Many are strategic narrative; low immediate engineering value for release week → parked.

## 2. Benchmark Placeholders
| Benchmark | File | Status | Next Step |
|-----------|------|--------|-----------|
| Baseline QAOA | classical_qaoa.py | Simulated only | Implement circuits (Qiskit) |
| φ-QAOA uplift | phi_qaoa_implementation.py | Placeholder | Add real parameter schedule |
| Mesh routing perf (NMP) | (missing benchmark script) | Not started | Create routing metrics collector |
| mTLS handshake stability | mtls_smoke_test.py | Ready harness | Run vs 3 nodes & record success ratio |

## 3. Test Failures & Observations
| Test | Issue | Impact | Fix Plan |
|------|-------|--------|----------|
| tests/mesh_networking/test_mesh_network.py | ImportError MeshNetworkManager | Blocks path tests | Export class in package init, adjust sys.path |
| tests/test_pqc_adapter.py | liboqs missing | PQC tests skipped/fail | Add conditional skip or install liboqs |
| tests/test_onion_mesh_integration.py | Source for OnionMeshNode absent | Privacy layer unverified | Provide stub implementation |

## 4. Metrics & Monitoring
- No unified Prometheus exporter for mesh metrics; only planned metrics in remediation/Zero Trust docs.
- Need script: `mesh_metrics_exporter.py` (future) to expose: latency, loss, path_churn, handshake_success_ratio.

## 5. Evidence Gaps (Patent / Claims)
| Claim | Evidence Needed | Source |
|-------|-----------------|--------|
| NMP 32.1% improvement | Routing benchmark vs baseline | New routing_benchmark.py |
| φ-QAOA 7653× | Approximation ratio distribution vs baseline | Real circuit runs |
| MAPE-K MTTR <1.2s | Failure injection test logs | self_healing_loop tests |

## 6. Recommended Experiment Backlog (Frozen Until 2025-11-09)
| Experiment | Effort | Value | Status |
|------------|-------|-------|--------|
| GNN anomaly detection prototype | HIGH | Medium | Frozen |
| Multi-backend QAOA run | MED | High | Frozen |
| Steganographic DPI evasion tests | HIGH | Medium | Frozen |

## 7. Immediate Week Actions
1. mTLS handshake experiment (50 loops × 3 nodes) → capture success ratio.
2. Mesh routing baseline capture (collect latency/loss for existing protocol mix).
3. Prepare minimal path scoring formula doc (PATH_SCORING.md).

## 8. Open Questions
- Есть ли существующий raw metrics лог для mesh latency?
- Сценарий отказа для MTTR измерения прописан?
- Какая модель baseline маршрутизации для NMP сравнения? (BATMAN? AODV?)

---
*File: EXPERIMENTS_RESULTS_SUMMARY.md*
