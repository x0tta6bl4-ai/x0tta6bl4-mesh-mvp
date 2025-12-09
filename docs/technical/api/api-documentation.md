# API Документация x0tta6bl4

## Обзор API

REST API платформы x0tta6bl4 предоставляет доступ к квантовой оптимизации платежей, управлению compliance и мониторингу системы.

### Базовая информация

- **Base URL:** `https://api.x0tta6bl4.com`
- **Версия API:** v1
- **Формат ответа:** JSON
- **Аутентификация:** JWT Bearer токен

### Схема аутентификации

```http
Authorization: Bearer <jwt_token>
```

## Endpoints

### Аутентификация

#### POST /api/v1/auth/login

Вход в систему и получение JWT токена.

**Request Body:**
```json
{
  "username": "string",
  "password": "string"
}
```

**Response:**
```json
{
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "token_type": "bearer",
  "expires_in": 3600,
  "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."
}
```

**Коды ответа:**
- `200` - Успешная аутентификация
- `401` - Неверные учетные данные
- `429` - Слишком много попыток

### Платежи

#### POST /api/v1/payments

Создание нового платежа с квантовой оптимизацией.

**Headers:**
```
Authorization: Bearer <token>
Content-Type: application/json
Idempotency-Key: <unique_key>
```

**Request Body:**
```json
{
  "amount": 1500.50,
  "currency": "RUB",
  "payment_method": {
    "type": "card",
    "card_token": "card_1234567890abcdef"
  },
  "description": "Оплата за услуги",
  "metadata": {
    "order_id": "order_123",
    "customer_id": "customer_456"
  },
  "optimization": {
    "enabled": true,
    "priority": "cost" | "speed" | "security",
    "constraints": {
      "max_fee": 50.0,
      "preferred_gateway": "mir"
    }
  }
}
```

**Response:**
```json
{
  "id": "payment_1234567890abcdef",
  "status": "processing",
  "amount": 1500.50,
  "currency": "RUB",
  "fee": 22.50,
  "optimization_result": {
    "algorithm": "QAOA",
    "optimization_score": 0.94,
    "route": "MIR->SBP->CBR",
    "estimated_savings": 15.30
  },
  "created_at": "2025-10-01T08:45:20.630Z",
  "estimated_completion": "2025-10-01T08:45:35.630Z"
}
```

**Коды ответа:**
- `201` - Платеж создан
- `400` - Неверные данные платежа
- `401` - Неавторизован
- `409` - Платеж с таким ключом уже существует

#### GET /api/v1/payments/{payment_id}

Получение статуса платежа.

**Path Parameters:**
- `payment_id` (string) - ID платежа

**Response:**
```json
{
  "id": "payment_1234567890abcdef",
  "status": "completed",
  "amount": 1500.50,
  "currency": "RUB",
  "fee": 22.50,
  "gateway_response": {
    "gateway": "mir",
    "transaction_id": "mir_tx_123456",
    "status": "success",
    "processed_at": "2025-10-01T08:45:32.100Z"
  },
  "created_at": "2025-10-01T08:45:20.630Z",
  "completed_at": "2025-10-01T08:45:32.100Z"
}
```

#### GET /api/v1/payments

Получение списка платежей с пагинацией и фильтрацией.

**Query Parameters:**
- `page` (integer, optional) - Номер страницы (по умолчанию 1)
- `limit` (integer, optional) - Количество элементов (по умолчанию 20, максимум 100)
- `status` (string, optional) - Фильтр по статусу
- `date_from` (string, optional) - Начальная дата (ISO 8601)
- `date_to` (string, optional) - Конечная дата (ISO 8601)

**Response:**
```json
{
  "payments": [
    {
      "id": "payment_1234567890abcdef",
      "status": "completed",
      "amount": 1500.50,
      "currency": "RUB",
      "created_at": "2025-10-01T08:45:20.630Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 150,
    "pages": 8
  }
}
```

### Квантовые алгоритмы

#### POST /api/v1/quantum/optimize

Оптимизация платежных маршрутов с использованием квантовых алгоритмов.

