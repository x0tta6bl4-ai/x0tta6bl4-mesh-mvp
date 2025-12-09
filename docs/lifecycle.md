# Ежедневный цикл "Проснись–Обновись–Сохранись" (Lifecycle)

Цель: обеспечить предсказуемую когнитивно-техническую эволюцию системы x0tta6bl4 с минимальным MTTR, устойчивой адаптацией и прозрачной фиксацией прогресса.

## Обзор фаз
| Фаза | Назначение | Критические инварианты | Главные метрики |
|------|------------|-------------------------|------------------|
| Проснись (Awake) | Восстановить рабочий контекст и проверить целостность | Конфиг валиден, политика не повреждена, модель загружена | t_awake, health_pass_ratio |
| Обновись (Update) | Интегрировать новые события, применить политики, скорректировать модели | Политики применяются детерминированно, нет silent failure | events_processed, policy_match_rate, model_accuracy_delta |
| Сохранись (Persist) | Зафиксировать состояние и подготовить точки отката | Snapshot консистентен и проверяем | snapshot_time_ms, snapshot_size, integrity_hash_valid |

## 1. Фаза "Проснись" (Awake)
**Цель:** безопасная реконсолидация состояния перед активной работой.

**Шаги:**
1. Загрузка конфигураций: `config/*.yaml` → валидация схемы.
2. Загрузка активных политик: `policies_active.json` → структурная проверка.
3. Инициализация моделей: проверка версий, совместимость входов.
4. Проверка целостности предыдущего checkpoint (hash / signature).
5. Быстрый self-test (минимальный прогон диагностических условий DSL).

**Метрики:**
- `lifecycle_awake_duration_ms`
- `lifecycle_awake_integrity_failures_total`
- `lifecycle_awake_policy_load_errors`
- `lifecycle_awake_model_version_mismatch`

**Артефакты:**
- `logs/awake/health_check.log`
- `state/last_checkpoint.meta.json`
- `reports/awake_integrity.json`

**Триггеры остановки:**
- Ошибка целостности snapshot → мягкий degrade режим (только чтение).
- Несовместимость модели → fallback на предыдущую версию.

## 2. Фаза "Обновись" (Update)
**Цель:** адаптация к новым данным, регулировка поведения через политики.

**Шаги:**
1. Ингест событий за интервал: сетевые, аномалии, логические.
2. Прогон через PolicyEngine (безопасный DSL + fallback Jinja2 если предусмотрено).
3. Обновление внутренних счётчиков и агрегатов (rolling windows).
4. Переоценка дрейфа модели (baseline vs текущие показатели).
5. Частичная переобучающая сессия (если дрейф > порога).
6. Обогащение RAG базы промахами поиска (miss queue).

**Метрики:**
- `events_processed_total`
- `policy_matched_ratio`
- `model_drift_score`
- `rag_miss_queue_length`
- `adaptive_retrain_duration_ms`

**Артефакты:**
- `logs/update/events_batch.log`
- `models/model_updates.pkl`
- `policies/policy_effects.json`
- `rag/miss_events.jsonl`

**Триггеры:**
- `model_drift_score > threshold` → запускается частичный retrain.
- `policy_matched_ratio < min_expected` → аудит логики условий.

**Инварианты:**
- Каждый эффект политики логируется (нет silent apply).
- Обновление модели не уничтожает предыдущую (версирование).

## 3. Фаза "Сохранись" (Persist)
**Цель:** атомарное зафиксированное состояние с проверяемыми хэшами и журналом изменений.

**Шаги:**
1. Формирование snapshot каталога: `checkpoint/<timestamp>/`.
2. Сериализация: политики, состояние счетчиков, параметры модели.
3. Генерация манифеста: `checkpoint_manifest.json` (размеры, хэши, версии).
4. Подпись (если включено): `checkpoint.sig` (постквантовый план — интеграция Kyber/Dilithium).
5. Тест верификации: чтение snapshot → сверка хэшей.
6. Архивирование устаревших snapshot (> N дней) → `archive/YYYY-MM-DD/`.

**Метрики:**
- `snapshot_generation_duration_ms`
- `snapshot_integrity_verification_failures`
- `snapshot_compressed_size_bytes`

**Артефакты:**
- `checkpoint/<timestamp>/state.json`
- `checkpoint/<timestamp>/policies.json`
- `checkpoint/<timestamp>/model.bin`
- `checkpoint/<timestamp>/checkpoint_manifest.json`
- `archive/<date>/...`

