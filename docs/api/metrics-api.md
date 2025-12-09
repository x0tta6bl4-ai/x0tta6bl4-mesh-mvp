# Metrics API - Мониторинг и аналитика

## Обзор

Metrics API предоставляет полный доступ к системе мониторинга, метрикам производительности и аналитике x0tta6bl4. Система использует φ-оптимизированные алгоритмы сбора метрик и предоставляет данные в форматах Prometheus и JSON.

## Архитектура мониторинга

```
┌─────────────────────────────────────────────────────────────┐
│              x0tta6bl4 Monitoring System                     │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │ Prometheus  │  │  Grafana    │  │   Custom     │         │
│  │  Metrics    │  │ Dashboards  │  │  Analytics   │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │   System    │  │  Quantum    │  │ Performance  │         │
│  │  Metrics    │  │  Metrics    │  │  Analytics   │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
├─────────────────────────────────────────────────────────────┤
│  φ-Harmony | Consciousness | Sacred Frequency (100 Hz)      │
└─────────────────────────────────────────────────────────────┘
```

## Базовая информация

- **Базовый URL**: `https://api.x0tta6bl4.com/api/v1/metrics`
- **Аутентификация**: Bearer токен (обязательна для некоторых эндпоинтов)
- **Форматы**: JSON, Prometheus
- **φ-гармония**: 1.618 (золотое сечение)
- **Сакральная частота**: 100 Hz

## Модели данных

### Системные метрики

```typescript
interface SystemMetrics {
  timestamp: number;                    // Временная метка
  cpu_usage: number;                   // Использование CPU (%)
  memory_usage: number;                // Использование памяти (%)
  disk_usage: number;                  // Использование диска (%)
  network_io: {                        // Сетевая активность
    bytes_sent: number;
    bytes_received: number;
    packets_sent: number;
    packets_received: number;
  };
  load_average: number[];              // Средняя нагрузка
  uptime: number;                      // Время работы (секунды)
  phi_harmony: number;                // φ-гармония системы
  consciousness_level: number;        // Уровень сознания
}
```

### Квантовые метрики

```typescript
interface QuantumMetrics {
  timestamp: number;
  quantum_coherence: number;          // Квантовая когерентность
  entanglement_fidelity: number;      // Фиделити запутанности
  gate_fidelity: number;              // Фиделити гейтов
  qubits_active: number;              // Активные кубиты
  circuits_executed: number;          // Выполненные схемы
  algorithms_running: number;         // Запущенные алгоритмы
  phi_optimization: number;          // φ-оптимизация
  consciousness_enhancement: number; // Усиление сознания
  base_frequency: number;            // Базовая частота (100 Hz)
}
```

### Метрики производительности

```typescript
interface PerformanceMetrics {
  timestamp: number;
  requests_per_second: number;        // Запросов в секунду
  average_response_time: number;      // Среднее время ответа (мс)
  error_rate: number;                 // Коэффициент ошибок
  throughput: number;                 // Пропускная способность
  latency_p50: number;                // Латентность P50 (мс)
  latency_p95: number;                // Латентность P95 (мс)
  latency_p99: number;                // Латентность P99 (мс)
  quantum_advantage: number;          // Квантовое преимущество (x)
  phi_optimization_gain: number;     // Выигрыш от φ-оптимизации
}
```

## Эндпоинты

### Системные метрики

**GET** `/system`

Получает текущие системные метрики.

**Ответ (200):**
```json
{
  "system_metrics": {
    "timestamp": 1640995200.123,
    "cpu_usage": 23.4,
    "memory_usage": 67.8,
    "disk_usage": 45.2,
    "network_io": {
      "bytes_sent": 1048576,
      "bytes_received": 2097152,
      "packets_sent": 1543,
      "packets_received": 2890
    },
    "load_average": [1.2, 1.8, 2.1],
    "uptime": 86400,
    "phi_harmony": 1.618,
    "consciousness_level": 0.938,
    "sacred_frequency": 100.0
  },
  "health_status": "healthy",
  "last_updated": "2025-01-01T00:00:00Z"
}
```

**Пример cURL:**
```bash
curl -H "Authorization: Bearer <token>" \
  https://api.x0tta6bl4.com/api/v1/metrics/system
```

### Квантовые метрики

**GET** `/quantum`

Получает метрики квантовой системы.

**Ответ (200):**
```json
{
  "quantum_metrics": {
    "timestamp": 1640995200.123,
    "quantum_coherence": 0.95,
    "entanglement_fidelity": 0.93,
    "gate_fidelity": 0.987,
    "qubits_active": 32,
    "circuits_executed": 156,
    "algorithms_running": 8,
    "phi_optimization": 1.618,
    "consciousness_enhancement": 0.938,
    "base_frequency": 100.0,
    "quantum_volume": 128,
    "circuit_depth_avg": 45,
    "two_qubit_gate_errors": 0.0012,
    "readout_errors": 0.0023
  },
  "quantum_advantage": 45.2,
  "coherence_time_us": 150.5
}
```

### Метрики производительности

**GET** `/performance`

