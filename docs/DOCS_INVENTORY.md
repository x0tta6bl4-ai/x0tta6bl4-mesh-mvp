# Documentation Inventory (Snapshot)

## 1. Core Current Docs
| File | Purpose | Status |
|------|---------|--------|
| README.md | High-level intro | PRESENT |
| README_STATUS.md | Current status tracking | PRESENT |
| README_RELEASE.md | Release process | PRESENT |
| README_PACKAGING.md | Packaging guidance | PRESENT |
| README_MESH_PHILOSOPHY.md | Conceptual mesh rationale | PRESENT |
| README_LORA_INTEGRATION.md | LoRa integration notes | PRESENT |
| x0tta6bl4_roadmap_strategy.md | Strategic roadmap | PRESENT |
| x0tta6bl4_roadmap_index.md | Roadmap index | PRESENT |
| x0tta6bl4_quick_start.md | Quick start steps | PRESENT |
| x0tta6bl4_tech_debt_roadmap.md | Tech debt register | PRESENT |
| MTLS_REMEDIATION.md | mTLS remediation plan | PRESENT |
| SECURITY_ZERO_TRUST.md | Zero Trust integration | PRESENT |
| MESH_CORE.md | Mesh architecture | NEW |
| PATENT_PORTFOLIO.md | Patent statuses | PRESENT |
| FTO_MATRIX.md | Freedom-to-operate analysis | PRESENT |
| IP_POLICY.md | Licensing/IP governance | PRESENT |
| ARCH_INDEX.md | Architecture classification | PRESENT |
| BACKLOG_PARKING.md | Frozen backlog items | PRESENT |
| TOP3_EXECUTION_PLAN.md | Weekly execution plan | PRESENT |

## 2. Security & Policy Docs
| File | Focus |
|------|-------|
| security/policy/examples/basic_allow_deny.yaml | Policy rule format |
| security/audit/audit_format.md | Audit schema |
| security/telemetry/metrics_spec.md | Metrics + alerts |

## 3. Benchmark & Quantum Docs
| File | Purpose | Notes |
|------|---------|-------|
| benchmarks/phi_qaoa/README.md | Benchmark suite scaffold | φ-QAOA unconfirmed |
| classical_qaoa.py | Baseline placeholder | Needs real Qiskit impl |
| phi_qaoa_implementation.py | φ schedule placeholder | Pending evidence |

## 4. Legacy / Previous Reports (Selected)
Large set under `x0tta6bl4_previous/`:
- SYSTEM_LAUNCH_REPORT.md
- METRICS_VALIDATION_REPORT.md / METRICS_CORRECTION_REPORT.md
- IMMEDIATE_ACTIONS.md
- CONSOLIDATION_REPORT.md
- PROJECT_READINESS_ANALYSIS_REPORT.md
- BEYOND_LIMITS_PLAN.md / COMPLETE_REPORT.md
- MULTIVERSAL_EXPANSION_PLAN.md
- Various evolution / phase reports

These require triage → many high-level visionary documents (potential NOISE category for week focus).

## 5. Gaps Detected
| Gap | Required Doc | Priority |
|-----|--------------|----------|
| Recovery loop specifics | recovery_loop.md | HIGH |
| Mesh metrics exporter spec | mesh_metrics_spec.md | MEDIUM |
| Onion/Tor integration real source doc | ONION_LAYER.md | MEDIUM |
| Path scoring formula | PATH_SCORING.md | HIGH |
| PQC operational guide | PQC_GUIDE.md | MEDIUM |

## 6. Next Additions (Optional)
- Consolidate visionary/phase reports → `LEGACY_SUMMARY.md`
- Generate knowledge map → `KNOWLEDGE_MAP.md` (created separately)

---
*File: DOCS_INVENTORY.md*