**Инварианты:**
- Manifest содержит: `version`, `hashes`, `created_at`, `policy_version_set`, `model_version`.
- Нельзя удалять последний успешный snapshot до создания нового.

## Диаграмма жизненного цикла (логическая)
```
[AWAKE] -> integrity_ok? -> [UPDATE] -> drift? -> retrain? -> [PERSIST] -> verify_ok? -> sleep
       | integrity_fail -> degrade_mode -> [PERSIST(partial)]
```

## Ежедневный график (рекомендация)
| Время | Действие | Формат |
|-------|----------|--------|
| 07:30 | Awake sequence | Автоматически (cron/k8s job) |
| 08:00 | Краткий отчёт состояния | `reports/daily_status.md` |
| 10:00 | Update цикл (батч событий) | Streaming/Batch |
| 13:00 | Drift scan + возможный retrain | Async task |
| 18:00 | Вторичный update (агрегация) | Batch |
| 21:30 | Persist snapshot | Cron |
| 22:00 | Проверка целостности + публикация состояния | `reports/integrity_postmortem.md` |

## Контракты фаз
### Awake Contract
- Входы: конфиги, предыдущий snapshot
- Выходы: активное состояние памяти (in-memory), лог проверки
- Ошибки: повреждение snapshot, несовместимость схемы

### Update Contract
- Входы: события, политики, текущая модель
- Выходы: обновленные счетчики, промахи, частично адаптированная модель
- Ошибки: модель не обучаема, ошибка политики, превышение задержки

### Persist Contract
- Входы: актуальное состояние памяти, политика, модель
- Выходы: файловый snapshot + manifest + подпись
- Ошибки: I/O сбой, несовпадение хэшей, недостаток дискового пространства

## Механизм версионирования (предзаготовка)
- `PolicyVersion`: { id, policy_id, version, created_at, hash, rollback_of }
- `ModelVersion`: { id, base_model_id, version, metrics, drift_score }
- Persist сохраняет связку PolicyVersionSet + ModelVersion.
- Откат: выбираем предыдущий manifest, проверяем целостность → активируем.

## Drift Detection (будущий модуль)
Идея: baseline метрик (latency, accuracy, anomaly_rate) → вычисление `drift_score = f(z-score, pct_change, entropy_delta)`.
Порог → событие `drift_detected` → retrain pipeline.

## Интеграция с RAG
- Update добавляет новые валидированные chunks.
- Persist фиксирует индекс состояния (vector store snapshot).
- Промахи (miss) помечаются для последующей приоритезации.

## Логирование
- Все фазы логируют старт/финиш + длительность.
- Ошибки → структурный JSON (поле `phase`: Awake/Update/Persist).

## Аномальные сценарии
| Сценарий | Реакция |
|----------|---------|
| Политики не валидны | Удаляем из активного набора, создаётся инцидент |
| Snapshot повреждён | Используем предыдущий, метрика `degrade_mode=1` |
| Модель деградирует > 3 циклов | Форсируем полный retrain, повышаем приоритет |
| Drift постоянный | Эскалация (manual review) |

## Инварианты качества
- Ни одна фаза не мутирует состояние «тихо» (всегда артефакт).
- Ошибка в фазе не блокирует генерацию отчёта о состоянии.
- Рискованные операции (retrain, откат) → отдельный журнал `risk_ops.log`.

## Минимальные точки наблюдаемости
Prometheus:
```
# HELP lifecycle_phase_duration_ms Duration of lifecycle phases
# TYPE lifecycle_phase_duration_ms histogram
lifecycle_phase_duration_ms{phase="awake"} 1234
lifecycle_phase_duration_ms{phase="update"} 5320
lifecycle_phase_duration_ms{phase="persist"} 980
```

## Минимальный план дальнейшего расширения
1. Реализация `drift_detector.py` (инкрементальные статистики + порог).  
2. Введение `policy_versioning.py` (автогенерация хэша + журнал).  
3. Расширение Persist для упаковки PQC подписи.  
4. Автоматизация RAG miss → ingestion workflow.  
5. Диагностический тест бэкапа (периодический restore на staging).  

## Резюме
Цикл обеспечивает управляемую эволюцию: раннее обнаружение деградаций, безопасная адаптация, воспроизводимость состояния и возможность отката.