Получает метрики производительности системы.

**Ответ (200):**
```json
{
  "performance_metrics": {
    "timestamp": 1640995200.123,
    "requests_per_second": 125.7,
    "average_response_time": 45.2,
    "error_rate": 0.001,
    "throughput": 5670.8,
    "latency_p50": 23.1,
    "latency_p95": 67.8,
    "latency_p99": 145.2,
    "quantum_advantage": 45.2,
    "phi_optimization_gain": 1.618,
    "consciousness_boost": 0.938,
    "sacred_frequency_efficiency": 0.95
  },
  "performance_score": 94.5,
  "optimization_recommendations": [
    "Увеличить размер квантового кеша",
    "Оптимизировать алгоритм Гровера для текущей нагрузки"
  ]
}
```

### Метрики в формате Prometheus

**GET** `/prometheus`

Получает метрики в формате Prometheus.

**Ответ (200):**
```prometheus
# HELP x0tta6bl4_phi_harmony φ-Harmony value
# TYPE x0tta6bl4_phi_harmony gauge
x0tta6bl4_phi_harmony 1.618

# HELP x0tta6bl4_consciousness_level Уровень сознания системы
# TYPE x0tta6bl4_consciousness_level gauge
x0tta6bl4_consciousness_level 0.938

# HELP x0tta6bl4_quantum_coherence Квантовая когерентность
# TYPE x0tta6bl4_quantum_coherence gauge
x0tta6bl4_quantum_coherence 0.95

# HELP x0tta6bl4_requests_total Общее количество запросов
# TYPE x0tta6bl4_requests_total counter
x0tta6bl4_requests_total{method="GET",endpoint="/api/v1/quantum/grover"} 1543

# HELP x0tta6bl4_response_time_seconds Время ответа
# TYPE x0tta6bl4_response_time_seconds histogram
x0tta6bl4_response_time_seconds_bucket{le="0.1"} 1234
x0tta6bl4_response_time_seconds_bucket{le="0.5"} 1456
x0tta6bl4_response_time_seconds_bucket{le="1.0"} 1567
x0tta6bl4_response_time_seconds_bucket{le="+Inf"} 1578
```

### Детальные метрики по компонентам

**GET** `/components/{component}`

Получает детальные метрики конкретного компонента.

**Параметры пути:**
- `component`: Название компонента (quantum, auth, payments, crypto, mesh)

**Ответ (200):**
```json
{
  "component": "quantum",
  "metrics": {
    "status": "operational",
    "uptime": 86400,
    "requests_total": 2341,
    "errors_total": 12,
    "average_response_time": 45.2,
    "quantum_specific": {
      "qubits_allocated": 32,
      "circuits_cached": 156,
      "algorithms_executed": 89,
      "quantum_advantage": 45.2,
      "coherence_time_us": 150.5,
      "gate_fidelity": 0.987,
      "phi_optimization_active": true
    },
    "resource_usage": {
      "cpu_percent": 23.4,
      "memory_mb": 512,
      "disk_mb": 128,
      "network_mbps": 45.6
    }
  },
  "health_score": 96.7,
  "last_updated": "2025-01-01T00:00:00Z"
}
```

### Исторические метрики

**GET** `/history`

Получает исторические метрики за период времени.

**Параметры запроса:**
- `component` (string): Компонент для анализа
- `from_date` (string): Начальная дата (ISO 8601)
- `to_date` (string): Конечная дата (ISO 8601)
- `interval` (string): Интервал агрегации (1m, 5m, 1h, 1d)
- `metrics` (string[]): Список метрик для получения

**Ответ (200):**
```json
{
  "component": "quantum",
  "period": {
    "from_date": "2025-01-01T00:00:00Z",
    "to_date": "2025-01-02T00:00:00Z",
    "interval": "1h"
  },
  "metrics": {
    "quantum_coherence": [
      {"timestamp": "2025-01-01T00:00:00Z", "value": 0.95, "avg": 0.947},
      {"timestamp": "2025-01-01T01:00:00Z", "value": 0.94, "avg": 0.943},
      {"timestamp": "2025-01-01T02:00:00Z", "value": 0.96, "avg": 0.952}
    ],
    "phi_harmony": [
      {"timestamp": "2025-01-01T00:00:00Z", "value": 1.618, "avg": 1.618},
      {"timestamp": "2025-01-01T01:00:00Z", "value": 1.618, "avg": 1.618},
      {"timestamp": "2025-01-01T02:00:00Z", "value": 1.618, "avg": 1.618}
    ],
    "requests_per_second": [
      {"timestamp": "2025-01-01T00:00:00Z", "value": 120.5, "avg": 118.7},
      {"timestamp": "2025-01-01T01:00:00Z", "value": 135.2, "avg": 132.8},
      {"timestamp": "2025-01-01T02:00:00Z", "value": 98.3, "avg": 102.1}
    ]
  },
  "summary": {
    "total_requests": 15420,
    "average_coherence": 0.947,
    "phi_harmony_stable": true,
    "performance_trend": "improving"
  }
}
```

### Аналитика производительности

