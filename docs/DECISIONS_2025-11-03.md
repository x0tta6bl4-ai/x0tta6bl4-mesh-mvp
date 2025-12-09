# Strategic Decisions (2025-11-03)

IP Path: C (Balanced)
Code Priority: 3 (Parallel Execution of PQC + Race Fix + Pathfinder Unification groundwork)
Ready to start Week 1: Yes
Approved external budget: $8K USD (plus internal ~220h)

## Rationale
- Path C даёт оптимальный баланс между затратами и опциональностью, не блокируя быструю PQC интеграцию.
- Параллельное выполнение (Priority 3) минимизирует критический путь: PQC и race fix можно завершить до начала глубокой унификации pathfinding.
- Бюджет $8K покрывает: патентный поверенный, ограниченный quantum консалтинг, подготовку FTO расширений.

## Allocation (High-Level)
| Stream | Internal Hours | External Cost | Output |
|--------|----------------|---------------|--------|
| PQC (Kyber/Dilithium) | 70h | $2K | Реализация + тесты |
| Race Condition Fix | 6h | $0 | Потокобезопасная статистика |
| Pathfinder Unification Spec | 24h | $0 | Технический RFC |
| IP: φ-QAOA Validation | 30h | $2.5K | Отчёт + решение по патенту |
| FTO & Policy Finalization | 40h | $2.5K | Матрица и обновлённая стратегия |
| Benchmarks Prep | 20h | $1K | Harness + методика |

## Immediate Actions
1. Создать GitHub issues (P0/P1).
2. Начать PQC adapter реализацию (skeleton → Kyber encapsulate/decapsulate stub).
3. Добавить `asyncio.Lock` в mesh_network_manager для stats.
4. Написать unit-тесты для policy conditions (overnight, CIDR /32, fail-closed).
5. Подтвердить статус φ-QAOA (документальное подтверждение или репозиционирование).

## Risks
| Risk | Mitigation |
|------|------------|
| Задержка PQC libs | Mock implementation + deferred optimization |
| Существенная сложность Suurballe | Альтернатива Bhandari algorithm |
| Недостаточные benchmark данные | Incremental harness + synthetic graphs |

## Checkpoints
- Week 1: PQC skeleton + race fix + φ-QAOA status
- Week 2: Kyber/Dilithium complete + pathfinder RFC
- Week 3: Unified pathfinding prototype + graceful degradation
- Week 4: Benchmarks + test coverage >85%

---
Generated 2025-11-03.