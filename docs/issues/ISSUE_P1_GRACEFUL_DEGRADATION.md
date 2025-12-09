# ISSUE: P1 Graceful Degradation for Mesh Protocol Failures

ID: P1-2
Priority: HIGH
Status: OPEN
Owner: Reliability Engineer
Estimate: 6-8h

## Problem
При падении одного из протоколов (BATMAN-adv, CJDNS, AODV) система может терять функциональность без fallback логики.

## Goal
Обеспечить работу при частичных отказах через деградацию: снижение уровня возможностей, логирование, метрики и автоматическое восстановление.

## Strategy
- Health check каждого протокола (interval: 5s)
- State machine: ACTIVE → DEGRADED → RECOVERY
- Fallback порядок: BATMAN-adv > AODV > статическая таблица
- Метрики: `mesh_protocol_status{protocol=}`

## Acceptance Criteria
| Criterion | Target |
|-----------|--------|
| Detection latency | <10s |
| False positives | <1% |
| Recovery attempt cycles | Max 3 before alert |

## Steps
1. Добавить health probes (ping соседу / контрольная операция).
2. Реализовать state machine класс `ProtocolSupervisor`.
3. Прописать fallback логику (снижение до доступной связности).
4. Логирование в audit/emitter.
5. Метрики (Prometheus format draft).

## Risks
| Risk | Mitigation |
|------|------------|
| Частые переключения | Гистерезис таймеры (min dwell time) |
| Неполные health сигналы | Мульти-проверка (ping + статистика потерь) |

## Test Plan
| Test | Description |
|------|-------------|
| SingleFailure | Один протокол падает → degrade |
| DualFailure | Два протокола падают → deeper degrade |
| RecoverySuccess | Протокол возвращается → ACTIVE |
| RecoveryFail | 3 неудачных попытки → alert |

---
Generated 2025-11-03.