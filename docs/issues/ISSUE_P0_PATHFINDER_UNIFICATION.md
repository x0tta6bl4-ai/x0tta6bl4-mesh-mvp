# ISSUE: P0 Pathfinder & KDisjointSPF Unification

ID: P0-3
Priority: CRITICAL
Status: OPEN
Owner: Network Algorithms Engineer
Estimate: 30-40h

## Problem
Дублированная логика маршрутизации в `pathfinder.py` и `k_disjoint_spf.py` приводит к расхождениям и усложняет сопровождение. Нет реализации классических алгоритмов многопутевой маршрутизации (Suurballe/Bhandari).

## Objective
Унифицировать код и реализовать надёжный алгоритм k-дизъюнктных путей с учётом весов и отказоустойчивости.

## Scope
- Создать модуль `routing/unified_pathfinder.py`.
- Реализовать k-дизъюнктные пути (Bhandari как MVP, Suurballe optional).
- Нормализация composite weight (latency, loss, jitter, capacity).
- Кеширование топологии (hash + invalidation при изменении).

## Acceptance Criteria
| Criterion | Target |
|-----------|--------|
| Correctness (disjoint) | k>=3 при доступности | 
| Performance (1000 nodes) | < 2s вычисление | 
| Code duplication removed | 100% удалены старые функции | 
| Test coverage | >=85% | 

## Steps
1. Анализ различий между pathfinder и k_disjoint_spf.
2. Спецификация интерфейса: `compute_paths(graph, src, dst, k)`.
3. Реализация Bhandari algorithm (использует повторные Dijkstra passes).
4. Добавление weight normalizer: `w = alpha*latency + beta*loss + gamma*jitter + delta*(1/capacity)`.
5. Тестирование на синтетических графах (генератор).
6. Инструментирование метрик (время, количество найденных путей).
7. Удаление legacy кода + миграция вызовов.

## Risks
| Risk | Mitigation |
|------|------------|
| Сложность Suurballe | Начать с Bhandari (проще) |
| Большие графы медленные | Предварительный pruning / caching |
| Неполные метрики | Заглушки для отсутствующих данных |

## Test Matrix
| Test | Description |
|------|-------------|
| SmallGraphK2 | correctness on 10 nodes |
| MediumGraphK3 | 100 nodes performance |
| LargeGraphK3 | 1000 nodes performance |
| NoDisjointFallback | graceful degrade (k<expected) |
| WeightNormalization | path ordering changes with weights |

## Timeline
Week 1: Interface + Bhandari + small tests
Week 2: Performance + caching + legacy removal

---
Generated 2025-11-03.