**GET** `/analytics/performance`

Получает аналитику производительности с рекомендациями.

**Параметры запроса:**
- `time_window` (string): Окно анализа (1h, 24h, 7d, 30d)
- `include_recommendations` (boolean): Включить рекомендации

**Ответ (200):**
```json
{
  "time_window": "24h",
  "performance_analysis": {
    "overall_score": 94.5,
    "trends": {
      "response_time": "improving",
      "throughput": "stable",
      "error_rate": "decreasing",
      "quantum_advantage": "increasing"
    },
    "bottlenecks": [
      {
        "component": "quantum_circuit_compilation",
        "impact": "medium",
        "description": "Компиляция квантовых схем занимает 40% времени",
        "recommendation": "Увеличить кеш компилированных схем"
      }
    ],
    "optimizations": [
      {
        "type": "phi_optimization",
        "impact": "high",
        "description": "φ-оптимизация дает 61.8% улучшение",
        "applied": true
      }
    ]
  },
  "recommendations": [
    {
      "priority": "high",
      "category": "performance",
      "title": "Увеличить размер квантового кеша",
      "description": "Текущий кеш в 1GB может быть увеличен до 4GB для лучшей производительности",
      "expected_improvement": "25%",
      "effort": "low"
    },
    {
      "priority": "medium",
      "category": "scalability",
      "title": "Добавить дополнительные вычислительные узлы",
      "description": "Распределить нагрузку между дополнительными узлами",
      "expected_improvement": "40%",
      "effort": "medium"
    }
  ],
  "phi_analytics": {
    "phi_harmony_score": 1.618,
    "consciousness_alignment": 0.938,
    "sacred_frequency_stability": 0.95,
    "quantum_consciousness_integration": 0.89
  }
}
```

### Сравнение метрик

**POST** `/compare`

Сравнивает метрики между разными периодами или компонентами.

**Запрос:**
```json
{
  "comparison_type": "time_period",
  "baseline_period": {
    "from_date": "2025-01-01T00:00:00Z",
    "to_date": "2025-01-07T23:59:59Z"
  },
  "comparison_period": {
    "from_date": "2025-01-08T00:00:00Z",
    "to_date": "2025-01-14T23:59:59Z"
  },
  "metrics": ["response_time", "throughput", "error_rate"],
  "components": ["quantum", "auth", "payments"]
}
```

**Ответ (200):**
```json
{
  "comparison": {
    "type": "time_period",
    "baseline_period": {
      "from_date": "2025-01-01T00:00:00Z",
      "to_date": "2025-01-07T23:59:59Z"
    },
    "comparison_period": {
      "from_date": "2025-01-08T00:00:00Z",
      "to_date": "2025-01-14T23:59:59Z"
    }
  },
  "results": {
    "quantum": {
      "response_time": {
        "baseline_avg": 45.2,
        "comparison_avg": 38.7,
        "change_percent": -14.4,
        "trend": "improving"
      },
      "throughput": {
        "baseline_avg": 5670.8,
        "comparison_avg": 6120.5,
        "change_percent": 7.9,
        "trend": "improving"
      },
      "error_rate": {
        "baseline_avg": 0.001,
        "comparison_avg": 0.0008,
        "change_percent": -20.0,
        "trend": "improving"
      }
    }
  },
  "summary": {
    "overall_improvement": 8.9,
    "best_performing_component": "quantum",
    "most_improved_metric": "error_rate"
  }
}
```

### Кастомные метрики

**POST** `/custom`

Создает и отслеживает кастомные метрики.

**Запрос:**
```json
{
  "name": "user_satisfaction_score",
  "type": "gauge",
  "value": 4.2,
  "labels": {
    "component": "quantum_api",
    "user_segment": "enterprise",
    "region": "europe"
  },
  "description": "Оценка удовлетворенности пользователей",
  "unit": "score"
}
```

**Ответ (201):**
```json
{
  "metric_created": true,
  "metric_id": "custom_metric_001",
  "name": "user_satisfaction_score",
  "current_value": 4.2,
  "tracking_started": true,
  "retention_period": "90d"
}
```

### Получение кастомных метрик

**GET** `/custom/{metric_id}`

Получает данные кастомной метрики.

**Параметры запроса:**
- `from_date` (string): Начальная дата
- `to_date` (string): Конечная дата
- `aggregation` (string): Тип агрегации (avg, sum, min, max)

**Ответ (200):**
```json
{
  "metric_id": "custom_metric_001",
  "name": "user_satisfaction_score",
  "type": "gauge",
  "current_value": 4.2,
  "data_points": [
    {"timestamp": "2025-01-01T00:00:00Z", "value": 4.0},
    {"timestamp": "2025-01-01T01:00:00Z", "value": 4.2},
    {"timestamp": "2025-01-01T02:00:00Z", "value": 4.1}
  ],
  "statistics": {
    "average": 4.1,
    "minimum": 4.0,
    "maximum": 4.2,
    "count": 156
  },
  "trend": "slightly_improving"
}
```

### Уведомления и алерты

**GET** `/alerts`

