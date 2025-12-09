# ISSUE: P1 Policy Condition Tests & Edge Cases

ID: P1-1 (Follow-up)
Priority: HIGH
Status: OPEN
Owner: Security QA Engineer
Estimate: 8-12h

## Problem
Реализация условий (risk_score, time_range, ip_cidr) завершена, но отсутствует формализованный набор unit/integration тестов.

## Goal
Гарантировать детерминированную корректность и покрытие всех ветвей условной логики.

## Acceptance Criteria
| Criterion | Target |
|-----------|--------|
| Branch coverage (module) | >=95% |
| Edge cases covered | 100% перечисленных |
| Overnight interval correctness | 100% |
| CIDR parsing failures | Graceful (rule unsatisfied) |

## Test Cases
1. RiskScoreBelowThreshold → ALLOW.
2. RiskScoreAtThreshold → DENY (граничный оператор >=).
3. MultipleConditionsOneFails → DENY.
4. TimeRangeInside → ALLOW.
5. TimeRangeOutside → DENY.
6. TimeRangeOvernightInside (23:30-02:30) → ALLOW.
7. TimeRangeOvernightOutside → DENY.
8. IPCidrMatch → ALLOW.
9. IPCidrNoMatch → DENY.
10. IPCidrMalformed (`ip_cidr 10.10.0.0/XYZ`) → DENY (fail-closed).
11. RawConditionFallback → DENY.
12. OrderRespect (ALLOW before DENY) → Correct evaluation.

## Additional Infrastructure
- Добавить параметр `--now HH:MM` в CLI для детерминированных тестов.
- Fixtures: mock времени, mock IP.

## Steps
1. Расширить CLI (параметр now).
2. Написать unit-тесты (`tests/test_policy_engine_conditions.py`).
3. Добавить integration сценарий с YAML advanced_conditions.
4. Генерировать coverage report.
5. Обновить `CODE_REVIEW_REMEDIATION.md` метрикой выполнения.

## Risks
| Risk | Mitigation |
|------|------------|
| Нестабильные тесты по времени | CLI override + mocks |
| Сложность overnight логики | Дополнительные unit примеры |

---
Generated 2025-11-03.