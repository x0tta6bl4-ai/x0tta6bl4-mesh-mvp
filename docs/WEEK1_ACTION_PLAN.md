# WEEK 1 ACTION PLAN (2025-11-04 → 2025-11-10)

## Summary
IP Path: C (Balanced)  |  Code Priority: Parallel (Option 3)  |  Budget: $8K external + ~220h internal
Objective: Завершить mock PQC адаптер, исправить гонку в stats, расширить тесты policy conditions, подтвердить статус φ-QAOA, удалить RSA-4096 claims.

## Daily Breakdown
| Day | Team | Primary Task | Est. Hours | Deliverable |
|-----|------|--------------|------------|-------------|
| Mon | All | Kickoff + env setup | 4 | Team alignment notes |
| Mon-Tue | Quantum | PQC mock skeleton | 8-12 | `pqc_adapter_mock.py` + tests |
| Mon-Tue | Backend | Race condition fix | 4-6 | Lock patch + stress test |
| Mon-Tue | Security | Policy tests expansion | 6-8 | `--now` added + extended tests |
| Tue-Wed | IP | FTO search start | 8-10 | 5+ prior art refs update |
| Wed-Thu | Quantum | QAOA baseline env | 8-10 | Baseline harness initialized |
| Thu | All | Mid-week status review | 2 | Interim report |
| Fri | All | Buffer + fixes + planning | 4 | Week1 completion report |

Total: ~52-60h.

## Tasks Detail
### 1. PQC Adapter Mock (Kyber/Dilithium)
- File: `security/pqc/pqc_adapter_mock.py`
- Classes: `KeyPair`, `MockKyberKEM`, `MockDilithiumSig`, `PQCAdapter`
- Tests: `tests/test_pqc_adapter_mock.py` (key sizes, encap/decap deterministic, sign/verify)
- Deterministic KEM: ciphertext embeds shared secret tail; decap extracts last 32 bytes.

### 2. Race Condition Fix
- File: `mesh_network_manager.py`
- Add: `self._stats_lock = asyncio.Lock()`
- Methods: `update_stats`, `get_stats`, `clear_stats`, `add_error`
- Stress test: 1000 concurrent updates → no lost increments.

### 3. Policy Engine Extended Tests
- Add CLI flag `--now HH:MM` for time override.
- Extended tests: overnight interval, malformed CIDR, raw condition fail-closed.

### 4. φ-QAOA Status Verification
- Document: `docs/QAOA_STATUS_2025-11-04.md`
- Status categories: CONFIRMED | NOT FOUND | ROADMAP
- Evidence: filing receipt / internal reference / decision log.

### 5. Remove RSA-4096 Claims (CRITICAL)
- Search patterns: `RSA-4096`, `RSA4096`, `RSA 4096`, `4096.*RSA`, `factorization`.
- Replace claim with neutral phrasing: “optimizes combinatorial optimization problems”.

## Metrics
| Metric | Target |
|--------|--------|
| PQC mock tests pass | 100% |
| Race condition lost updates | 0 |
| Policy engine branch coverage | ≥95% |
| RSA claims remaining | 0 |
| φ-QAOA status decided | Tue EOD |

## Risks & Mitigation
| Risk | Mitigation |
|------|------------|
| Delay liboqs | Mock + abstraction layer |
| Flaky time tests | CLI override + fixed HH:MM |
| Unclear φ-QAOA evidence | Escalate to DAO decision (reclassify) |

## End-of-Week Deliverables
- `pqc_adapter_mock.py` + tests
- `mesh_network_manager` lock patch + stress test file
- `policy_engine.py` updated CLI + extended tests
- `QAOA_STATUS_2025-11-04.md` decision
- Week1 completion report + metrics snapshot

## Communication Cadence
- Daily async standup (09:00 UTC) — progress & blockers
- Mid-week review (Thu 15:00 UTC)
- Friday summary & Week2 planning

## Owners (To Assign)
| Task | Owner (Name) |
|------|--------------|
| PQC Mock | TBD |
| Race Fix | TBD |
| Policy Tests | TBD |
| φ-QAOA Status | TBD |
| RSA Removal | TBD |

## Immediate Next Steps (Mon Morning)
1. Confirm owners → update table.
2. Create branches: `feat/pqc-mock`, `fix/mesh-stats-lock`, `test/policy-conditions`.
3. Run baseline grep for RSA claims (archive results).
4. Start PQC mock coding (interface + deterministic shared secret).

---
Generated automatically on 2025-11-03.