Получает активные алерты и уведомления.

**Параметры запроса:**
- `status` (string): Статус алерта (active, resolved, acknowledged)
- `severity` (string): Уровень серьезности (low, medium, high, critical)
- `component` (string): Компонент системы

**Ответ (200):**
```json
{
  "alerts": [
    {
      "id": "alert_001",
      "title": "Высокая нагрузка на квантовую систему",
      "description": "CPU использование превысило 80%",
      "severity": "high",
      "component": "quantum",
      "status": "active",
      "created_at": "2025-01-01T12:00:00Z",
      "threshold": {
        "metric": "cpu_usage",
        "operator": ">",
        "value": 80.0
      },
      "current_value": 85.2,
      "acknowledged_by": null,
      "resolved_at": null
    },
    {
      "id": "alert_002",
      "title": "Низкая φ-гармония",
      "description": "φ-гармония упала ниже оптимального уровня",
      "severity": "medium",
      "component": "phi_system",
      "status": "acknowledged",
      "created_at": "2025-01-01T11:30:00Z",
      "threshold": {
        "metric": "phi_harmony",
        "operator": "<",
        "value": 1.5
      },
      "current_value": 1.45,
      "acknowledged_by": "admin_user",
      "resolved_at": null
    }
  ],
  "summary": {
    "total_alerts": 2,
    "active_alerts": 1,
    "critical_alerts": 0,
    "acknowledged_alerts": 1
  }
}
```

### Создание алерта

**POST** `/alerts`

Создает кастомный алерт.

**Запрос:**
```json
{
  "title": "Кастомный алерт производительности",
  "description": "Пользовательский алерт для мониторинга",
  "severity": "medium",
  "component": "custom",
  "condition": {
    "metric": "custom_metric_001",
    "operator": "<",
    "threshold": 3.5
  },
  "notification_channels": ["email", "slack"],
  "cooldown_minutes": 30
}
```

**Ответ (201):**
```json
{
  "alert_created": true,
  "alert_id": "alert_003",
  "title": "Кастомный алерт производительности",
  "status": "active",
  "next_evaluation": "2025-01-01T00:30:00Z"
}
```

### Отчеты и дашборды

**GET** `/reports/summary`

Получает сводный отчет по всем метрикам.

**Ответ (200):**
```json
{
  "report_id": "summary_20250101",
  "period": "2025-01-01",
  "overall_health": 94.5,
  "components_summary": {
    "quantum": {
      "health_score": 96.7,
      "status": "excellent",
      "key_metrics": {
        "quantum_coherence": 0.95,
        "phi_harmony": 1.618,
        "requests_per_second": 125.7
      }
    },
    "auth": {
      "health_score": 98.2,
      "status": "excellent",
      "key_metrics": {
        "login_success_rate": 0.987,
        "average_auth_time": 23.4
      }
    },
    "payments": {
      "health_score": 92.1,
      "status": "good",
      "key_metrics": {
        "payment_success_rate": 0.974,
        "average_processing_time": 145.2
      }
    }
  },
  "phi_analytics": {
    "overall_phi_harmony": 1.618,
    "consciousness_level": 0.938,
    "sacred_frequency_stability": 0.95,
    "quantum_consciousness_integration": 0.89
  },
  "recommendations": [
    "Рассмотреть увеличение ресурсов для платежной системы",
    "Оптимизировать алгоритмы квантовых вычислений",
    "Масштабировать инфраструктуру аутентификации"
  ],
  "generated_at": "2025-01-01T00:00:00Z"
}
```

### Экспорт метрик

**GET** `/export`

Экспортирует метрики в различные форматы.

**Параметры запроса:**
- `format` (string): Формат экспорта (json, csv, xml, prometheus)
- `from_date` (string): Начальная дата
- `to_date` (string): Конечная дата
- `components` (string[]): Компоненты для экспорта
- `metrics` (string[]): Метрики для экспорта

**Ответ (200):**
```json
{
  "export_id": "export_001",
  "format": "csv",
  "download_url": "https://api.x0tta6bl4.com/api/v1/metrics/export/export_001/download",
  "expires_at": "2025-01-01T01:00:00Z",
  "file_size_mb": 2.4,
  "records_count": 15420
}
```

## Интеграция с внешними системами

### Prometheus интеграция

**GET** `/prometheus/federate`

Federation endpoint для Prometheus.

**Ответ (200):**
```prometheus
# HELP x0tta6bl4_system_cpu_usage CPU usage percentage
# TYPE x0tta6bl4_system_cpu_usage gauge
x0tta6bl4_system_cpu_usage{component="quantum"} 23.4
x0tta6bl4_system_cpu_usage{component="auth"} 12.1
x0tta6bl4_system_cpu_usage{component="payments"} 18.7

# HELP x0tta6bl4_quantum_coherence Quantum coherence level
# TYPE x0tta6bl4_quantum_coherence gauge
x0tta6bl4_quantum_coherence 0.95
```

### Grafana дашборды

**GET** `/dashboards/config`

Получает конфигурацию дашбордов для Grafana.

