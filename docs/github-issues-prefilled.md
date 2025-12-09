# Pre-filled GitHub Issues — Reality Map Actions
**How to use:** Copy each section below and paste into a new GitHub Issue.

---
## Issue A1: Complete GraphSAGE Causal Analysis Implementation

**Labels:** `reality-map`, `priority:critical`, `component:gnn-routing`

### Action ID
A1

### Component
GNN Routing / Predictive Healing

### Goal
Implement causal GraphSAGE module to enable predictive healing, reduce MTTR from estimated 5–10s to target <3s, and achieve accuracy baseline ≥85%.

### Success Criteria
- MTTR test scenario averages <3s (measured via `benchmarks/mttr_simulation.py`)
- Accuracy baseline published (dataset + evaluation script)
- Module added: `mesh_networking/graphsage_causal.py` or integrated into existing optimizer
- Unit tests pass: `tests/test_graphsage_causal.py`
- Documentation updated: architecture diagram + API reference

### Scope
**Inclusions:**
- Causal feature graph schema design
- Forward pass implementation with attention-weighted edge aggregation
- Integration with telemetry feature extraction pipeline
- Evaluation harness with synthetic + real telemetry data

**Exclusions:**
- Federated learning integration (deferred to B2)
- Real-time streaming inference (Phase 2)

### Implementation Steps
1. Design causal feature graph schema (node = mesh device, edge = routing path + latency/loss metrics)
2. Implement GraphSAGE forward pass with attention mechanism for edge weighting
3. Add inference path: telemetry → feature extraction → GraphSAGE prediction → routing decision
4. Create evaluation script: `benchmarks/gnn_accuracy.py` with baseline dataset
5. Add unit + integration tests
6. Update `docs/architecture/gnn-routing.md` with design rationale

### Dependencies / Blockers
- Telemetry feature extraction pipeline must be stable (check `mesh_networking/telemetry/`)
- Dataset v2 preparation (100+ node failure scenarios; coordinate with Data Eng)
- PyTorch Geometric or DGL library decision

### Risk Assessment
| Risk | Impact | Mitigation |
|------|--------|------------|
| Data sparsity reducing accuracy | High | Use synthetic augmentation + transfer learning from similar topology datasets |
| Integration complexity with existing mesh router | Medium | Feature flag `USE_GNN_ROUTING=1` for gradual rollout |
| Performance overhead in inference | Medium | Profile with `cProfile`; optimize batch inference if needed |

### Owner & Support Roles
- **Primary Owner:** @ml-lead
- **Supporting:** @mesh-maintainer, @data-engineer, @performance-lead

### Timeline
- **Start:** 2025-11-10
- **Target Completion:** 2025-12-08 (4 weeks)
- **Review Window:** 2025-12-09–2025-12-11

### Deliverables Checklist
- [ ] Code merged into main branch
- [ ] Tests passing (unit: `test_graphsage_causal.py`, integration: `test_mesh_routing_with_gnn.py`)
- [ ] Benchmarks added: `benchmarks/mttr_simulation.py`, `benchmarks/gnn_accuracy.py`
- [ ] Docs updated: `docs/architecture/gnn-routing.md`, API reference
- [ ] Reality Map updated: Component #2 readiness → 60%+

### Verification Plan
**Script execution:**
```bash
python benchmarks/mttr_simulation.py --nodes 100 --fail-rate 0.15 --gnn-enabled
# Expected: MTTR mean <3s, P95 <5s

python benchmarks/gnn_accuracy.py --model graphsage_causal --dataset telemetry_v2
# Expected: Accuracy ≥85% on held-out test set
```

**Acceptance criteria:** Both scripts pass + CI green.

### Rollback / Fallback Plan
- Disable GraphSAGE via env var: `USE_GNN_ROUTING=0`
- Revert to baseline mesh routing (existing proven path)
- If accuracy <70% after 2 weeks, pivot to simpler heuristic-based model

### Post-Completion Notes
_(Fill after merge)_
- Dataset size used:
- Final accuracy achieved:
- MTTR improvement observed:
- Lessons learned:

---
## Issue A3: Implement Differential Privacy Noise Injector

