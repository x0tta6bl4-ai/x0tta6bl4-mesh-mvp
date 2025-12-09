# API Reference - x0tta6bl4

## Обзор

x0tta6bl4 предоставляет RESTful API для взаимодействия с децентрализованной платформой защиты цифровых прав. API поддерживает OAuth 2.0 аутентификацию, Post-Quantum Cryptography и обеспечивает высокую доступность через mesh-сети.

## Базовая информация

- **Base URL**: `https://api.x0tta6bl4.com`
- **API Version**: v1
- **Protocol**: HTTPS/TLS 1.3
- **Authentication**: OAuth 2.0 Bearer Token
- **Content-Type**: `application/json`
- **Rate Limiting**: 1000 requests/minute per client

## Аутентификация

### OAuth 2.0 Flow

```http
POST /oauth/authorize
Content-Type: application/x-www-form-urlencoded

client_id=web-app&redirect_uri=https://app.x0tta6bl4.com/callback&response_type=code&scope=openid profile api:read api:write&state=random_state
```

### Получение токена

```http
POST /oauth/token
Content-Type: application/x-www-form-urlencoded

grant_type=authorization_code&code=AUTH_CODE&redirect_uri=https://app.x0tta6bl4.com/callback&client_id=web-app&client_secret=web-app-secret
```

**Response**:
```json
{
  "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "refresh_token": "refresh_token_here",
  "scope": "openid profile api:read api:write"
}
```

### Использование токена

```http
GET /api/v1/user/profile
Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
```

## Endpoints

### 1. User Management

#### Получить профиль пользователя

```http
GET /api/v1/user/profile
```

**Response**:
```json
{
  "sub": "user-123",
  "username": "john_doe",
  "email": "john@example.com",
  "roles": ["user", "premium"],
  "groups": ["engineering"],
  "created_at": "2025-01-01T00:00:00Z",
  "last_login": "2025-01-15T10:30:00Z",
  "preferences": {
    "language": "en",
    "timezone": "UTC",
    "notifications": true
  }
}
```

#### Обновить профиль

```http
PUT /api/v1/user/profile
Content-Type: application/json

{
  "email": "newemail@example.com",
  "preferences": {
    "language": "ru",
    "timezone": "Europe/Moscow"
  }
}
```

### 2. Mesh Network Management

#### Получить статус mesh-сети

```http
GET /api/v1/mesh/status
```

**Response**:
```json
{
  "cluster_id": "x0tta6bl4-global",
  "nodes": [
    {
      "node_id": "node-001",
      "status": "active",
      "last_seen": "2025-01-15T10:30:00Z",
      "latency_ms": 45,
      "packet_loss_percent": 0.1,
      "connections": 12
    }
  ],
  "total_nodes": 25,
  "active_nodes": 24,
  "network_health": 0.96,
  "routing_protocol": "BATMAN-adv",
  "encryption": "AES-256-GCM"
}
```

#### Получить маршруты

```http
GET /api/v1/mesh/routes?source=node-001&destination=node-015
```

**Response**:
```json
{
  "routes": [
    {
      "path": ["node-001", "node-005", "node-012", "node-015"],
      "latency_ms": 67,
      "reliability": 0.98,
      "encryption": "mTLS"
    },
    {
      "path": ["node-001", "node-003", "node-008", "node-015"],
      "latency_ms": 89,
      "reliability": 0.95,
      "encryption": "mTLS"
    }
  ],
  "best_route": 0,
  "alternative_routes": 1
}
```

### 3. Quantum Services

#### Квантовое шифрование

```http
POST /api/v1/quantum/encrypt
Content-Type: application/json

{
  "data": "Hello, Quantum World!",
  "algorithm": "Kyber1024",
  "recipient_public_key": "base64_encoded_public_key"
}
```

**Response**:
```json
{
  "encrypted_data": "base64_encoded_encrypted_data",
  "kem_ciphertext": "base64_encoded_kem_ciphertext",
  "algorithm": "Kyber1024",
  "timestamp": "2025-01-15T10:30:00Z"
}
```

#### Квантовая подпись

```http
POST /api/v1/quantum/sign
Content-Type: application/json

{
  "message": "Important document",
  "algorithm": "Dilithium5",
  "private_key_id": "key-123"
}
```

**Response**:
```json
{
  "signature": "base64_encoded_signature",
  "algorithm": "Dilithium5",
  "public_key": "base64_encoded_public_key",
  "timestamp": "2025-01-15T10:30:00Z"
}
```

### 4. AI/ML Services

#### Анализ аномалий