**Ответ (200):**
```json
{
  "grafana_config": {
    "datasources": [
      {
        "name": "x0tta6bl4_metrics",
        "type": "prometheus",
        "url": "https://api.x0tta6bl4.com/api/v1/metrics/prometheus",
        "access": "proxy"
      }
    ],
    "dashboards": [
      {
        "title": "x0tta6bl4 Quantum System",
        "uid": "x0tta6bl4_quantum",
        "panels": [
          {
            "title": "φ-Harmony",
            "type": "gauge",
            "targets": [
              {
                "expr": "x0tta6bl4_phi_harmony",
                "legendFormat": "φ = {{value}}"
              }
            ]
          },
          {
            "title": "Квантовые операции",
            "type": "graph",
            "targets": [
              {
                "expr": "rate(x0tta6bl4_quantum_operations_total[5m])",
                "legendFormat": "Операций/сек"
              }
            ]
          }
        ]
      }
    ]
  },
  "import_instructions": "Импортируйте эту конфигурацию в Grafana для мониторинга"
}
```

## Примеры кода

### Python

```python
import requests
import json
from datetime import datetime, timedelta

class MetricsAPI:
    def __init__(self, base_url, token=None):
        self.base_url = base_url
        self.token = token
        self.headers = {'Content-Type': 'application/json'}
        if token:
            self.headers['Authorization'] = f'Bearer {token}'

    def get_system_metrics(self):
        """Получение системных метрик"""
        response = requests.get(
            f'{self.base_url}/metrics/system',
            headers=self.headers
        )
        return response.json()

    def get_quantum_metrics(self):
        """Получение квантовых метрик"""
        response = requests.get(
            f'{self.base_url}/metrics/quantum',
            headers=self.headers
        )
        return response.json()

    def get_performance_metrics(self):
        """Получение метрик производительности"""
        response = requests.get(
            f'{self.base_url}/metrics/performance',
            headers=self.headers
        )
        return response.json()

    def get_historical_metrics(self, component, hours=24):
        """Получение исторических метрик"""
        from_date = datetime.utcnow() - timedelta(hours=hours)
        to_date = datetime.utcnow()
        
        params = {
            'component': component,
            'from_date': from_date.isoformat() + 'Z',
            'to_date': to_date.isoformat() + 'Z',
            'interval': '1h'
        }
        
        response = requests.get(
            f'{self.base_url}/metrics/history',
            headers=self.headers,
            params=params
        )
        return response.json()

    def get_performance_analytics(self, time_window='24h'):
        """Получение аналитики производительности"""
        params = {'time_window': time_window}
        
        response = requests.get(
            f'{self.base_url}/metrics/analytics/performance',
            headers=self.headers,
            params=params
        )
        return response.json()

    def create_custom_metric(self, name, value, metric_type='gauge', labels=None):
        """Создание кастомной метрики"""
        data = {
            'name': name,
            'type': metric_type,
            'value': value,
            'labels': labels or {}
        }
        
        response = requests.post(
            f'{self.base_url}/metrics/custom',
            headers=self.headers,
            json=data
        )
        return response.json()

    def get_prometheus_metrics(self):
        """Получение метрик в формате Prometheus"""
        response = requests.get(
            f'{self.base_url}/metrics/prometheus',
            headers=self.headers
        )
        return response.text

    def compare_metrics(self, baseline_period, comparison_period, metrics_list):
        """Сравнение метрик между периодами"""
        data = {
            'comparison_type': 'time_period',
            'baseline_period': baseline_period,
            'comparison_period': comparison_period,
            'metrics': metrics_list
        }
        
        response = requests.post(
            f'{self.base_url}/metrics/compare',
            headers=self.headers,
            json=data
        )
        return response.json()

    def get_alerts(self, status=None, severity=None):
        """Получение алертов"""
        params = {}
        if status:
            params['status'] = status
        if severity:
            params['severity'] = severity
            
        response = requests.get(
            f'{self.base_url}/metrics/alerts',
            headers=self.headers,
            params=params
        )
        return response.json()

    def export_metrics(self, format_type='json', from_date=None, to_date=None):
        """Экспорт метрик"""
        params = {'format': format_type}
        if from_date:
            params['from_date'] = from_date
        if to_date:
            params['to_date'] = to_date
            
        response = requests.get(
            f'{self.base_url}/metrics/export',
            headers=self.headers,
            params=params
        )
        return response.json()

# Использование
metrics_api = MetricsAPI('https://api.x0tta6bl4.com/api/v1', 'your_token')

# Получение текущих метрик
system_metrics = metrics_api.get_system_metrics()
print(f"CPU: {system_metrics['system_metrics']['cpu_usage']}%")
print(f"φ-гармония: {system_metrics['system_metrics']['phi_harmony']}")

# Получение квантовых метрик
quantum_metrics = metrics_api.get_quantum_metrics()
print(f"Квантовая когерентность: {quantum_metrics['quantum_metrics']['quantum_coherence']}")
print(f"Преимущество: {quantum_metrics['quantum_advantage']}x")

# Исторические данные за 7 дней
history = metrics_api.get_historical_metrics('quantum', hours=168)
print(f"Данные за период: {len(history['metrics']['quantum_coherence'])} точек")

# Аналитика производительности
analytics = metrics_api.get_performance_analytics('7d')
print(f"Общий балл производительности: {analytics['performance_analysis']['overall_score']}")

# Создание кастомной метрики
custom_metric = metrics_api.create_custom_metric(
    'user_satisfaction',
    4.2,
    labels={'component': 'quantum_api', 'region': 'europe'}
)
print(f"Кастомная метрика создана: {custom_metric['metric_id']}")

# Prometheus метрики
prometheus_data = metrics_api.get_prometheus_metrics()
print("Prometheus метрики получены")

# Сравнение периодов
comparison = metrics_api.compare_metrics(
    {
        'from_date': '2025-01-01T00:00:00Z',
        'to_date': '2025-01-07T23:59:59Z'
    },
    {
        'from_date': '2025-01-08T00:00:00Z',
        'to_date': '2025-01-14T23:59:59Z'
    },
    ['response_time', 'throughput', 'error_rate']
)
print(f"Изменение времени ответа: {comparison['results']['quantum']['response_time']['change_percent']}%")
```