**Labels:** `reality-map`, `priority:critical`, `component:privacy`

### Action ID
A3

### Component
Privacy / Differential Privacy

### Goal
Implement differential privacy (DP) noise injection module to protect telemetry and gradient data from privacy leakage, achieving measurable ε-privacy guarantee.

### Success Criteria
- Noise injector module: `privacy/dp_noise.py` with Laplace and Gaussian mechanisms
- Privacy leakage test: `tests/test_dp_leakage.py` validates ε < 1.0 for telemetry aggregation
- Integration with telemetry pipeline: noised metrics published instead of raw values
- Documentation: DP parameter tuning guide + privacy budget tracking

### Scope
**Inclusions:**
- Laplace mechanism (for count/sum queries)
- Gaussian mechanism (for gradient aggregation in future FL work)
- Privacy budget tracker (ε accumulation across queries)
- Sensitivity analysis helper functions

**Exclusions:**
- Homomorphic encryption (separate action, C-level priority)
- Advanced composition theorems (Phase 2)

### Implementation Steps
1. Create `privacy/dp_noise.py` with `add_laplace_noise()` and `add_gaussian_noise()` functions
2. Implement privacy budget tracker: `PrivacyBudgetTracker` class
3. Integrate with telemetry aggregation: wrap metric publish calls
4. Add sensitivity analysis: `calculate_sensitivity()` for common query types
5. Create validation test: simulate adversarial reconstruction attack, verify ε bound
6. Document parameter selection guide: ε, δ, sensitivity for different use cases

### Dependencies / Blockers
- Telemetry aggregation points identified (coordinate with Observability Lead)
- Privacy policy review (legal/compliance sign-off on ε=1.0 threshold)

### Risk Assessment
| Risk | Impact | Mitigation |
|------|--------|------------|
| Noise too high → utility loss | Medium | Adaptive ε tuning based on query importance |
| Noise too low → privacy breach | High | Conservative default ε=0.5, require explicit override |
| Privacy budget exhaustion | Medium | Implement budget reset schedule (daily/weekly) |

### Owner & Support Roles
- **Primary Owner:** @privacy-lead
- **Supporting:** @data-engineer, @security-lead, @compliance

### Timeline
- **Start:** 2025-11-10
- **Target Completion:** 2025-12-08 (4 weeks)
- **Review Window:** 2025-12-09–2025-12-11

### Deliverables Checklist
- [ ] Module code: `privacy/dp_noise.py`
- [ ] Tests: `tests/test_dp_leakage.py`, `tests/test_privacy_budget.py`
- [ ] Integration: Telemetry publish calls wrapped with DP
- [ ] Docs: `docs/privacy/differential-privacy.md`, parameter selection guide
- [ ] Reality Map updated: Component #9 readiness → 60%+

### Verification Plan
**Script execution:**
```bash
python tests/test_dp_leakage.py --epsilon 1.0 --delta 1e-5 --n-queries 100
# Expected: Measured ε_empirical ≤ 1.1 (with composition)

python examples/telemetry_dp_demo.py --publish-interval 10s
# Expected: Published metrics have added noise; original values not recoverable
```

### Rollback / Fallback Plan
- Feature flag: `ENABLE_DP=0` to publish raw metrics (development only)
- If privacy budget exhausted, queue metrics until reset
- Fallback to aggregation-only (no DP) with warning logs

### Post-Completion Notes
_(Fill after merge)_
- ε value chosen:
- Utility impact measured:
- Privacy guarantee validated:
- Lessons learned:

---
## Issue A4: Replace PQC Mocks with Real Primitives

**Labels:** `reality-map`, `priority:critical`, `component:pqc-crypto`

### Action ID
A4

### Component
Post-Quantum Cryptography (PQC)

### Goal
Replace mock/stub PQC implementations with real cryptographic primitives (Kyber, Dilithium, Falcon) using `liboqs` or equivalent, enabling production-ready quantum-resistant security.

