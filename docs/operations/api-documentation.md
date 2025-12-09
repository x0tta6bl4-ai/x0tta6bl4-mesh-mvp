# Документация API x0tta6bl4

## Обзор API

Система x0tta6bl4 предоставляет RESTful API для взаимодействия с различными компонентами платформы. Все API используют JSON формат данных и следуют стандартам HTTP.

## Базовая информация

### Аутентификация

Все API (кроме публичных эндпоинтов) требуют аутентификации через JWT токены:

```bash
curl -H "Authorization: Bearer <jwt_token>" \
     -H "Content-Type: application/json" \
     https://api.x0tta6bl4.com/api/v1/endpoint
```

### Общие заголовки ответа

```http
HTTP/1.1 200 OK
Content-Type: application/json
X-Request-ID: 123e4567-e89b-12d3-a456-426614174000
X-Response-Time: 150ms
```

### Коды ошибок

| Код | Описание |
|-----|----------|
| 200 | Успешный запрос |
| 201 | Ресурс создан |
| 400 | Неверный запрос |
| 401 | Неавторизован |
| 403 | Запрещено |
| 404 | Ресурс не найден |
| 429 | Слишком много запросов |
| 500 | Внутренняя ошибка сервера |

## API Gateway

### Базовый URL
```
https://api.x0tta6bl4.com/api/v1
```

### Аутентификация

#### Регистрация пользователя
```http
POST /auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "secure_password",
  "first_name": "John",
  "last_name": "Doe",
  "organization": "Example Corp"
}
```

**Ответ:**
```json
{
  "user_id": "123e4567-e89b-12d3-a456-426614174000",
  "email": "user@example.com",
  "status": "pending_verification",
  "created_at": "2025-01-01T00:00:00Z"
}
```

#### Вход в систему
```http
POST /auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "secure_password"
}
```

**Ответ:**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIs...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIs...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "user": {
    "id": "123e4567-e89b-12d3-a456-426614174000",
    "email": "user@example.com",
    "role": "user"
  }
}
```

#### Обновление токена
```http
POST /auth/refresh
Authorization: Bearer <refresh_token>
```

### Квантовые операции

#### Запуск квантового вычисления
```http
POST /quantum/compute
Content-Type: application/json
Authorization: Bearer <access_token>

{
  "algorithm": "shor",
  "parameters": {
    "qubits": 16,
    "shots": 1024,
    "optimization_level": 2
  },
  "data": {
    "input_value": "15",
    "modulus": "35"
  },
  "priority": "normal",
  "callback_url": "https://example.com/webhook"
}
```

**Ответ:**
```json
{
  "computation_id": "quantum_123e4567-e89b-12d3-a456-426614174000",
  "status": "queued",
  "estimated_time": "00:05:30",
  "queue_position": 3,
  "created_at": "2025-01-01T00:00:00Z"
}
```

#### Получение результатов квантового вычисления
```http
GET /quantum/compute/{computation_id}
Authorization: Bearer <access_token>
```

**Ответ:**
```json
{
  "computation_id": "quantum_123e4567-e89b-12d3-a456-426614174000",
  "status": "completed",
  "result": {
    "factors": [5, 7],
    "probability": 0.85,
    "execution_time": "00:04:23"
  },
  "metadata": {
    "algorithm": "shor",
    "qubits_used": 16,
    "gate_error_rate": 0.001,
    "coherence_time": "150μs"
  },
  "created_at": "2025-01-01T00:00:00Z",
  "completed_at": "2025-01-01T00:04:23Z"
}
```

#### Получение квантовых ключей
```http
GET /quantum/keys
Authorization: Bearer <access_token>
```

**Ответ:**
```json
{
  "public_key": "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA...\n-----END PUBLIC KEY-----",
  "key_id": "qk_123e4567-e89b-12d3-a456-426614174000",
  "algorithm": "Kyber-1024",
  "created_at": "2025-01-01T00:00:00Z",
  "expires_at": "2025-12-31T23:59:59Z"
}
```

### Агентские сервисы

#### Запрос к культурному агенту
```http
POST /agents/cultural/analyze
Content-Type: application/json
Authorization: Bearer <access_token>