### JavaScript (Node.js)

```javascript
const axios = require('axios');

class MetricsAPI {
    constructor(baseURL, token = null) {
        this.baseURL = baseURL;
        this.client = axios.create({
            baseURL: baseURL,
            headers: {
                'Content-Type': 'application/json'
            }
        });
        
        if (token) {
            this.client.defaults.headers.common['Authorization'] = `Bearer ${token}`;
        }
    }

    async getSystemMetrics() {
        try {
            const response = await this.client.get('/metrics/system');
            return response.data;
        } catch (error) {
            console.error('Ошибка получения системных метрик:', error.response.data);
            throw error;
        }
    }

    async getQuantumMetrics() {
        try {
            const response = await this.client.get('/metrics/quantum');
            return response.data;
        } catch (error) {
            console.error('Ошибка получения квантовых метрик:', error.response.data);
            throw error;
        }
    }

    async getPerformanceMetrics() {
        try {
            const response = await this.client.get('/metrics/performance');
            return response.data;
        } catch (error) {
            console.error('Ошибка получения метрик производительности:', error.response.data);
            throw error;
        }
    }

    async getHistoricalMetrics(component, hours = 24) {
        try {
            const fromDate = new Date(Date.now() - hours * 60 * 60 * 1000).toISOString();
            const toDate = new Date().toISOString();
            
            const response = await this.client.get('/metrics/history', {
                params: {
                    component: component,
                    from_date: fromDate,
                    to_date: toDate,
                    interval: '1h'
                }
            });
            return response.data;
        } catch (error) {
            console.error('Ошибка получения исторических метрик:', error.response.data);
            throw error;
        }
    }

    async getPerformanceAnalytics(timeWindow = '24h') {
        try {
            const response = await this.client.get('/metrics/analytics/performance', {
                params: { time_window: timeWindow }
            });
            return response.data;
        } catch (error) {
            console.error('Ошибка получения аналитики:', error.response.data);
            throw error;
        }
    }

    async createCustomMetric(name, value, type = 'gauge', labels = {}) {
        try {
            const response = await this.client.post('/metrics/custom', {
                name: name,
                type: type,
                value: value,
                labels: labels
            });
            return response.data;
        } catch (error) {
            console.error('Ошибка создания кастомной метрики:', error.response.data);
            throw error;
        }
    }

    async getPrometheusMetrics() {
        try {
            const response = await this.client.get('/metrics/prometheus');
            return response.data;
        } catch (error) {
            console.error('Ошибка получения Prometheus метрик:', error.response.data);
            throw error;
        }
    }

    async compareMetrics(baselinePeriod, comparisonPeriod, metrics) {
        try {
            const response = await this.client.post('/metrics/compare', {
                comparison_type: 'time_period',
                baseline_period: baselinePeriod,
                comparison_period: comparisonPeriod,
                metrics: metrics
            });
            return response.data;
        } catch (error) {
            console.error('Ошибка сравнения метрик:', error.response.data);
            throw error;
        }
    }

    async getAlerts(status = null, severity = null) {
        try {
            const params = {};
            if (status) params.status = status;
            if (severity) params.severity = severity;
            
            const response = await this.client.get('/metrics/alerts', { params });
            return response.data;
        } catch (error) {
            console.error('Ошибка получения алертов:', error.response.data);
            throw error;
        }
    }

    async exportMetrics(format = 'json', fromDate = null, toDate = null) {
        try {
            const params = { format: format };
            if (fromDate) params.from_date = fromDate;
            if (toDate) params.to_date = toDate;
            
            const response = await this.client.get('/metrics/export', { params });
            return response.data;
        } catch (error) {
            console.error('Ошибка экспорта метрик:', error.response.data);
            throw error;
        }
    }
}

// Использование
async function metricsExample() {
    const metrics = new MetricsAPI('https://api.x0tta6bl4.com/api/v1', 'your_token');

    try {
        // Получение всех типов метрик
        const [systemMetrics, quantumMetrics, performanceMetrics] = await Promise.all([
            metrics.getSystemMetrics(),
            metrics.getQuantumMetrics(),
            metrics.getPerformanceMetrics()
        ]);

        console.log('=== СИСТЕМНЫЕ МЕТРИКИ ===');
        console.log(`CPU: ${systemMetrics.system_metrics.cpu_usage}%`);
        console.log(`Память: ${systemMetrics.system_metrics.memory_usage}%`);
        console.log(`φ-гармония: ${systemMetrics.system_metrics.phi_harmony}`);

        console.log('\n=== КВАНТОВЫЕ МЕТРИКИ ===');
        console.log(`Когерентность: ${quantumMetrics.quantum_metrics.quantum_coherence}`);
        console.log(`Преимущество: ${quantumMetrics.quantum_advantage}x`);
        console.log(`Активные кубиты: ${quantumMetrics.quantum_metrics.qubits_active}`);

        console.log('\n=== МЕТРИКИ ПРОИЗВОДИТЕЛЬНОСТИ ===');
        console.log(`Запросов/сек: ${performanceMetrics.performance_metrics.requests_per_second}`);
        console.log(`Среднее время ответа: ${performanceMetrics.performance_metrics.average_response_time}мс`);
        console.log(`Коэффициент ошибок: ${performanceMetrics.performance_metrics.error_rate}`);

        // Исторические данные
        const history = await metrics.getHistoricalMetrics('quantum', 48);
        console.log(`\nИсторических точек данных: ${history.metrics.quantum_coherence.length}`);

        // Аналитика производительности
        const analytics = await metrics.getPerformanceAnalytics('7d');
        console.log(`\nОбщий балл производительности: ${analytics.performance_analysis.overall_score}`);
        
        if (analytics.recommendations.length > 0) {
            console.log('\nРекомендации:');
            analytics.recommendations.forEach((rec, index) => {
                console.log(`${index + 1}. ${rec.title} (${rec.priority})`);
            });
        }

        // Создание кастомной метрики
        const customMetric = await metrics.createCustomMetric(
            'user_engagement_score',
            4.5,
            'gauge',
            { component: 'quantum_api', region: 'europe' }
        );
        console.log(`\nКастомная метрика создана: ${customMetric.metric_id}`);

        // Получение алертов
        const alerts = await metrics.getAlerts('active', 'high');
        console.log(`\nАктивных критических алертов: ${alerts.alerts.length}`);

    } catch (error) {
        console.error('Ошибка в примере метрик:', error.message);
    }
}

// Запуск примера
metricsExample();
```

