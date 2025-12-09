# CODE_REVIEW_REMEDIATION — План исправления (x0tta6bl4)

## 1. Цель
Устранить критические и высокоприоритетные проблемы, выявленные в CODE_REVIEW_CRITICAL_MODULES.md, за 4 недели.

## 2. Классификация проблем
| ID | Модуль | Тип | Приоритет | Описание |
|----|--------|-----|-----------|----------|
| P0-1 | pqc_adapter.py | Security | CRITICAL | Отсутствует реализация Kyber/Dilithium |
| P0-2 | mesh_network_manager.py | Concurrency | HIGH | Race condition в stats |
| P0-3 | pathfinder/k_disjoint_spf | Architecture | CRITICAL | Дублирование и неоптимальный алгоритм |
| P1-1 | policy_engine.py | Feature | HIGH | Игнорируются conditions |
| P1-2 | mesh_network_manager.py | Reliability | HIGH | Нет graceful degradation при partial failure |
| P2-1 | k_disjoint_spf.py | Performance | MEDIUM | Composite weight без нормализации |
| P2-2 | pathfinder.py | Validation | MEDIUM | Нет проверки существования узлов |
| P3-1 | policy_engine.py | Ergonomics | LOW | Нет glob/regex matching |

## 3. Последовательность выполнения
| Фаза | Недели | Содержание |
|------|--------|-----------|
| Phase 1 | 1 | Реализация P0-1, P0-2, частично P1-1 |
| Phase 2 | 2 | Унификация pathfinder + k_disjoint (P0-3), завершение P1-1 |
| Phase 3 | 3 | Оптимизация весов, добавление graceful degradation (P1-2, P2-1) |
| Phase 4 | 4 | Валидации, glob matching, тестовое покрытие >85% |

## 4. Детали задач
### P0-1: PQC реализация
- Kyber KEM: encapsulate/decapsulate
- Dilithium: sign/verify
- Hybrid: комбинированная подпись
- Тесты: верификация корректности round-trip

### P0-2: Race condition
- Ввести `asyncio.Lock()` для stats обновлений
- Добавить atomic helper `increment_stat(name: str)`

### P0-3: Унификация pathfinding
- Выбрать k_disjoint_spf как основу
- Перенести отсутствующие фичи из pathfinder (hash топологии)
- Реализовать Suurballe или Bhandari algorithm

### P1-1: Conditions в policy_engine
- Поддержка: time_range, risk_score, ip_cidr
- Формат YAML:
```yaml
rules:
  - id: deny_high_risk
    effect: deny
    subject: "serviceA"
    action: "WRITE"
    resource: "db.cluster"
    conditions:
      - type: risk_score
        max: 0.4
```

### P1-2: Graceful degradation
- Протокол падает → лог + метрика + продолжение работы
- Минимум один протокол должен работать → иначе escalate

## 5. Метрики успеха
| Метрика | Цель |
|---------|------|
| Test Coverage | >85% |
| PQC Round-Trip Success | 100% |
| Policy Condition Accuracy | >98% |
| Path Redundancy (k>=3) | >=95% случаев для доступных топологий |
| Race Condition Incidents | 0 |

## 6. Риски
| Риск | Митигирование |
|------|---------------|
| Задержка PQC из-за liboqs | Фоллбек с mock-имплементацией |
| Сложность Suurballe impl | Альтернатива: Bhandari algorithm |
| Увеличение latency | Benchmark + оптимизация composite weight |

## 7. Тестовый план
| Тип | Инструмент | Цель |
|-----|-----------|------|
| Unit | pytest | Логика pathfinding, policy conditions |
| Integration | сценарии | PQC + mTLS handshake |
| Performance | custom harness | k-disjoint на графах 100/500/1000 узлов |
| Security | fuzz + статический анализ | Policy bypass попытки |

## 8. Следующие шаги
- Создать issues в трекере (P0-1 .. P3-1)
- Назначить ответственных
- Запустить Phase 1 (Неделя 1)

---
*Версия: 1.0 — 3 ноября 2025*

## 9. Статус обновлений (Conditions реализованы)
Дата: 3 ноября 2025

Изменения:
- Реализована поддержка условий в `policy_engine.py`: `risk_score` (операторы <, <=, >, >=, ==), `time between HH:MM-HH:MM` (UTC), `ip_cidr`.
- Добавлен fail-closed подход: любые неизвестные/raw условия блокируют правило.
- Добавлена нормализация и типизация (`TypedDict`: Policy, Rule, Condition) для устранения ошибок статического анализа.
- Порядок правил теперь строго соответствует порядку в YAML (раньше приоритет DENY мог перекрывать более специфичный ALLOW).
- CLI поддерживает флаги `--risk <float>` и `--ip <address>`.

Примеры:
```yaml
rules:
  - id: allow_internal_business_hours
    effect: ALLOW
    subject: serviceA
    action: READ
    resource: data.bucket.primary
    conditions:
      - risk_score < 55
      - time between 09:00-18:00
      - ip_cidr 10.10.0.0/16
```

Метрики для отслеживания:
| Метрика | Текущее | Цель |
|---------|---------|------|
| Policy Condition Accuracy | (ручные проверки) | >98% |
| Rule Order Determinism | 100% (тестировано) | 100% |

План тестов (добавить):
- Unit: случаи граничных временных интервалов (overnight 23:00-02:00)
- Unit: CIDR edge (/32, /24, неправильный ввод)
- Unit: Несколько условий (отрицание по одному)
- Negative: raw условие → правило не применяется

Follow-up (запланировать в Phase 2):
- Расширить синтаксис: группы OR, выражения с AND/OR в одной строке
- Поддержка тестового инъектирования времени через CLI (`--now HH:MM`) для детерминированных тестов
- Добавить кеширование нормализованных правил (при больших политиках)

Версия секции: 1.1 — 3 ноября 2025
