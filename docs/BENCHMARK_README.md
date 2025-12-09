# BENCHMARK_README — Методика подтверждения производственных заявок (x0tta6bl4)

## 1. Цель
Обеспечить воспроизводимую методику измерения производительности для ключевых заявок (NMP improvement, φ-QAOA uplift, 7653×).

## 2. Принципы
- Репрезентативность: использовать реальные топологии (10, 100, 500, 1000 узлов)
- Повторяемость: фиксированное seed значение
- Прозрачность: raw данные сохраняются в `benchmarks/results/*.json`
- Сравнимость: baseline vs improved алгоритмы

## 3. NMP (Mesh Optimization) Benchmark
| Метрика | Описание |
|---------|----------|
| Average Path Latency | Средняя задержка по маршруту (ms) |
| Path Stability Index | Кол-во изменений маршрута / час |
| Recovery MTTR | Среднее время восстановления после отказа (s) |
| Packet Delivery Ratio | Доля успешно доставленных пакетов (%) |

### Процедура
1. Сгенерировать топологию (generator_topology.py)
2. Запустить baseline routing (AODV)
3. Запустить enhanced routing (k-disjoint + heuristic)
4. Инъекция отказов (node failure, link degradation)
5. Сравнить метрики

## 4. φ-QAOA Benchmark (Концептуально)
| Метрика | Описание |
|---------|----------|
| Approximation Ratio | f(x_candidate)/f(x_optimal) |
| Circuit Depth | Глубина квантовой схемы |
| Wall-clock Runtime | Фактическое время выполнения |
| Energy Proxy | Оценка энергопотребления (симуляция) |

### Процедура (поэтапно)
1. Выбор задачи (MaxCut для графа 10-14 вершин)
2. Генерация classical baseline (simulated annealing / greedy)
3. Запуск QAOA (Qiskit Aer) с p=1..4
4. Применение φ-расписания параметров (placeholder → реальная формула)
5. Сравнение approximation ratio и runtime

## 5. 7653× Claim Верификация
| Возможная интерпретация | Риск |
|-------------------------|------|
| Runtime ускорение | Высокий (не подтверждено) |
| Energy efficiency | Средний |
| Approximation Quality | Средний |

### Требуемое действие
- Определить одну метрику (runtime или approximation)
- Провести ≥30 повторений
- Отобразить распределения (boxplot)

## 6. Формат результатов
```json
{
  "benchmark": "nmp_routing",
  "topology_size": 100,
  "algorithm": "k_disjoint_spf",
  "metrics": {
    "avg_path_latency_ms": 12.4,
    "path_stability_index": 3.2,
    "mttr_s": 2.1,
    "pdr_pct": 97.5
  },
  "timestamp": "2025-11-06T10:25:00Z"
}
```

## 7. Инструменты
| Tool | Назначение |
|------|------------|
| generator_topology.py | Генерация тестовых графов |
| failure_injector.py | Инъекция отказов |
| qaoa_runner.py | Запуск QAOA baseline |
| phi_qaoa_runner.py | Запуск φ-QAOA расписания |
| aggregator.py | Сбор и агрегация результатов |

## 8. Визуализация
- Grafana dashboard: latency, MTTR, stability
- Jupyter notebook: φ-QAOA vs baseline графики

## 9. Контроль качества
| Параметр | Критерий |
|----------|----------|
| Воспроизводимость | Отклонение <5% между повторениями |
| Надёжность | ≥95% успешных запусков |
| Полнота | Все ключевые метрики заполнены |

## 10. Следующие шаги
- Реализовать scripts для генерации графов и отказов
- Добавить QAOA baseline (Qiskit)
- Определить метрику для 7653×

---
*Версия: 1.0 — 3 ноября 2025*