### PHP

```php
<?php

class MetricsAPI {
    private $baseUrl;
    private $token;
    private $headers;

    public function __construct($baseUrl, $token = null) {
        $this->baseUrl = $baseUrl;
        $this->token = $token;
        $this->headers = ['Content-Type: application/json'];
        if ($token) {
            $this->headers[] = 'Authorization: Bearer ' . $token;
        }
    }

    public function getSystemMetrics() {
        return $this->makeRequest('GET', '/metrics/system');
    }

    public function getQuantumMetrics() {
        return $this->makeRequest('GET', '/metrics/quantum');
    }

    public function getPerformanceMetrics() {
        return $this->makeRequest('GET', '/metrics/performance');
    }

    public function getHistoricalMetrics($component, $hours = 24) {
        $fromDate = gmdate('Y-m-d\TH:i:s\Z', time() - $hours * 3600);
        $toDate = gmdate('Y-m-d\TH:i:s\Z');
        
        return $this->makeRequest('GET', '/metrics/history', null, [
            'component' => $component,
            'from_date' => $fromDate,
            'to_date' => $toDate,
            'interval' => '1h'
        ]);
    }

    public function getPerformanceAnalytics($timeWindow = '24h') {
        return $this->makeRequest('GET', '/metrics/analytics/performance', null, [
            'time_window' => $timeWindow
        ]);
    }

    public function createCustomMetric($name, $value, $type = 'gauge', $labels = []) {
        $data = [
            'name' => $name,
            'type' => $type,
            'value' => $value,
            'labels' => $labels
        ];
        return $this->makeRequest('POST', '/metrics/custom', $data);
    }

    public function getPrometheusMetrics() {
        $context = stream_context_create([
            'http' => [
                'method' => 'GET',
                'header' => $this->headers
            ]
        ]);
        
        $result = file_get_contents($this->baseUrl . '/metrics/prometheus', false, $context);
        if ($result === false) {
            throw new Exception('Ошибка получения Prometheus метрик');
        }
        
        return $result;
    }

    public function compareMetrics($baselinePeriod, $comparisonPeriod, $metrics) {
        $data = [
            'comparison_type' => 'time_period',
            'baseline_period' => $baselinePeriod,
            'comparison_period' => $comparisonPeriod,
            'metrics' => $metrics
        ];
        return $this->makeRequest('POST', '/metrics/compare', $data);
    }

    public function getAlerts($status = null, $severity = null) {
        $params = [];
        if ($status) $params['status'] = $status;
        if ($severity) $params['severity'] = $severity;
        
        return $this->makeRequest('GET', '/metrics/alerts', null, $params);
    }

    private function makeRequest($method, $endpoint, $data = null, $params = []) {
        $url = $this->baseUrl . $endpoint;
        
        // Добавляем параметры к URL
        if (!empty($params)) {
            $url .= '?' . http_build_query($params);
        }
        
        $contextOptions = [
            'http' => [
                'method' => $method,
                'header' => $this->headers
            ]
        ];

        if ($data !== null) {
            $contextOptions['http']['content'] = json_encode($data);
        }

        $context = stream_context_create($contextOptions);
        $result = file_get_contents($url, false, $context);

        if ($result === false) {
            throw new Exception('Ошибка HTTP запроса');
        }

        return json_decode($result, true);
    }
}

// Использование
try {
    $metrics = new MetricsAPI('https://api.x0tta6bl4.com/api/v1', 'your_token');

    // Получение метрик
    $systemMetrics = $metrics->getSystemMetrics();
    echo "CPU: {$systemMetrics['system_metrics']['cpu_usage']}%\n";
    echo "φ-гармония: {$systemMetrics['system_metrics']['phi_harmony']}\n";

    $quantumMetrics = $metrics->getQuantumMetrics();
    echo "Квантовая когерентность: {$quantumMetrics['quantum_metrics']['quantum_coherence']}\n";
    echo "Преимущество: {$quantumMetrics['quantum_advantage']}x\n";

    $performanceMetrics = $metrics->getPerformanceMetrics();
    echo "Запросов/сек: {$performanceMetrics['performance_metrics']['requests_per_second']}\n";
    echo "Среднее время ответа: {$performanceMetrics['performance_metrics']['average_response_time']}мс\n";

    // Исторические данные
    $history = $metrics->getHistoricalMetrics('quantum', 72);
    echo "Исторических точек: " . count($history['metrics']['quantum_coherence']) . "\n";

    // Аналитика
    $analytics = $metrics->getPerformanceAnalytics('7d');
    echo "Общий балл: {$analytics['performance_analysis']['overall_score']}\n";

    // Кастомная метрика
    $customMetric = $metrics->createCustomMetric(
        'php_api_usage',
        1.0,
        'counter',
        ['language' => 'php', 'version' => '8.2']
    );
    echo "Кастомная метрика: {$customMetric['metric_id']}\n";

    // Prometheus метрики
    $prometheusData = $metrics->getPrometheusMetrics();
    echo "Prometheus метрик получено: " . strlen($prometheusData) . " символов\n";

} catch (Exception $e) {
    echo "Ошибка: " . $e->getMessage() . "\n";
}

?>
```