**Request Body:**
```json
{
  "payments": [
    {
      "id": "payment_1",
      "amount": 1000.0,
      "source_bank": "sberbank",
      "target_bank": "tinkoff"
    },
    {
      "id": "payment_2",
      "amount": 2500.0,
      "source_bank": "vtb",
      "target_bank": "raiffeisen"
    }
  ],
  "constraints": {
    "max_total_fee": 100.0,
    "preferred_gateways": ["mir", "sbp"],
    "excluded_gateways": ["visa", "mastercard"]
  },
  "algorithm": {
    "type": "QAOA",
    "parameters": {
      "layers": 3,
      "shots": 1000,
      "optimization_level": 2
    }
  }
}
```

**Response:**
```json
{
  "optimization_id": "opt_1234567890abcdef",
  "algorithm": "QAOA",
  "status": "completed",
  "results": {
    "optimal_route": [
      {
        "payment_id": "payment_1",
        "gateway": "mir",
        "fee": 15.0,
        "estimated_time": "2m 30s"
      },
      {
        "payment_id": "payment_2",
        "gateway": "sbp",
        "fee": 25.0,
        "estimated_time": "1m 45s"
      }
    ],
    "total_fee": 40.0,
    "total_time": "4m 15s",
    "improvement": {
      "fee_reduction": 0.15,
      "time_reduction": 0.08
    }
  },
  "execution_metrics": {
    "circuit_depth": 24,
    "gate_count": 156,
    "execution_time": "12.5s",
    "shots": 1000
  }
}
```

#### GET /api/v1/quantum/algorithms

Получение списка доступных квантовых алгоритмов.

**Response:**
```json
{
  "algorithms": [
    {
      "id": "qaoa",
      "name": "Quantum Approximate Optimization Algorithm",
      "description": "Алгоритм для решения комбинаторных задач оптимизации",
      "parameters": {
        "layers": {
          "type": "integer",
          "min": 1,
          "max": 10,
          "default": 3
        },
        "shots": {
          "type": "integer",
          "min": 100,
          "max": 10000,
          "default": 1000
        }
      }
    },
    {
      "id": "vqe",
      "name": "Variational Quantum Eigensolver",
      "description": "Алгоритм для поиска минимального собственного значения",
      "parameters": {
        "ansatz": {
          "type": "string",
          "enum": ["EfficientSU2", "RealAmplitudes", "TwoLocal"],
          "default": "EfficientSU2"
        }
      }
    }
  ]
}
```

### Compliance

#### GET /api/v1/compliance/check

Проверка соответствия платежа регуляторным требованиям.

**Query Parameters:**
- `payment_id` (string, required) - ID платежа для проверки

**Response:**
```json
{
  "payment_id": "payment_1234567890abcdef",
  "compliance_status": "compliant",
  "checks": [
    {
      "standard": "FZ-152",
      "status": "passed",
      "description": "Локализация данных в РФ",
      "details": {
        "data_center": "Moscow DC-1",
        "encryption": "GOST-256",
        "backup_location": "Moscow DC-2"
      }
    },
    {
      "standard": "PCI DSS",
      "status": "passed",
      "description": "Безопасность данных держателя карты",
      "details": {
        "encryption": "AES-256-GCM",
        "tokenization": "enabled",
        "network_segmentation": "compliant"
      }
    }
  ],
  "violations": [],
  "recommendations": [
    "Рассмотрите использование квантово-устойчивого шифрования для повышенной безопасности"
  ]
}
```

#### POST /api/v1/compliance/report

Генерация отчета о соответствии.

**Request Body:**
```json
{
  "report_type": "full" | "summary" | "violations_only",
  "period": {
    "from": "2025-10-01T00:00:00Z",
    "to": "2025-10-31T23:59:59Z"
  },
  "standards": ["FZ-152", "PCI DSS", "GDPR"],
  "format": "json" | "pdf" | "xlsx"
}
```

**Response:**
```json
{
  "report_id": "report_1234567890abcdef",
  "status": "generating",
  "estimated_completion": "2025-10-01T09:00:00Z",
  "download_url": "https://api.x0tta6bl4.com/api/v1/compliance/reports/report_1234567890abcdef/download"
}
```

### Мониторинг

