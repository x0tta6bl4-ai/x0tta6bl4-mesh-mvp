# Top-3 Execution Plan (Week Focus)

## 1. mTLS Remediation
**Goal:** Устранить AppArmor denials / нестабильность каналов.
**Subtasks:**
- Инвентаризация текущих сертификатов (expiry, CN, SAN)
- Проверка AppArmor журналов → классификация типов отказов
- Коррекция policy (профили разрешений для процессов mesh)
- Автоматическая перезагрузка сервисов после ротации
- Smoke-test: взаимное установление TLS между 3 узлами
**Success Metric:** 100% успешных handshake без denials за 24ч.

## 2. Architecture Consolidation
**Goal:** Создать связную документацию ядра.
**Subtasks:**
- Заполнить `MESH_CORE.md` (модули, события, recovery loop)
- Создать диаграмму потоков (logical, failure propagation)
- Связать `ARCH_INDEX.md` с новыми файлами
- Отметить пробелы ("TODO") где требуется код
**Success Metric:** Архитектурные файлы покрывают ≥90% компонентов, один точный вход.

## 3. Zero Trust Integration Breakdown
**Goal:** Декомпозировать внедрение.
**Subtasks:**
- Определить точки идентификации (mTLS handshake, token issuance)
- Политический движок (rule format, evaluation order)
- Enforcement (sidecars / inline filters) список
- Логирование и аудит (формат, retention)
- План тестирования (positive/negative access cases)
**Success Metric:** Документированный pipeline + список реализуемых модулей (story map).

## Timeline (Indicative)
| Day | Focus |
|-----|-------|
| 1 | mTLS аудит + сбор логов |
| 2 | AppArmor policy + сертификаты |
| 3 | Architecture docs (MESH_CORE) |
| 4 | Диаграммы, связывание INDEX |
| 5 | Zero Trust decomposition |
| 6 | Draft tests (mTLS + Zero Trust) |
| 7 | Review & adjust backlog |

## Risks & Mitigation
| Risk | Impact | Mitigation |
|------|--------|-----------|
| Недостаток логов для mTLS | Задержка | Включить verbose logging временно |
| Архитектурные пробелы в коде | Неясность | Пометить TODO блоки + приоритизировать реализацию |
| Расширение Zero Trust scope | Растяжение сроков | Freeze на минимальный MVP first |

## Exit Criteria
- TOP3: все subtasks отмечены завершёнными
- Backlog остался неизменным (заморозка сохранена)
- Готов план на следующую неделю (Next-3)