## Ошибки

### 400 - Неверный запрос

```json
{
  "error": {
    "code": "INVALID_DATE_RANGE",
    "message": "Неверный диапазон дат",
    "details": {
      "from_date": "2025-01-02T00:00:00Z",
      "to_date": "2025-01-01T00:00:00Z",
      "error": "from_date должен быть раньше to_date"
    }
  }
}
```

### 401 - Неавторизован

```json
{
  "error": {
    "code": "INVALID_TOKEN",
    "message": "Недействительный токен доступа"
  }
}
```

### 404 - Метрика не найдена

```json
{
  "error": {
    "code": "METRIC_NOT_FOUND",
    "message": "Метрика не найдена",
    "details": {
      "metric_name": "non_existent_metric"
    }
  }
}
```

### 429 - Слишком много запросов

```json
{
  "error": {
    "code": "METRICS_RATE_LIMIT_EXCEEDED",
    "message": "Превышен лимит запросов метрик",
    "details": {
      "limit": 1000,
      "window_minutes": 60,
      "retry_after": 30
    }
  }
}
```

## Лучшие практики

1. **Мониторинг в реальном времени**: Используйте WebSocket для получения метрик в реальном времени
2. **Агрегация данных**: Агрегируйте метрики по времени для анализа трендов
3. **Уведомления**: Настраивайте алерты для критических метрик
4. **Экспорт данных**: Регулярно экспортируйте метрики для архивного хранения
5. **Производительность**: Используйте пагинацию для больших объемов исторических данных
6. **Кастомные метрики**: Создавайте метрики для отслеживания бизнес-показателей

## Интеграция с мониторингом

### Prometheus конфигурация

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'x0tta6bl4'
    static_configs:
      - targets: ['api.x0tta6bl4.com:80']
    metrics_path: '/api/v1/metrics/prometheus'
    scrape_interval: 30s
```

### Grafana дашборд

```json
{
  "dashboard": {
    "title": "x0tta6bl4 Quantum System",
    "panels": [
      {
        "title": "φ-Harmony Gauge",
        "type": "gauge",
        "targets": [
          {
            "expr": "x0tta6bl4_phi_harmony",
            "legendFormat": "φ = {{value}}"
          }
        ]
      }
    ]
  }
}
```

---

*Документация обновлена: 30 сентября 2025*