### Success Criteria
- Real key generation, signing, verification for Kyber-768, Dilithium-3, Falcon-512
- Integration tests pass: `tests/test_pqc_mesh_integration.py` (no mocks)
- Performance benchmark: key gen + sign/verify <5ms P95 latency
- Documentation: algorithm selection rationale + API usage guide
- **OR** if real implementation deferred: Mark component as "Experimental PoC" in all docs

### Scope
**Inclusions:**
- Integrate `liboqs-python` or `pqcrypto` library
- Replace mock functions in `crypto/pqc.py`
- Update mesh handshake to use real Kyber key exchange
- Update signature verification in policy enforcement

**Exclusions:**
- Hybrid classical+PQ schemes (Phase 2)
- Custom PQC implementation (use vetted libraries only)

### Implementation Steps
1. **Decision point:** liboqs-python vs. pqcrypto vs. mark as PoC
2. If proceeding: Install and test `liboqs-python` in CI environment
3. Replace mock key generation: `generate_kyber_keypair()`, `generate_dilithium_keypair()`
4. Replace mock signing: `dilithium_sign()`, `falcon_sign()`
5. Update mesh handshake integration: real key exchange in `mesh_networking/handshake.py`
6. Benchmark performance: add `benchmarks/pqc_performance.py`
7. Update docs: mark status, add security considerations

### Dependencies / Blockers
- `liboqs` library stability on target platforms (Linux, macOS)
- CI build environment support for compiled crypto libraries
- Legal/compliance review of algorithm choices (especially export restrictions)

### Risk Assessment
| Risk | Impact | Mitigation |
|------|--------|------------|
| liboqs build failures on CI | High | Pin specific commit, add fallback to PoC mode |
| Performance regression (latency >10ms) | Medium | Profile and optimize; consider algorithm downgrade (e.g., Kyber-512) |
| Algorithm deprecation (NIST updates) | Low | Monitor NIST announcements; design for swappable primitives |

### Owner & Support Roles
- **Primary Owner:** @crypto-lead
- **Supporting:** @devsecops, @mesh-maintainer, @external-auditor (Phase 2)

### Timeline
- **Start:** 2025-11-10
- **Target Completion:** 2025-12-01 (3 weeks)
- **Review Window:** 2025-12-02–2025-12-04
- **Decision Deadline:** 2025-11-13 (implement real vs. mark PoC)

### Deliverables Checklist
- [ ] Decision documented: Implement real primitives OR mark PoC
- [ ] If real: Code merged with `liboqs-python` integration
- [ ] If real: Tests passing without mocks
- [ ] If real: Benchmarks added: `benchmarks/pqc_performance.py`
- [ ] If PoC: All docs updated with "Experimental - Not for Production" warnings
- [ ] Reality Map updated: Component #5 readiness → 75% (real) or 40% (PoC marked)

### Verification Plan
**If real implementation:**
```bash
python benchmarks/pqc_performance.py --algorithm kyber768 --iterations 1000
# Expected: P95 latency <5ms for keygen+encaps+decaps

python tests/test_pqc_mesh_integration.py --no-mocks
# Expected: All tests pass with real crypto operations
```

**If PoC marked:**
- Verify warning logs appear in mesh handshake: "Using experimental PQC - not production-ready"
- Update `README.md`, `docs/security.md` with PoC disclaimer

### Rollback / Fallback Plan
- Feature flag: `USE_REAL_PQC=0` to revert to mocks (testing only)
- If real implementation unstable, revert to classical crypto with roadmap update
- Graceful degradation: handshake falls back to ECDH if PQC unavailable

### Post-Completion Notes
_(Fill after merge)_
- Library chosen:
- Algorithms deployed:
- Performance measured:
- Production readiness status:
- Lessons learned:

---
## Issue B1: Implement eBPF Observability Probes

**Labels:** `reality-map`, `priority:high`, `component:observability`

### Action ID
B1

### Component
eBPF Observability / Low-Level Telemetry

### Goal
Implement 2+ eBPF programs to collect kernel-level telemetry (packet loss, syscall latency) with <5% CPU overhead, enabling the "near-zero overhead observability" claim.

### Success Criteria
- eBPF program #1: Packet loss detection (XDP or tc hook)
- eBPF program #2: Syscall latency tracing (kprobe on `do_syscall_64`)
- CI benchmark: overhead measurement <5% CPU under load
- Integration: Telemetry exported to Prometheus or JSON
- Documentation: eBPF architecture + debugging guide