```http
POST /api/v1/ai/anomaly-detection
Content-Type: application/json

{
  "data": [
    {"timestamp": "2025-01-15T10:00:00Z", "cpu_usage": 45.2, "memory_usage": 67.8},
    {"timestamp": "2025-01-15T10:01:00Z", "cpu_usage": 89.1, "memory_usage": 78.3}
  ],
  "model": "isolation_forest",
  "threshold": 0.1
}
```

**Response**:
```json
{
  "anomalies": [
    {
      "index": 1,
      "score": 0.85,
      "severity": "high",
      "description": "CPU usage spike detected"
    }
  ],
  "model_used": "isolation_forest",
  "confidence": 0.92,
  "processing_time_ms": 45
}
```

#### Предиктивное обслуживание

```http
GET /api/v1/ai/predictive-maintenance?component=api-gateway&horizon=24h
```

**Response**:
```json
{
  "component": "api-gateway",
  "predictions": [
    {
      "timestamp": "2025-01-16T10:00:00Z",
      "failure_probability": 0.15,
      "recommended_action": "monitor",
      "confidence": 0.78
    }
  ],
  "model_version": "v2.1",
  "last_training": "2025-01-14T00:00:00Z"
}
```

### 5. Self-Healing

#### Статус MAPE-K цикла

```http
GET /api/v1/self-healing/mape-k/status
```

**Response**:
```json
{
  "current_state": "MONITOR",
  "cycle_count": 1247,
  "last_anomaly": "2025-01-15T09:45:00Z",
  "recovery_time_avg_ms": 3200,
  "success_rate": 0.96,
  "active_strategies": [
    {
      "strategy_id": "conservative_scaling",
      "performance_score": 0.87,
      "usage_count": 156
    }
  ]
}
```

#### Принудительное восстановление

```http
POST /api/v1/self-healing/recovery/trigger
Content-Type: application/json

{
  "component": "api-gateway",
  "issue_type": "high_latency",
  "severity": "medium",
  "auto_recovery": true
}
```

**Response**:
```json
{
  "recovery_id": "rec-12345",
  "status": "initiated",
  "estimated_duration_ms": 5000,
  "strategy": "conservative_scaling",
  "monitoring_url": "/api/v1/self-healing/recovery/rec-12345/status"
}
```

### 6. DAO Governance

#### Получить предложения

```http
GET /api/v1/dao/proposals?status=active&limit=10
```

**Response**:
```json
{
  "proposals": [
    {
      "id": "prop-001",
      "title": "Increase API rate limits",
      "description": "Proposal to increase rate limits from 1000 to 2000 requests per minute",
      "status": "active",
      "votes_for": 1250,
      "votes_against": 340,
      "quorum": 0.67,
      "deadline": "2025-01-20T00:00:00Z",
      "creator": "user-456"
    }
  ],
  "total": 1,
  "has_more": false
}
```

#### Голосование

```http
POST /api/v1/dao/vote
Content-Type: application/json

{
  "proposal_id": "prop-001",
  "vote": "for",
  "tokens": 100,
  "signature": "base64_encoded_signature"
}
```

**Response**:
```json
{
  "vote_id": "vote-789",
  "status": "recorded",
  "weight": 10,
  "timestamp": "2025-01-15T10:30:00Z"
}
```

### 7. Monitoring & Metrics

#### Получить метрики

```http
GET /api/v1/metrics?metric=mttr&period=1h&granularity=5m
```

**Response**:
```json
{
  "metric": "mttr",
  "period": "1h",
  "granularity": "5m",
  "data": [
    {
      "timestamp": "2025-01-15T10:00:00Z",
      "value": 3.2,
      "unit": "seconds"
    },
    {
      "timestamp": "2025-01-15T10:05:00Z",
      "value": 2.8,
      "unit": "seconds"
    }
  ],
  "statistics": {
    "min": 2.1,
    "max": 4.3,
    "avg": 3.1,
    "p95": 4.1,
    "p99": 4.3
  }
}
```

#### Health Check

```http
GET /api/v1/health
```

**Response**:
```json
{
  "status": "healthy",
  "timestamp": "2025-01-15T10:30:00Z",
  "version": "v1.2.3",
  "components": {
    "database": "healthy",
    "mesh_network": "healthy",
    "quantum_services": "healthy",
    "ai_services": "healthy",
    "self_healing": "healthy"
  },
  "metrics": {
    "uptime_seconds": 86400,
    "requests_total": 1250000,
    "error_rate": 0.001
  }
}
```

## Error Handling

### Стандартные коды ошибок

| Code | Description |
|------|-------------|
| 400 | Bad Request - Неверные параметры |
| 401 | Unauthorized - Требуется аутентификация |
| 403 | Forbidden - Недостаточно прав |
| 404 | Not Found - Ресурс не найден |
| 429 | Too Many Requests - Превышен лимит запросов |
| 500 | Internal Server Error - Внутренняя ошибка сервера |
| 503 | Service Unavailable - Сервис недоступен |