{
  "text": "Проанализируйте культурный контекст этого текста на русском языке",
  "language": "ru",
  "context": {
    "domain": "literature",
    "time_period": "contemporary",
    "region": "russia"
  },
  "options": {
    "include_sentiment": true,
    "include_cultural_refs": true,
    "include_historical_context": false
  }
}
```

**Ответ:**
```json
{
  "analysis_id": "cultural_123e4567-e89b-12d3-a456-426614174000",
  "status": "processing",
  "estimated_completion": "00:00:15"
}
```

#### Получение результатов анализа культурного агента
```http
GET /agents/cultural/analyze/{analysis_id}
Authorization: Bearer <access_token>
```

**Ответ:**
```json
{
  "analysis_id": "cultural_123e4567-e89b-12d3-a456-426614174000",
  "status": "completed",
  "result": {
    "sentiment": {
      "overall": "neutral",
      "confidence": 0.78,
      "breakdown": {
        "positive": 0.3,
        "negative": 0.2,
        "neutral": 0.5
      }
    },
    "cultural_context": {
      "references": [
        {
          "type": "literary",
          "text": "русский язык",
          "significance": "high",
          "explanation": "Упоминание русского языка указывает на культурную идентичность"
        }
      ],
      "cultural_markers": ["современная_литература", "русский_контекст"]
    },
    "language_analysis": {
      "primary_language": "ru",
      "confidence": 0.95,
      "dialect": "standard_russian"
    }
  },
  "processing_time": "00:00:12",
  "created_at": "2025-01-01T00:00:00Z",
  "completed_at": "2025-01-01T00:00:12Z"
}
```

### Платежи

#### Создание платежа (Stripe)
```http
POST /payments/stripe/create
Content-Type: application/json
Authorization: Bearer <access_token>

{
  "amount": 999,
  "currency": "usd",
  "description": "Квантовые вычисления - 1 час",
  "payment_method_id": "pm_1234567890abcdef",
  "metadata": {
    "user_id": "123e4567-e89b-12d3-a456-426614174000",
    "service": "quantum_compute",
    "duration": "1h"
  }
}
```

**Ответ:**
```json
{
  "payment_id": "pi_1234567890abcdef",
  "client_secret": "pi_1234567890abcdef_secret_abcdef1234567890",
  "status": "requires_confirmation",
  "amount": 999,
  "currency": "usd",
  "created_at": "2025-01-01T00:00:00Z"
}
```

#### Создание платежа (Криптовалюта)
```http
POST /payments/crypto/create
Content-Type: application/json
Authorization: Bearer <access_token>

{
  "amount": 0.001,
  "currency": "BTC",
  "description": "Квантовые вычисления - 1 час",
  "wallet_address": "bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh",
  "metadata": {
    "user_id": "123e4567-e89b-12d3-a456-426614174000",
    "service": "quantum_compute"
  }
}
```

**Ответ:**
```json
{
  "payment_id": "crypto_123e4567-e89b-12d3-a456-426614174000",
  "status": "pending",
  "amount": 0.001,
  "currency": "BTC",
  "required_confirmations": 3,
  "payment_address": "bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh",
  "created_at": "2025-01-01T00:00:00Z"
}
```

## Внутренние API

### Метрики и мониторинг

#### Получение метрик Prometheus
```http
GET /metrics
```

**Ответ:**
```text
# HELP http_requests_total Total number of HTTP requests
# TYPE http_requests_total counter
http_requests_total{method="GET",path="/health",status="200"} 1500