### Scope
**Inclusions:**
- BPF C programs or bpftrace scripts
- Userspace loader (Python bcc/bpftrace wrapper)
- Telemetry export pipeline
- Performance overhead measurement

**Exclusions:**
- Advanced packet filtering (Phase 2)
- Per-process memory profiling (Phase 2)

### Implementation Steps
1. Choose toolchain: bcc vs. libbpf vs. bpftrace
2. Implement packet loss probe: XDP program tracking dropped packets
3. Implement syscall latency probe: kprobe histogram for `do_syscall_64`
4. Create loader: `observability/ebpf/loader.py`
5. Add telemetry export: write to `/var/run/ebpf_metrics.json` or Prometheus endpoint
6. Benchmark overhead: `benchmarks/ebpf_overhead.sh`
7. Document architecture: `docs/observability/ebpf.md`

### Dependencies / Blockers
- Linux kernel ≥5.10 (BTF support recommended)
- bcc or libbpf installed on target systems
- Root/CAP_BPF privileges for probe loading

### Risk Assessment
| Risk | Impact | Mitigation |
|------|--------|------------|
| Kernel compatibility issues | High | Test on Ubuntu 22.04, RHEL 9, kernel 5.15+ |
| Overhead >5% on high traffic | Medium | Optimize BPF map lookups, use per-CPU maps |
| Probe loading failures | Medium | Graceful fallback to userspace telemetry |

### Owner & Support Roles
- **Primary Owner:** @systems-engineer
- **Supporting:** @observability-lead, @kernel-specialist

### Timeline
- **Start:** 2025-12-15
- **Target Completion:** 2026-01-26 (6 weeks)
- **Review Window:** 2026-01-27–2026-01-29

### Deliverables Checklist
- [ ] BPF programs: `observability/ebpf/packet_loss.c`, `observability/ebpf/syscall_latency.bpf.c`
- [ ] Loader: `observability/ebpf/loader.py`
- [ ] Tests: `tests/test_ebpf_probes.py`
- [ ] Benchmark: `benchmarks/ebpf_overhead.sh` shows <5% CPU
- [ ] Docs: `docs/observability/ebpf.md`
- [ ] Reality Map updated: Component #3 readiness → 60%+

### Verification Plan
```bash
sudo python observability/ebpf/loader.py --enable packet_loss syscall_latency
# Load probes

sudo benchmarks/ebpf_overhead.sh --duration 60s --load high
# Expected: CPU overhead <5%, latency P99 delta <10%

cat /var/run/ebpf_metrics.json
# Expected: JSON with packet_loss_count, syscall_latency_p99
```

### Rollback / Fallback Plan
- Unload probes: `sudo python observability/ebpf/loader.py --disable all`
- Fallback to userspace packet capture (libpcap) if eBPF unavailable

### Post-Completion Notes
_(Fill after merge)_

---
## Issue B2: Implement Federated Learning Orchestrator

**Labels:** `reality-map`, `priority:high`, `component:federated-learning`

### Action ID
B2

### Component
Federated Learning / Distributed ML

### Goal
Implement FedAvg orchestrator to coordinate model updates across 10–50 nodes (synthetic test), achieving convergence with 85–88% accuracy target.

### Success Criteria
- Orchestrator service: `federated/orchestrator.py` with FedAvg aggregation
- Node worker: `federated/worker.py` for local training
- Convergence test: 10-node synthetic dataset reaches 85% accuracy in <20 rounds
- Communication overhead measured: <1MB per round per node
- Documentation: FL architecture + deployment guide

### Scope
**Inclusions:**
- FedAvg aggregation algorithm
- gRPC or HTTP API for model exchange
- Synthetic dataset for testing (MNIST or mesh telemetry simulation)

**Exclusions:**
- Byzantine-robust aggregation (Phase 2)
- Differential privacy integration (deferred to Phase 2)
- Production deployment on 1200+ nodes (Phase 3)