### Формат ошибки

```json
{
  "error": {
    "code": "INVALID_PARAMETER",
    "message": "The 'algorithm' parameter must be one of: Kyber1024, Dilithium5",
    "details": {
      "parameter": "algorithm",
      "value": "RSA2048",
      "allowed_values": ["Kyber1024", "Dilithium5"]
    },
    "timestamp": "2025-01-15T10:30:00Z",
    "request_id": "req-12345"
  }
}
```

## Rate Limiting

### Лимиты по типам клиентов

| Client Type | Requests/minute | Burst |
|-------------|-----------------|-------|
| Web App | 1000 | 100 |
| Mobile App | 500 | 50 |
| API Gateway | 10000 | 1000 |
| Internal Service | 5000 | 500 |

### Headers

```http
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1642248600
X-RateLimit-Retry-After: 60
```

## Webhooks

### Подписка на события

```http
POST /api/v1/webhooks/subscribe
Content-Type: application/json

{
  "url": "https://your-app.com/webhook",
  "events": ["anomaly.detected", "recovery.completed"],
  "secret": "webhook_secret"
}
```

### Формат webhook payload

```json
{
  "event": "anomaly.detected",
  "timestamp": "2025-01-15T10:30:00Z",
  "data": {
    "component": "api-gateway",
    "severity": "high",
    "score": 0.85,
    "description": "CPU usage spike detected"
  },
  "signature": "sha256=abc123..."
}
```

## SDK и библиотеки

### Python SDK

```python
from x0tta6bl4 import Client

client = Client(
    base_url="https://api.x0tta6bl4.com",
    access_token="your_token"
)

# Получить статус mesh-сети
status = client.mesh.get_status()

# Квантовое шифрование
encrypted = client.quantum.encrypt(
    data="Hello, World!",
    algorithm="Kyber1024",
    recipient_public_key="public_key"
)

# Анализ аномалий
anomalies = client.ai.detect_anomalies(
    data=metrics_data,
    model="isolation_forest"
)
```

### JavaScript SDK

```javascript
import { X0tta6bl4Client } from '@x0tta6bl4/sdk';

const client = new X0tta6bl4Client({
  baseUrl: 'https://api.x0tta6bl4.com',
  accessToken: 'your_token'
});

// Получить профиль пользователя
const profile = await client.user.getProfile();

// Голосование в DAO
const vote = await client.dao.vote({
  proposalId: 'prop-001',
  vote: 'for',
  tokens: 100
});
```

## Примеры использования

### Полный цикл: от аутентификации до квантового шифрования

```bash
# 1. Получение токена
TOKEN=$(curl -s -X POST https://api.x0tta6bl4.com/oauth/token \
  -d "grant_type=client_credentials&client_id=api-gateway&client_secret=secret" \
  | jq -r '.access_token')

# 2. Получение статуса системы
curl -H "Authorization: Bearer $TOKEN" \
  https://api.x0tta6bl4.com/api/v1/health

# 3. Квантовое шифрование
curl -X POST https://api.x0tta6bl4.com/api/v1/quantum/encrypt \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "data": "Sensitive information",
    "algorithm": "Kyber1024",
    "recipient_public_key": "public_key_here"
  }'
```

### Мониторинг и алерты

```python
import time
from x0tta6bl4 import Client

client = Client(access_token="your_token")

def monitor_system():
    while True:
        # Проверка здоровья системы
        health = client.health.get()
        
        if health['status'] != 'healthy':
            # Отправка алерта
            client.alerts.send({
                'severity': 'critical',
                'message': f"System health: {health['status']}",
                'components': health['components']
            })
        
        # Проверка метрик
        mttr = client.metrics.get('mttr', period='5m')
        if mttr['statistics']['p95'] > 5.0:
            client.alerts.send({
                'severity': 'warning',
                'message': f"MTTR p95 exceeded: {mttr['statistics']['p95']}s"
            })
        
        time.sleep(60)

monitor_system()
```

## Changelog

### v1.2.3 (2025-01-15)
- Добавлена поддержка Dilithium5 подписей
- Улучшена производительность anomaly detection
- Добавлены webhooks для real-time уведомлений

### v1.2.2 (2025-01-10)
- Исправлена ошибка в MAPE-K статусе
- Добавлена поддержка batch операций
- Улучшена документация

### v1.2.1 (2025-01-05)
- Добавлена поддержка Kyber1024
- Улучшена обработка ошибок
- Добавлены rate limiting headers

## Поддержка

- **Documentation**: https://docs.x0tta6bl4.com
- **GitHub**: https://github.com/x0tta6bl4/api
- **Discord**: https://discord.gg/x0tta6bl4
- **Email**: api-support@x0tta6bl4.com