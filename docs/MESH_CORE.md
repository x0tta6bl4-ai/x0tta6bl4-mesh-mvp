# MESH_CORE Architecture (Draft v1)

## 1. Scope
Описывает архитектуру self-healing mesh: компоненты, модели, события, маршрутизация, восстановление, точки интеграции безопасности.

## 2. High-Level Diagram (Textual)
```
Nodes ↔ Link Layer (BATMAN/AODV/CJDNS) ↔ MeshNetworkManager
      ↘ Metrics/Health ↘ TopologyStore
       ↘ PathFinder (K-Disjoint SPF, heuristics) ↘ Routing Decisions
        ↘ Security (mTLS, Zero Trust policy executor) ↘ Enforcement (sidecar)
         ↘ Recovery Loop (Detect → Analyze → Plan → Execute) ↘ State Updates
```

## 3. Core Components
| Component | File(s) | Responsibility | Status |
|-----------|---------|----------------|--------|
| MeshNetworkManager | `mesh_networking/mesh_network_manager.py` | orchestration: peers, routes, protocol adapters | PARTIAL |
| PathFinder | `mesh_networking/pathfinder.py`, `k_disjoint_spf.py` | compute candidate paths (disjoint, cost-based) | PARTIAL |
| TopologyStore | `mesh_networking/topology_store.py` | graph state: nodes, links, metrics | PARTIAL |
| Protocol Adapters | `batman_adv.py`, `aodv_router.py`, `cjdns_integration.py` | integrate underlying protocols | PARTIAL |
| Onion/Tor Layer | `x0tta6bl4.mesh.onion_mesh_node` (tests reference) | privacy overlay, hidden services | EXTERNAL REF/TBD |
| PQC Adapter | `src/pqc_adapter.py` | post-quantum keys/signatures | PLACEHOLDER (many NotImplemented) |
| Security Policy | `security/policy/*.py` | allow/deny evaluation, audit | INITIAL |
| mTLS Subsystem | `scripts/mtls_audit.py`, `scripts/mtls_smoke_test.py` | cert inventory + handshake validation | INITIAL |
| Recovery Loop | (planned) | detect failures, anomaly scoring, reroute | GAP |
| Metrics/Audit | `security/telemetry/metrics_spec.md`, future Prometheus exporter | observability | PARTIAL |

## 4. Data Models (Conceptual)
| Entity | Attributes | Source |
|--------|-----------|--------|
| Node | id, public_key, capabilities, last_seen | discovery + health checks |
| Link | node_a, node_b, latency_ms, loss_rate, score | protocol adapters + metrics collection |
| Path | ordered_nodes, total_cost, disjoint_group_id | PathFinder |
| Peer (Onion) | onion_address, peer_id, status, verified_at | OnionMeshNode |
| Health Snapshot | node_id, health_score, tor_status, active_peers | metrics loop |

## 5. Event Flow (MAPE-K Style)
```
DETECT: metrics collector, handshake failures, latency spikes
ANALYZE: anomaly scoring (planned GNN), verify path degradation
PLAN: compute alternate disjoint paths, schedule rotations (cert/routes)
EXECUTE: apply route updates, trigger graceful reload, emit audit
KNOWLEDGE: historical metrics, topology versions, policy decisions
```

## 6. Routing Strategies
| Strategy | File | Notes |
|----------|------|-------|
| K-Disjoint SPF | `k_disjoint_spf.py` | resilience for failure scenarios |
| AODV | `aodv_router.py` | on-demand distance vector |
| BATMAN-adv | `batman_adv.py` | layer-2 mesh metrics integration |
| CJDNS | `cjdns_integration.py` | ipv6 crypto addressing |
| Onion Hybrid | external (tests) | privacy overlay layering |

## 7. Security Integration Points
| Layer | Mechanism | Artifact |
|-------|----------|----------|
| Transport | mTLS handshake | `MTLS_REMEDIATION.md` |
| Identity | mTLS CN + token | `SECURITY_ZERO_TRUST.md` |
| Policy | allow/deny rules | `policy_engine.py`, `basic_allow_deny.yaml` |
| Audit | JSON lines events | `zt_emit_audit.py`, `audit_format.md` |
| PQC | Kyber/Dilithium fallback/hybrid | `pqc_adapter.py` |

## 8. Recovery / Self-Healing Roadmap
| Phase | Feature | Exit Criteria |
|-------|---------|---------------|
| 1 | Baseline metrics + manual remediation | health snapshot visible |
| 2 | Automated detection (thresholds) | auto route switch on link failure |
| 3 | Predictive routing (GNN anomaly) | reroute before SLA breach |
| 4 | Policy-aware isolation | compromised node quarantined |
| 5 | Full MAPE-K closed loop | MTTR < 1.2s (claim) |

## 9. Open Gaps
- No unified exporter for mesh metrics (latency, loss, path churn) → add `mesh_metrics_exporter.py`.
- Recovery loop is conceptual only.
- OnionMeshNode implementation not in current tree (tests reference external module).
- PQC encrypt/decrypt/sign/verify implementations mostly NotImplemented.
- Integration tests failing: `ImportError: MeshNetworkManager` (path or packaging issue) → fix module path & `__init__.py` exports.

## 10. Immediate Actions
| Action | Type | Priority |
|--------|------|----------|
| Export MeshNetworkManager in package root | build fix | HIGH |
| Implement minimal KEM encrypt/decrypt stub | crypto | HIGH |
| Add mesh metrics Prometheus exporter | observability | MEDIUM |
| Create recovery loop skeleton | resilience | HIGH |
| Add integration doc for Onion/Tor layer | documentation | MEDIUM |

## 11. References & Cross-Links
- `ARCH_INDEX.md` (global classification)
- `MTLS_REMEDIATION.md`, `SECURITY_ZERO_TRUST.md`
- `pqc_adapter.py` (PQC strategy)
- `benchmarks/phi_qaoa/*` (future quantum routing optimization claims)

## 12. Questions
- Where is source of OnionMeshNode? (need import path)
- Path scoring formula? (latency + loss + capacity?)
- GNN architecture planned? (GraphSAGE vs GAT?)
- Multi-domain trust segmentation required?

---
*File: MESH_CORE.md*