### Implementation Steps
1. Design FL protocol: round structure, model serialization, aggregation
2. Implement orchestrator: `federated/orchestrator.py` (FedAvg weighted averaging)
3. Implement worker: `federated/worker.py` (local SGD, model upload)
4. Create test harness: `tests/test_federated_convergence.py` with synthetic data
5. Benchmark communication: measure model size, transfer time
6. Document deployment: `docs/ml/federated-learning.md`

### Dependencies / Blockers
- Model serialization format (ONNX, TorchScript, or pickle)
- Network infrastructure for node communication (gRPC setup)

### Risk Assessment
| Risk | Impact | Mitigation |
|------|--------|------------|
| Convergence failure (<80% accuracy) | High | Tune learning rate, add momentum |
| Communication overhead >10MB/round | Medium | Model compression (quantization, pruning) |
| Node dropout handling | Medium | Implement timeout + partial aggregation |

### Owner & Support Roles
- **Primary Owner:** @ml-lead
- **Supporting:** @backend-engineer, @network-engineer

### Timeline
- **Start:** 2025-12-15
- **Target Completion:** 2026-02-09 (8 weeks)
- **Review Window:** 2026-02-10–2026-02-12

### Deliverables Checklist
- [ ] Orchestrator: `federated/orchestrator.py`
- [ ] Worker: `federated/worker.py`
- [ ] Test: `tests/test_federated_convergence.py` (10 nodes, 85% accuracy)
- [ ] Benchmark: communication overhead report
- [ ] Docs: `docs/ml/federated-learning.md`
- [ ] Reality Map updated: Component #11 readiness → 60%+

### Verification Plan
```bash
python tests/test_federated_convergence.py --nodes 10 --rounds 20 --dataset synthetic
# Expected: Final accuracy ≥85%, convergence by round 15–20

python benchmarks/fl_communication.py --nodes 10 --model-size auto
# Expected: Per-round transfer <1MB/node
```

### Rollback / Fallback Plan
- Disable FL: fall back to centralized training (development only)
- If convergence fails, reduce model complexity or increase data per node

### Post-Completion Notes
_(Fill after merge)_

---
## Issue B3: Implement Quadratic Voting Module

**Labels:** `reality-map`, `priority:high`, `component:dao-governance`

### Action ID
B3

### Component
DAO Governance / Quadratic Voting

### Goal
Implement quadratic voting tally calculation (weight = sqrt(token_amount)) for DAO proposals, enabling fairer governance weight distribution.

### Success Criteria
- Module: `governance/quadratic_voting.py` with `calculate_weighted_votes()` function
- Integration: DAO snapshot votes weighted via quadratic formula
- Test: `tests/test_quadratic_voting.py` validates edge cases (0 tokens, large balances)
- Documentation: Governance model explanation + examples

### Scope
**Inclusions:**
- Quadratic weighting formula: `vote_weight = sqrt(token_balance)`
- Integration with existing `eip712_snapshot.py`
- Edge case handling: zero balance, overflow protection

**Exclusions:**
- Delegation mechanisms (existing)
- Multi-choice voting (Phase 2)

### Implementation Steps
1. Create `governance/quadratic_voting.py` with weighting function
2. Integrate with `SnapshotManager`: modify vote tally calculation
3. Add unit tests: zero tokens, fractional tokens, large balances (overflow)
4. Document formula + rationale in `docs/governance/quadratic-voting.md`
5. Add example: compare linear vs. quadratic outcomes for sample proposal

### Dependencies / Blockers
- Snapshot vote storage schema (ensure compatibility)

### Risk Assessment
| Risk | Impact | Mitigation |
|------|--------|------------|
| Manipulation via token splitting | Medium | Add minimum balance threshold or Sybil resistance |
| Floating-point precision issues | Low | Use integer sqrt or fixed-point math |

### Owner & Support Roles
- **Primary Owner:** @dao-dev
- **Supporting:** @governance-analyst, @backend-dev

### Timeline
- **Start:** 2025-12-15
- **Target Completion:** 2026-01-12 (4 weeks)
- **Review Window:** 2026-01-13–2026-01-15