# HELP http_request_duration_seconds HTTP request duration in seconds
# TYPE http_request_duration_seconds histogram
http_request_duration_seconds_bucket{le="0.1"} 1000
http_request_duration_seconds_bucket{le="0.5"} 1400
http_request_duration_seconds_bucket{le="1.0"} 1450
```

#### Health check эндпоинты

```http
GET /health
```

**Ответ:**
```json
{
  "status": "healthy",
  "timestamp": "2025-01-01T00:00:00Z",
  "version": "v2.0.0",
  "uptime": "72h30m15s",
  "components": {
    "database": "healthy",
    "redis": "healthy",
    "quantum_services": "healthy",
    "agents": "healthy"
  }
}
```

#### Readiness check
```http
GET /ready
```

**Ответ:**
```json
{
  "status": "ready",
  "checks": {
    "database_connection": true,
    "redis_connection": true,
    "quantum_hardware": true,
    "agent_services": true
  }
}
```

### Администрирование

#### Управление пользователями
```http
GET /admin/users
Authorization: Bearer <admin_token>
```

**Ответ:**
```json
{
  "users": [
    {
      "id": "123e4567-e89b-12d3-a456-426614174000",
      "email": "user@example.com",
      "role": "user",
      "status": "active",
      "created_at": "2025-01-01T00:00:00Z",
      "last_login": "2025-01-01T12:00:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "per_page": 50,
    "total": 150
  }
}
```

#### Управление квантовыми ресурсами
```http
GET /admin/quantum/resources
Authorization: Bearer <admin_token>
```

**Ответ:**
```json
{
  "resources": [
    {
      "id": "quantum_001",
      "type": "ibm_quantum",
      "status": "online",
      "qubits": 16,
      "queue_length": 3,
      "last_calibration": "2025-01-01T00:00:00Z",
      "location": "us-east-1"
    },
    {
      "id": "quantum_002",
      "type": "rigetti_aspen",
      "status": "maintenance",
      "qubits": 32,
      "queue_length": 0,
      "last_calibration": "2024-12-31T18:00:00Z",
      "location": "k3s-moscow"
    }
  ]
}
```

## Webhook API

### Квантовые вычисления webhook

#### Уведомление о завершении вычисления
```http
POST /webhooks/quantum/completion
X-Signature: sha256=abcdef123456...
Content-Type: application/json

{
  "computation_id": "quantum_123e4567-e89b-12d3-a456-426614174000",
  "status": "completed",
  "result": {
    "factors": [5, 7],
    "probability": 0.85
  },
  "metadata": {
    "execution_time": "00:04:23",
    "qubits_used": 16
  }
}
```

### Платежи webhook

#### Stripe webhook события
```http
POST /webhooks/payments/stripe
Stripe-Signature: t=1234567890,v1=abcdef123456...
Content-Type: application/json

{
  "id": "evt_1234567890abcdef",
  "object": "event",
  "type": "payment_intent.succeeded",
  "data": {
    "object": {
      "id": "pi_1234567890abcdef",
      "amount": 999,
      "currency": "usd",
      "status": "succeeded"
    }
  }
}
```

## API квот и ограничений

### Rate Limiting

| Тип пользователя | Запросов в минуту | Запросов в час |
|------------------|------------------|----------------|
| Бесплатный | 60 | 1000 |
| Базовый | 300 | 10000 |
| Профессиональный | 1000 | 100000 |
| Корпоративный | Без ограничений | Без ограничений |

### Квоты квантовых вычислений

| Тип пользователя | Часов в месяц | Максимум кубитов |
|------------------|---------------|------------------|
| Бесплатный | 1 | 5 |
| Базовый | 10 | 16 |
| Профессиональный | 100 | 32 |
| Корпоративный | Без ограничений | 128 |

## SDK и библиотеки

### Python SDK

```python
from x0tta6bl4 import X0tta6bl4Client

client = X0tta6bl4Client(api_key="your_api_key")

# Аутентификация
auth_result = client.auth.login("user@example.com", "password")

# Квантовое вычисление
result = client.quantum.compute(
    algorithm="shor",
    parameters={"qubits": 16, "shots": 1024},
    data={"input_value": "15", "modulus": "35"}
)

print(f"Factors: {result['factors']}")
```

### JavaScript SDK

```javascript
import { X0tta6bl4Client } from '@x0tta6bl4/sdk';

const client = new X0tta6bl4Client({
  apiKey: 'your_api_key'
});

// Аутентификация
const authResult = await client.auth.login({
  email: 'user@example.com',
  password: 'password'
});

// Квантовое вычисление
const result = await client.quantum.compute({
  algorithm: 'shor',
  parameters: { qubits: 16, shots: 1024 },
  data: { input_value: '15', modulus: '35' }
});

console.log(`Factors: ${result.factors}`);
```

## Контакты поддержки API

- **Документация**: https://docs.x0tta6bl4.com/api
- **Поддержка разработчиков**: developers@x0tta6bl4.com
- **Статус API**: https://status.x0tta6bl4.com
- **Чат сообщества**: #api-discussion (Discord)

## Версии API

| Версия | Статус | Дата релиза | Дата устаревания |
|--------|--------|-------------|------------------|
| v1 | Активная | 2024-01-01 | Не планируется |
| v2 | Активная | 2025-01-01 | Не планируется |
| v3 | В разработке | 2025-06-01 | - |

## Изменения в API

Все изменения API документируются в changelog:

- **Breaking changes**: Минимум 90 дней уведомления
- **New features**: Документируются за 30 дней
- **Bug fixes**: Применяются немедленно

Этот документ обновляется при изменении API или добавлении новых эндпоинтов. Последнее обновление: 2025-09-30.