#### GET /api/v1/metrics/system

Получение системных метрик.

**Response:**
```json
{
  "timestamp": "2025-10-01T08:45:20.630Z",
  "system": {
    "uptime": "15d 8h 32m",
    "load_average": [1.2, 1.8, 2.1],
    "memory": {
      "total": "32GB",
      "used": "18GB",
      "free": "14GB",
      "usage_percent": 56.25
    },
    "disk": {
      "total": "1TB",
      "used": "450GB",
      "free": "550GB",
      "usage_percent": 45.0
    }
  },
  "kubernetes": {
    "nodes": 5,
    "pods_running": 23,
    "pods_pending": 0,
    "cpu_usage": "2.1 cores",
    "memory_usage": "12GB"
  }
}
```

#### GET /api/v1/metrics/quantum

Получение метрик квантовых вычислений.

**Response:**
```json
{
  "timestamp": "2025-10-01T08:45:20.630Z",
  "quantum": {
    "circuits_executed": 15420,
    "average_circuit_depth": 18.5,
    "average_gate_fidelity": 0.997,
    "optimization_success_rate": 0.94,
    "backends": {
      "qiskit_aer": {
        "circuits": 8930,
        "avg_execution_time": "2.3s",
        "error_rate": 0.001
      },
      "ibm_quantum": {
        "circuits": 6490,
        "avg_execution_time": "15.7s",
        "error_rate": 0.003
      }
    }
  }
}
```

#### GET /api/v1/metrics/payments

Получение метрик платежей.

**Response:**
```json
{
  "timestamp": "2025-10-01T08:45:20.630Z",
  "payments": {
    "total_processed": 45670,
    "success_rate": 0.987,
    "average_processing_time": "3.2s",
    "total_volume": "125000000 RUB",
    "gateways": {
      "mir": {
        "transactions": 23450,
        "success_rate": 0.992,
        "avg_time": "2.8s"
      },
      "sbp": {
        "transactions": 18920,
        "success_rate": 0.985,
        "avg_time": "3.5s"
      },
      "cbr": {
        "transactions": 3300,
        "success_rate": 0.980,
        "avg_time": "4.1s"
      }
    }
  }
}
```

### Администрирование

#### GET /api/v1/admin/health

Проверка здоровья системы.

**Response:**
```json
{
  "status": "healthy",
  "timestamp": "2025-10-01T08:45:20.630Z",
  "services": {
    "api_gateway": {"status": "healthy", "response_time": "12ms"},
    "quantum_engine": {"status": "healthy", "response_time": "45ms"},
    "payment_engine": {"status": "healthy", "response_time": "23ms"},
    "compliance_engine": {"status": "healthy", "response_time": "18ms"},
    "database": {"status": "healthy", "response_time": "5ms"},
    "redis": {"status": "healthy", "response_time": "2ms"}
  },
  "dependencies": {
    "mir_gateway": {"status": "healthy", "response_time": "150ms"},
    "sbp_gateway": {"status": "healthy", "response_time": "120ms"},
    "cbr_api": {"status": "healthy", "response_time": "200ms"}
  }
}
```

#### POST /api/v1/admin/maintenance

Управление режимом обслуживания.

**Request Body:**
```json
{
  "action": "enable" | "disable",
  "services": ["payment_engine", "quantum_engine"],
  "message": "Плановое техническое обслуживание",
  "estimated_duration": "2h"
}
```

**Response:**
```json
{
  "maintenance_mode": "enabled",
  "affected_services": ["payment_engine", "quantum_engine"],
  "message": "Плановое техническое обслуживание",
  "enabled_at": "2025-10-01T08:45:20.630Z",
  "estimated_duration": "2h"
}
```

## Модели данных

### PaymentRequest

```typescript
interface PaymentRequest {
  amount: number;           // Сумма платежа в копейках
  currency: string;         // Валюта (RUB, USD, EUR)
  payment_method: {
    type: 'card' | 'bank_transfer' | 'sbp';
    card_token?: string;    // Для карточных платежей
    account_number?: string; // Для банковских переводов
    bank_bic?: string;      // БИК банка
  };
  description?: string;     // Описание платежа
  metadata?: Record<string, any>; // Дополнительные данные
  optimization?: {
    enabled: boolean;       // Включить квантовую оптимизацию
    priority: 'cost' | 'speed' | 'security';
    constraints?: {
      max_fee?: number;   // Максимальная комиссия
      preferred_gateway?: string;
      excluded_gateways?: string[];
    };
  };
}
```