### Deliverables Checklist
- [ ] Module: `governance/quadratic_voting.py`
- [ ] Integration: Updated `eip712_snapshot.py` with quadratic mode
- [ ] Tests: `tests/test_quadratic_voting.py`
- [ ] Docs: `docs/governance/quadratic-voting.md`
- [ ] Reality Map updated: Component #8 readiness → 70%+

### Verification Plan
```bash
python tests/test_quadratic_voting.py
# Expected: All edge cases pass (0, 1, 1e18 tokens)

python examples/governance_comparison.py --proposal sample --mode linear quadratic
# Expected: Quadratic reduces concentration (top 10 voters <50% weight)
```

### Rollback / Fallback Plan
- Feature flag: `GOVERNANCE_MODE=linear` to disable quadratic
- If manipulation detected, revert to linear with investigation

### Post-Completion Notes
_(Fill after merge)_

---
## Issue B4: Verify HNSW Optimization in RAG

**Labels:** `reality-map`, `priority:high`, `component:rag-retrieval`

### Action ID
B4

### Component
RAG / Vector Index Optimization

### Goal
Verify HNSW (Hierarchical Navigable Small World) algorithm is used in RAG pipeline; if not, implement or document actual approach. Confirm 95% recall @ 15–20ms latency target.

### Success Criteria
- Verification: Code inspection confirms `hnswlib` or equivalent usage
- Benchmark: `benchmarks/rag_performance.py` shows 95% recall, <25ms P95 latency
- **OR** if not HNSW: Document actual algorithm (e.g., FAISS IVF) with performance
- Documentation: RAG architecture + index optimization guide

### Scope
**Inclusions:**
- Code audit of `rag_core_stable.py` and vector index instantiation
- Performance benchmark with standard dataset (10k+ vectors)
- Algorithm comparison if HNSW not present

**Exclusions:**
- Full index rebuild (use existing if functional)
- Advanced tuning (M, efConstruction parameters) deferred to Phase 2

### Implementation Steps
1. Audit `rag_core_stable.py`: search for `hnswlib`, `HNSW`, or vector index init
2. If HNSW present: Extract parameters (M, efConstruction, efSearch)
3. If HNSW absent: Identify actual algorithm (FAISS, Annoy, brute force)
4. Benchmark recall + latency: `benchmarks/rag_performance.py`
5. If performance < target: Recommend optimization or algorithm switch
6. Document findings: `docs/rag/index-optimization.md`

### Dependencies / Blockers
- Access to RAG test dataset (coordinate with Data Eng)
- Baseline query load profile

### Risk Assessment
| Risk | Impact | Mitigation |
|------|--------|------------|
| HNSW not present | Medium | Document actual algorithm; assess if acceptable |
| Performance below target | Medium | Tune parameters or switch to hnswlib |
| Index rebuild required | Low | Schedule during low-traffic window |

### Owner & Support Roles
- **Primary Owner:** @ml-lead
- **Supporting:** @retrieval-engineer, @performance-lead

### Timeline
- **Start:** 2025-12-15
- **Target Completion:** 2026-01-05 (3 weeks)
- **Review Window:** 2026-01-06–2026-01-08

### Deliverables Checklist
- [ ] Audit report: HNSW present/absent, actual algorithm documented
- [ ] Benchmark: `benchmarks/rag_performance.py` results published
- [ ] Recommendation: Keep as-is, tune, or migrate to HNSW
- [ ] Docs: `docs/rag/index-optimization.md`
- [ ] Reality Map updated: Component #7 readiness → 80%+ (if confirmed) or adjusted

### Verification Plan
```bash
python benchmarks/rag_performance.py --dataset standard_10k --queries 1000
# Expected: Recall@10 ≥95%, P95 latency <25ms

grep -r "hnswlib\|HNSW" rag_core_stable.py
# Expected: Positive match if HNSW used
```

### Rollback / Fallback Plan
- If migration to HNSW required but risky, keep current algorithm and update claims

### Post-Completion Notes
_(Fill after merge)_

---
## Issue B5: Implement Zero Trust End-to-End Policy Test

**Labels:** `reality-map`, `priority:high`, `component:zero-trust`

### Action ID
B5

