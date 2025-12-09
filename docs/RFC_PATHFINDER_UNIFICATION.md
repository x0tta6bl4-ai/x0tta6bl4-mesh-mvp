# RFC: Unified Pathfinder Architecture for Fault-Tolerant Mesh Routing

**Status**: Draft (Review Requested)  
**Author**: Mesh / Backend Team  
**Date**: 2025-11-05  
**Target Merge**: 2025-11-06  
**Version**: 0.1.0  

---
## 1. Abstract
We propose a unified Pathfinder subsystem that provides resilient, multi-factor route computation across heterogeneous mesh protocols (BATMAN-adv, CJDNS, AODV, k-disjoint SPF). The goal is to produce k fault-tolerant, quality-ranked paths with real‑time adaptability, integrating reliability, latency, bandwidth, capacity, and policy constraints. This RFC formalizes data models, algorithm selection (initially k‑disjoint SPF + alternative path fallback), scoring functions, extensibility points, and performance objectives.

---
## 2. Problem Statement
Current routing in the mesh relies on per‑protocol logic and ad-hoc aggregation in `MeshNetworkManager`. Limitations:
- No canonical abstraction for path quality vs. protocol metrics.
- Limited fault tolerance beyond basic re-discovery (no structured multi-path precomputation).
- No unified scoring layer tying capacity, latency, reliability, bandwidth, policy outcome.
- Lack of proactive alternative path caching for fast failover (<50ms target).
- Policy engine decisions (allow/deny) not currently able to prune candidate paths pre‑routing.

We need: deterministic, multi-path, multi-factor, policy-aware path computation with k disjoint routes + alternative fallback sets and structured metrics.

---
## 3. Goals & Non-Goals
### Goals
1. Produce up to k primary disjoint paths per (source, destination) with composite scoring.
2. Cache alternative paths avoiding failed nodes/edges (fast failover).
3. Provide extensible scoring weights (latency, reliability, capacity, bandwidth, policy).
4. Integrate policy constraints (deny certain resources, protocol use, or edges).
5. Expose unified API to other services: `get_paths(source, dest, k, constraints)`.
6. Support real-time refresh without destabilizing existing active routes.
7. Deliver instrumentation (Prometheus counters + structured events).

### Non-Goals (initial phase)
- Full ML-based path prediction (future Week 4+).
- Quantum optimization integration (φ-QAOA) – placeholder for Week 3 exploratory branch.
- IPv6 cryptographic addressing (handled by CJDNS separately).
- Persistent topology store (initial in-memory, later Redis/postgres).

---
## 4. Proposed Solution Overview
We standardize on a two-tier computation model:
1. Primary path selection using existing `KDisjointSPF` implementation (modified weighting hooks).
2. Alternative path enumeration (breadth-limited) for proactive failover using `find_alternative_paths()`.

Add a Pathfinder Orchestrator layer (`pathfinder.py` extension) responsible for:
- Normalizing protocol raw metrics → canonical Edge/Node attributes.
- Maintaining per-destination path caches with TTL + invalidation triggers.
- Integrating policy constraints before SPF expansion (filter out disallowed edges/nodes).
- Exposing `PathBundle` object containing: `[primary_paths[], alternative_paths[], meta]`.

---
## 5. Data Model
### Node Model (Canonical)
```
NodeInfo {
  node_id: str
  capacity: float (0.0-1.0)
  latency_ms: float
  reliability: float (0.0-1.0)
  is_gateway: bool
  bandwidth_mbps: int
  protocol_tags: List[str]
  updated_at: float (epoch)
}
```

### Edge Model (Canonical)
```
EdgeInfo {
  source: str
  target: str
  weight_base: float         # raw protocol weight
  capacity: float             # normalized shared capacity
  latency_ms: float
  reliability: float          # link reliability
  bandwidth_mbps: int
  policy_allowed: bool        # derived from policy engine
  updated_at: float
}
```