### PaymentResponse

```typescript
interface PaymentResponse {
  id: string;               // Уникальный ID платежа
  status: 'pending' | 'processing' | 'completed' | 'failed' | 'cancelled';
  amount: number;           // Сумма платежа
  currency: string;         // Валюта
  fee: number;             // Комиссия
  gateway_response?: {
    gateway: string;       // Использованный шлюз
    transaction_id: string; // ID транзакции в шлюзе
    status: string;        // Статус в шлюзе
    processed_at: string;  // Время обработки
  };
  optimization_result?: {
    algorithm: string;     // Использованный алгоритм
    optimization_score: number; // Оценка оптимизации
    route: string;         // Оптимальный маршрут
    estimated_savings: number; // Предполагаемая экономия
  };
  created_at: string;       // Время создания
  completed_at?: string;    // Время завершения
}
```

### OptimizationRequest

```typescript
interface OptimizationRequest {
  payments: Array<{
    id: string;
    amount: number;
    source_bank: string;
    target_bank: string;
    urgency?: 'low' | 'normal' | 'high';
  }>;
  constraints: {
    max_total_fee?: number;
    preferred_gateways?: string[];
    excluded_gateways?: string[];
    max_processing_time?: number;
  };
  algorithm: {
    type: 'QAOA' | 'VQE' | 'QA' | 'classical';
    parameters: Record<string, any>;
  };
}
```

## Коды ошибок

| Код | Описание | Решение |
|-----|----------|---------|
| `400` | Неверный запрос | Проверьте формат данных |
| `401` | Неавторизован | Проверьте токен аутентификации |
| `403` | Доступ запрещен | Недостаточно прав |
| `404` | Ресурс не найден | Проверьте ID ресурса |
| `409` | Конфликт | Ресурс уже существует |
| `422` | Невалидируемые данные | Проверьте данные на соответствие схеме |
| `429` | Слишком много запросов | Подождите перед следующим запросом |
| `500` | Внутренняя ошибка сервера | Обратитесь в поддержку |
| `502` | Bad Gateway | Временная проблема с внешним сервисом |
| `503` | Сервис недоступен | Сервис временно отключен |

## Примеры использования

### cURL примеры

```bash
# Аутентификация
curl -X POST "https://api.x0tta6bl4.com/api/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"username": "your_username", "password": "your_password"}'

# Создание платежа
curl -X POST "https://api.x0tta6bl4.com/api/v1/payments" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -H "Idempotency-Key: unique_key_123" \
  -d '{
    "amount": 150050,
    "currency": "RUB",
    "payment_method": {
      "type": "card",
      "card_token": "card_token_123"
    },
    "description": "Оплата услуг",
    "optimization": {
      "enabled": true,
      "priority": "cost"
    }
  }'

# Проверка статуса платежа
curl -X GET "https://api.x0tta6bl4.com/api/v1/payments/payment_123" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# Квантовая оптимизация
curl -X POST "https://api.x0tta6bl4.com/api/v1/quantum/optimize" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "payments": [
      {
        "id": "payment_1",
        "amount": 100000,
        "source_bank": "sberbank",
        "target_bank": "tinkoff"
      }
    ],
    "algorithm": {
      "type": "QAOA",
      "parameters": {
        "layers": 3,
        "shots": 1000
      }
    }
  }'
```

### Python примеры