### Component
Zero Trust / SPIFFE Policy Enforcement

### Goal
Create end-to-end test demonstrating SVID-based policy enforcement: authorized node routes successfully, unauthorized node is blocked.

### Success Criteria
- Test: `tests/test_zero_trust_e2e.py` passes
- Scenario: 2 SPIRE agents, 1 authorized SVID, 1 unauthorized; routing decision enforced
- Documentation: Zero Trust architecture + policy configuration guide

### Scope
**Inclusions:**
- SPIRE agent setup (test containers or local daemons)
- SVID issuance for test identities
- Mesh router integration: SVID verification before routing
- Rejection test: unauthorized node blocked with error log

**Exclusions:**
- Production SPIRE deployment (use test setup)
- Advanced policy rules (RBAC, attribute-based) deferred to Phase 2

### Implementation Steps
1. Create test harness: `tests/test_zero_trust_e2e.py`
2. Setup: Spawn 2 SPIRE agents with different trust domains or selectors
3. Issue SVIDs: authorized = `spiffe://x0tta6bl4/mesh/router-A`, unauthorized = `spiffe://untrusted/node`
4. Routing test: Authorized node forwards packet; unauthorized node rejected
5. Verify logs: "SVID verification failed" for unauthorized attempt
6. Document policy config: `docs/security/zero-trust-policies.md`

### Dependencies / Blockers
- SPIRE test setup (Docker Compose or systemd local)
- Mesh router code must check SVID before routing

### Risk Assessment
| Risk | Impact | Mitigation |
|------|--------|------------|
| SPIRE test flakiness | Medium | Increase timeout, add retry logic |
| Policy not enforced in code | High | Audit `mesh_router.py` for SVID check |

### Owner & Support Roles
- **Primary Owner:** @security-lead
- **Supporting:** @mesh-maintainer, @platform-engineer

### Timeline
- **Start:** 2025-12-15
- **Target Completion:** 2026-01-05 (3 weeks)
- **Review Window:** 2026-01-06–2026-01-08

### Deliverables Checklist
- [ ] Test: `tests/test_zero_trust_e2e.py`
- [ ] SPIRE test setup: Docker Compose or equivalent
- [ ] Mesh router: SVID verification integrated
- [ ] Docs: `docs/security/zero-trust-policies.md`
- [ ] Reality Map updated: Component #6 readiness → 70%+

### Verification Plan
```bash
python tests/test_zero_trust_e2e.py
# Expected: Authorized node succeeds, unauthorized node blocked

docker-compose -f tests/spire-test-setup.yml up
# SPIRE agents running, SVIDs issued
```

### Rollback / Fallback Plan
- Disable SVID enforcement via feature flag: `ENFORCE_ZERO_TRUST=0`

### Post-Completion Notes
_(Fill after merge)_

---
## Additional Issues (C1–C5) — Medium Priority

For brevity, C1–C5 (External Audit, Benchmarks, Sigstore, Accessibility CI, Monthly Updates) follow the same template structure. Key details:

**C1 — External Crypto Audit:**
- Owner: @crypto-lead
- Goal: Engage NCC Group or equivalent for PQC audit
- Timeline: 2–3 months post A4 completion

**C2 — Reproducible Performance Benchmarks:**
- Owner: @performance-lead
- Goal: `benchmark_models.py` + RESULTS.md with hardware specs
- Timeline: 2–3 weeks

**C3 — Sigstore/Cosign Artifact Signing:**
- Owner: @devops
- Goal: CI pipeline generates + verifies signed artifacts
- Timeline: 3–4 weeks

**C4 — Accessibility CI (axe/pa11y):**
- Owner: @ux-lead
- Goal: Automated WCAG scanning in CI, baseline ≥97% target
- Timeline: 4–6 weeks

**C5 — Monthly Reality Map Updates:**
- Owner: @tech-writer
- Goal: Ongoing monthly version bumps + changelog
- Timeline: Continuous (starting after A5 merge)

---
**Total Issues:** 13 (A1, A3–A5, B1–B5, C1–C5)

**Usage:** Copy each section above into a new GitHub Issue. Adjust owner handles and dates as needed.
