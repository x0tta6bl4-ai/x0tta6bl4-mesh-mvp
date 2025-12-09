# TEAM KICKOFF SUMMARY (Week 1)

## Decisions
- IP Path: C (Balanced)
- Code Priority: Parallel (PQC + Race Fix + Pathfinder Spec)
- Budget Approved: $8K external + 220h internal
- Week 1 Start: Confirmed

## Roles
| Role | Owner | Focus Week 1 |
|------|-------|--------------|
| Quantum Lead | TBD | PQC mock + keypair logic |
| Backend Engineer | TBD | Race condition stats lock |
| Algorithms Engineer | TBD | Pathfinder diff & RFC draft |
| Security QA | TBD | Policy condition test harness |
| IP/Legal Liaison | TBD | φ-QAOA verification + RSA claim removal |
| DevOps | TBD | Benchmark harness skeleton |

## Week 1 Objectives
1. PQC Adapter mock implementation (Kyber/Dilithium skeleton)
2. Race condition fix and stress test (1000 parallel increments)
3. Pathfinder unification RFC (interface + algorithm choice)
4. Policy conditions test suite (overnight + malformed CIDR)
5. φ-QAOA verification evidence collected / decision path
6. Remove RSA-4096 claims from all public docs

## Metrics to Capture
- PQC: keypair latency / sizes
- Stats: lost update count (expect 0)
- Pathfinder: initial performance baseline on sample graph
- Policy: branch coverage %
- IP: prior art references count update

## Communication Cadence
- Daily 15m standup (UTC 09:00)
- Mid-week sync (Architecture + IP) Wed UTC 15:00
- End-of-week report (auto-generated) Fri UTC 17:00

## Risks Week 1
| Risk | Mitigation |
|------|------------|
| Delay in liboqs availability | Mock first, abstract interface |
| Test flakiness (time-based) | CLI time override + deterministic fixtures |
| Scope creep in pathfinding RFC | Hard limit: RFC v1 by Day 4 |

## Deliverables End of Week 1
- `pqc_adapter.py` mock operational
- `mesh_network_manager` stats lock merged
- `routing/unified_pathfinder_rfc.md` created
- `tests/test_policy_engine_conditions.py` passing with coverage report
- φ-QAOA decision (proceed or reframe) documented
- Updated IP portfolio sans RSA claims

---
Generated 2025-11-03.