```python
import httpx
import asyncio
from typing import Dict, Any

class X0tta6bl4Client:
    """Клиент для работы с API x0tta6bl4."""

    def __init__(self, base_url: str, api_token: str):
        self.base_url = base_url
        self.api_token = api_token
        self.client = httpx.AsyncClient(
            headers={"Authorization": f"Bearer {api_token}"}
        )

    async def create_payment(self, payment_data: Dict[str, Any]) -> Dict[str, Any]:
        """Создание платежа."""
        response = await self.client.post(
            f"{self.base_url}/api/v1/payments",
            json=payment_data,
            headers={"Idempotency-Key": "unique_key_123"}
        )
        response.raise_for_status()
        return response.json()

    async def get_payment_status(self, payment_id: str) -> Dict[str, Any]:
        """Получение статуса платежа."""
        response = await self.client.get(
            f"{self.base_url}/api/v1/payments/{payment_id}"
        )
        response.raise_for_status()
        return response.json()

    async def optimize_payments(self, optimization_request: Dict[str, Any]) -> Dict[str, Any]:
        """Квантовая оптимизация платежей."""
        response = await self.client.post(
            f"{self.base_url}/api/v1/quantum/optimize",
            json=optimization_request
        )
        response.raise_for_status()
        return response.json()

# Пример использования
async def main():
    client = X0tta6bl4Client("https://api.x0tta6bl4.com", "your_token")

    # Создание платежа
    payment = await client.create_payment({
        "amount": 150050,
        "currency": "RUB",
        "payment_method": {
            "type": "card",
            "card_token": "card_token_123"
        },
        "optimization": {
            "enabled": True,
            "priority": "cost"
        }
    })

    print(f"Payment created: {payment['id']}")

    # Оптимизация платежей
    optimization = await client.optimize_payments({
        "payments": [
            {
                "id": "payment_1",
                "amount": 100000,
                "source_bank": "sberbank",
                "target_bank": "tinkoff"
            }
        ],
        "algorithm": {
            "type": "QAOA",
            "parameters": {
                "layers": 3,
                "shots": 1000
            }
        }
    })

    print(f"Optimization completed: {optimization['results']['total_fee']}")

if __name__ == "__main__":
    asyncio.run(main())
```

## Webhook уведомления

### Настройка webhook

```bash
# Регистрация webhook endpoint
curl -X POST "https://api.x0tta6bl4.com/api/v1/webhooks" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://your-app.com/webhooks/x0tta6bl4",
    "events": ["payment.completed", "payment.failed", "optimization.completed"],
    "secret": "your_webhook_secret"
  }'
```

### Формат webhook уведомления

```json
{
  "event": "payment.completed",
  "timestamp": "2025-10-01T08:45:32.100Z",
  "data": {
    "payment_id": "payment_1234567890abcdef",
    "status": "completed",
    "amount": 1500.50,
    "currency": "RUB"
  },
  "signature": "sha256=abc123..."
}
```

## Rate Limiting

API имеет ограничения на количество запросов:

| Endpoint | Ограничение | Период |
|----------|-------------|---------|
| POST /api/v1/payments | 100 запросов | 1 минута |
| GET /api/v1/payments | 1000 запросов | 1 минута |
| POST /api/v1/quantum/optimize | 10 запросов | 1 минута |
| GET /api/v1/metrics/* | 100 запросов | 1 минута |

При превышении лимита возвращается HTTP 429 с заголовком `Retry-After`.

## SDK и библиотеки

### Официальные SDK

- **Python SDK:** `pip install x0tta6bl4-python`
- **JavaScript SDK:** `npm install x0tta6bl4-js`
- **Go SDK:** `go get github.com/x0tta6bl4/go-sdk`

### Сообщество

- **PHP SDK:** Разработка сообществом
- **Ruby SDK:** Разработка сообществом
- **C# SDK:** Разработка сообществом

## Поддержка

### Контакты поддержки

- **Техническая поддержка:** support@x0tta6bl4.com
- **Документация:** docs@x0tta6bl4.com
- **Безопасность:** security@x0tta6bl4.com
- **Бизнес:** business@x0tta6bl4.com

### SLA

| Уровень | Время реакции | Время решения | Доступность |
|---------|---------------|---------------|-------------|
| Критический | 15 минут | 4 часа | 99.9% |
| Высокий | 1 час | 24 часа | 99.9% |
| Средний | 4 часа | 7 дней | 99.9% |
| Низкий | 24 часа | 30 дней | 99.9% |

---

*Последнее обновление: Октябрь 2025*
*Версия API: 1.0.0*