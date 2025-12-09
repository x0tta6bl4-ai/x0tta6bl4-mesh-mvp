# GitHub Issue Template — Reality Map Action

Use this template for actions A1–C5.

---
**Title Format:** `[A1] GraphSAGE causal analysis implementation` (Prefix with ID)

**Labels:** `reality-map`, `priority:critical|high|medium`, `component:<name>`

---
## 1. Action ID
A1 | A2 | A3 | A4 | A5 | B1 | B2 | B3 | B4 | B5 | C1 | C2 | C3 | C4 | C5

## 2. Component
(e.g., GNN routing, PQC crypto, Federated Learning, Zero Trust, Censorship, Privacy, Observability, Accessibility)

## 3. Goal (1–2 sentences)
Clear, measurable objective.

## 4. Success Criteria
- Metric-based outcome (e.g., MTTR < 3s)
- Code artifact(s) (files, tests, benchmarks)
- Documentation updates

## 5. Scope
Inclusions:
- 
Exclusions:
- 

## 6. Implementation Steps
1. 
2. 
3. 

## 7. Dependencies / Blockers
- Upstream modules, data availability, library choices.

## 8. Risk Assessment
| Risk | Impact | Mitigation |
|------|--------|------------|
| Example: liboqs build failure | Delays integration | Pin specific commit |

## 9. Owner & Support Roles
- Primary Owner: `@handle`
- Supporting: `@handle1`, `@handle2`

## 10. Timeline
- Start: YYYY-MM-DD
- Target Completion: YYYY-MM-DD
- Review Window: (e.g., +3 days post completion)

## 11. Deliverables Checklist
- [ ] Code merged
- [ ] Tests passing (unit/integration)
- [ ] Benchmarks added
- [ ] Docs updated
- [ ] Reality Map updated

## 12. Verification Plan
How will success be validated? (scripts, datasets, reproducibility steps)

## 13. Rollback / Fallback Plan
If implementation fails or regressions occur.

## 14. Post-Completion Notes
Lessons learned, follow-ups.

---
### Quick Copy Block
```
ID:
Component:
Goal:
Success Criteria:
Scope:
Implementation Steps:
Dependencies:
Risks:
Owner:
Timeline:
Deliverables:
Verification:
Rollback:
Notes:
```

---
### Example (A1 — GraphSAGE)
```
ID: A1
Component: GNN Routing
Goal: Implement causal GraphSAGE module to enable predictive healing and reduce MTTR.
Success Criteria:
- MTTR test scenario < 3s average
- Accuracy baseline published (dataset + script)
- Added module: `graphsage_causal.py`
Scope:
- Include inference path integration
- Exclude federated learning
Implementation Steps:
1. Design causal feature graph schema
2. Implement forward pass + attention edge weighting
3. Add evaluation harness `tests/test_graphsage_causal.py`
Dependencies:
- Telemetry feature extraction pipeline
Risks:
- Data sparsity reducing accuracy
Owner: @ml-lead
Timeline: Start 2025-11-10, Complete 2025-12-08
Deliverables:
- [ ] Module code
- [ ] Tests
- [ ] Benchmark script
Verification:
- Run `python benchmarks/mttr_simulation.py`
Rollback:
- Disable GraphSAGE path via feature flag `USE_GNN_ROUTING=0`
Notes:
- Need dataset v2 prepared.
```