### Path Model (Abstract)
```
Path {
  nodes: List[str]
  total_weight: float
  composite_score: float      # lower better or convert to quality index
  capacity_min: float
  latency_sum_ms: float
  reliability_product: float
  bandwidth_min_mbps: int
  disjoint_group: int
  path_id: str
  created_at: datetime
}
```

### PathBundle
```
PathBundle {
  source: str
  destination: str
  primary: List[Path]          # up to k disjoint
  alternatives: List[Path]     # enumerated fallback
  generated_at: float
  stats: {...}
}
```

---
## 6. Algorithmic Flow
```mermaid
graph TD
A[Request: get_paths(s,d,k)] --> B[Load topology snapshot]
B --> C[Apply policy filters (edges/nodes)]
C --> D[Run KDisjointSPF.find_k_disjoint_paths]
D --> E[Score + annotate primary paths]
E --> F[Run alternative enumeration]
F --> G[Score + prune (max_paths)]
G --> H[Assemble PathBundle]
H --> I[Cache + return]
```

### Policy Filtering
Before SPF expansion, call policy engine with synthetic actions:
- `route_use:<protocol>`
- `edge_use:<source>:<target>`
- `node_use:<node_id>`
If DENY → exclude from graph copy.

### Scoring Function
Composite Edge Weight (already in `KDisjointSPF._calculate_edge_weight`):
```
W = base_weight
  + latency_factor * latency_ms
  + capacity_factor * (1/capacity)
  + reliability_factor * (1/reliability)
```
Path Composite Score proposal:
```
S = α * total_latency_ms
  + β * (1 / capacity_min)
  + γ * (1 / reliability_product)
  + δ * hop_count
  + ε * (1 / bandwidth_min_mbps)
```
Where weights (α..ε) configurable via environment or dynamic adaptation.

### Disjoint Verification
Edges of each selected path are marked using existing `_mark_edges_used`. Nodes overlap permitted only if edge disjointness satisfied (initial definition).

---
## 7. Implementation Plan
| Step | Action | Owner | ETA |
|------|--------|-------|-----|
| 1 | Extend `KDisjointSPF` with pluggable path scoring hook | Backend | Day 2 AM |
| 2 | Add policy pre-filter adapter in Pathfinder orchestrator | Security | Day 2 PM |
| 3 | Implement `PathBundle` and caching (TTL 30s) | Backend | Day 2 PM |
| 4 | Expose FastAPI endpoint `/mesh/paths?src=&dst=&k=` | Security | Day 3 AM |
| 5 | Add Prometheus metrics (paths_found, latency_ms) | Infra | Day 3 PM |
| 6 | Benchmark (synthetic 100 nodes / 500 edges) | Backend | Day 3 PM |
| 7 | Docs & review, finalize RFC | All | Day 3 EOD |

---
## 8. Performance Targets
| Metric | Target | Rationale |
|--------|--------|-----------|
| k=3 path calc latency | < 40 ms (100 node / 500 edge) | Real-time adaptation |
| Alternative enumeration | < 120 ms | Failover precomputation |
| Cache hit ratio | > 70% | Reduce recomputation |
| Memory footprint (path cache) | < 50 MB | Avoid pressure |
| Failover switch time | < 50 ms | SLA continuity |

Benchmark Harness (planned):
- Generate synthetic topology using scale factors.
- Vary reliability distribution + latency noise.
- Record median / p95 latencies for path resolution.

---
## 9. Observability & Metrics
Prometheus counters/gauges:
- `pathfinder_paths_found_total`
- `pathfinder_calculation_latency_ms` (histogram)
- `pathfinder_cache_hit_total`
- `pathfinder_policy_filtered_edges_total`

Structured log events (`structlog`):
- `pathfinder.compute.start` {source, destination, k}
- `pathfinder.compute.success` {count, latency_ms}
- `pathfinder.compute.failure` {error}
- `pathfinder.cache.hit` {source, destination}

