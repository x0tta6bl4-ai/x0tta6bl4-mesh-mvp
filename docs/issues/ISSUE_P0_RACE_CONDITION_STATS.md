# ISSUE: P0 Race Condition in MeshNetworkManager.stats

ID: P0-2
Priority: HIGH
Status: OPEN
Owner: Backend Engineer
Estimate: 4-6h

## Problem
Поле `stats` обновляется конкурентно без синхронизации (возможна потеря инкрементов).

## Goal
Гарантировать корректные атомарные обновления метрик в многопоточной/асинхронной среде.

## Proposed Fix
- Ввести `asyncio.Lock()` (или `threading.Lock()` если синхронный контекст) для операций записи.
- Добавить вспомогательную функцию `increment_stat(key: str, delta: int = 1)`.
- Обеспечить инициализацию всех ключей при старте.

## Acceptance Criteria
| Criterion | Target |
|-----------|--------|
| Lost updates | 0 в stress-тесте (1000 параллельных инкрементов) |
| Lock contention | <5% времени исполнения в тесте |
| Test coverage | >=85% для нового кода |

## Steps
1. Анализ текущей реализации stats.
2. Добавить lock и метод increment_stat.
3. Написать тест на конкурентное обновление (async gather 1000 tasks).
4. Добавить negative тест (отсутствующий ключ → автоинициализация).
5. Документировать поведение в `MESH_CORE.md`.

## Metrics
- Time per 1000 increments.
- Collision/lost update count.

## Risks
| Risk | Mitigation |
|------|------------|
| Производительность падает | Пакетные обновления через локальный буфер |
| Неправильное использование lock | Обёртка API скрывает детали |

## Timeline
Day 1: Реализация + тесты
Day 2: Оптимизация (при необходимости)

---
Generated 2025-11-03.