---
## 10. Risks & Mitigations
| Risk | Impact | Mitigation |
|------|--------|-----------|
| Graph mutation race conditions | Inconsistent paths | Snapshot copy before compute |
| Policy latency inflation | Slower routing | Cache policy decision per edge for TTL |
| Large topology scaling (>5K nodes) | Performance degrade | Introduce partitioning / hierarchical routing |
| Reliability oscillation | Path churn | Add hysteresis threshold for recompute |
| Single scoring configuration inflexibility | Suboptimal routes | Dynamic weights from telemetry (Phase 2) |
| Memory leak in path cache | OOM risk | Size limit + LRU eviction |

---
## 11. Alternatives Considered
1. Pure NetworkX multi-path algorithms + post-filter: simpler but harder to inject composite scoring.
2. Suurballe/Yen's algorithm integration directly: deferred; current approach wraps custom weighting first.
3. On-demand only single-path resolution: insufficient for failover SLA.

---
## 12. Future Extensions
- Quantum-assisted optimization (φ-QAOA) for edge reliability projection.
- ML reliability predictor (time-series throughput anomaly detection).
- Multi-tenant policy layers (namespace isolation).
- Hybrid protocols dynamic preference (bandwidth vs. latency negotiation).

---
## 13. API Sketch (FastAPI)
```python
@app.get("/mesh/paths")
async def get_paths(source: str, destination: str, k: int = 3, user: str = Depends(get_current_user)):
    enforce_policy(user, "get_paths", f"{source}:{destination}")
    bundle = pathfinder.compute(source, destination, k)
    return bundle.dict()
```
Response (example):
```json
{
  "source": "n1",
  "destination": "n9",
  "generated_at": 1730795100.123,
  "primary": [
    {"nodes": ["n1","n3","n9"], "latency_sum_ms": 14.0, "reliability_product": 0.98},
    {"nodes": ["n1","n2","n5","n9"], "latency_sum_ms": 19.0, "reliability_product": 0.95}
  ],
  "alternatives": [
    {"nodes": ["n1","n4","n7","n9"], "latency_sum_ms": 28.0, "reliability_product": 0.93}
  ],
  "stats": {"calc_latency_ms": 27.4, "policy_filtered": 5}
}
```

---
## 14. Review Checklist
- [ ] Scoring weights acceptable? (α..ε defaults)
- [ ] Policy filtering semantics validated?
- [ ] Cache TTL and eviction strategy agreed?
- [ ] Metrics coverage complete?
- [ ] API contract stable?
- [ ] Benchmark methodology sound?

---
## 15. Timeline
| Date | Milestone |
|------|-----------|
| Nov 05 AM | Draft RFC (this document) |
| Nov 05 PM | Scoring hook + policy filter prototype |
| Nov 06 AM | Endpoint + metrics integration |
| Nov 06 PM | Benchmark run + adjustments |
| Nov 07 AM | Final review + merge |

---
## 16. Approval
| Role | Name | Status |
|------|------|--------|
| Backend Lead | TBD | Pending |
| Security Lead | TBD | Pending |
| Infra Lead | TBD | Pending |
| Quantum Lead | TBD | FYI |

---
## 17. Open Questions
1. Should reliability weighting be logarithmic for high values?  
2. Do we require explicit protocol preference override per request?  
3. What is acceptable path churn frequency threshold?  
4. How to unify per-protocol telemetry ingestion cadence?  
5. Minimum viable persistence layer (Redis vs memory) for Week 2?

---
## 18. Appendix
### References
- RFC 791 (IP) – layering implications for overlay routing.
- Suurballe's algorithm (1974) – disjoint shortest paths groundwork.
- Yen's algorithm – candidate path enumeration.
- NetworkX documentation – current graph primitives used.

### Glossary
- SPF: Shortest Path First
- K-Disjoint: Set of paths sharing no common edges (current definition)
- Path Bundle: Aggregated set of primary + alternative paths
- Policy Filtering: Pre-routing exclusion of disallowed graph components

---
**END OF RFC**
