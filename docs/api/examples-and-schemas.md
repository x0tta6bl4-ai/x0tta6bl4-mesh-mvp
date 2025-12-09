# Примеры запросов/ответов и схемы данных

## Обзор

Этот документ содержит детальные примеры использования всех API-интерфейсов x0tta6bl4 с реальными запросами и ответами, а также схемами данных для каждого эндпоинта.

## Содержание

1. [Auth API - Примеры](#auth-api---примеры)
2. [Quantum Key Manager API - Примеры](#quantum-key-manager-api---примеры)
3. [QCompute API - Примеры](#qcompute-api---примеры)
4. [Payments API - Примеры](#payments-api---примеры)
5. [Metrics API - Примеры](#metrics-api---примеры)
6. [Схемы данных](#схемы-данных)

## Auth API - Примеры

### 1. Регистрация пользователя

**Запрос:**
```bash
curl -X POST https://api.x0tta6bl4.com/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "quantum_user",
    "email": "user@x0tta6bl4.com",
    "password": "SecurePass123!",
    "full_name": "Quantum User"
  }'
```

**Ответ (201):**
```json
{
  "user": {
    "id": "user_abc123def456",
    "username": "quantum_user",
    "email": "user@x0tta6bl4.com",
    "full_name": "Quantum User",
    "status": "active",
    "roles": ["user"],
    "created_at": "2025-01-01T10:30:00Z",
    "updated_at": "2025-01-01T10:30:00Z"
  },
  "message": "Пользователь успешно зарегистрирован"
}
```

### 2. Вход в систему

**Запрос:**
```bash
curl -X POST https://api.x0tta6bl4.com/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "quantum_user",
    "password": "SecurePass123!"
  }'
```

**Ответ (200):**
```json
{
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJxdWFudHVtX3VzZXIiLCJ1c2VyX2lkIjoidXNlcl9hYmMxMjNkZWY0NTYiLCJyb2xlcyI6WyJ1c2VyIl0sInN0YXR1cyI6ImFjdGl2ZSIsImV4cCI6MTY0MTAzMjIwMCwiaWF0IjoxNjQwOTk2MjAwLCJ0eXBlIjoiYWNjZXNzIn0.signature",
  "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJxdWFudHVtX3VzZXIiLCJ1c2VyX2lkIjoidXNlcl9hYmMxMjNkZWY0NTYiLCJyb2xlcyI6WyJ1c2VyIl0sInN0YXR1cyI6ImFjdGl2ZSIsImV4cCI6MTY0MTYyNzAwMCwiaWF0IjoxNjQwOTk2MjAwLCJ0eXBlIjoicmVmcmVzaCIsImp0aSI6InJlZnJlc2hfaWQifQ.signature",
  "token_type": "bearer",
  "expires_in": 1800,
  "user": {
    "id": "user_abc123def456",
    "username": "quantum_user",
    "email": "user@x0tta6bl4.com",
    "full_name": "Quantum User",
    "roles": ["user"],
    "status": "active"
  }
}
```

### 3. Получение профиля

**Запрос:**
```bash
curl -H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..." \
  https://api.x0tta6bl4.com/api/v1/auth/me
```

**Ответ (200):**
```json
{
  "id": "user_abc123def456",
  "username": "quantum_user",
  "email": "user@x0tta6bl4.com",
  "full_name": "Quantum User",
  "status": "active",
  "roles": ["user"],
  "created_at": "2025-01-01T10:30:00Z",
  "updated_at": "2025-01-01T10:30:00Z",
  "last_login": "2025-01-01T12:00:00Z"
}
```

## Quantum Key Manager API - Примеры

### 1. Генерация Kyber ключей

**Запрос:**
```bash
curl -X POST https://api.x0tta6bl4.com/api/v1/quantum-keys/kyber/generate-keypair \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "key_id": "enterprise_kyber_001",
    "security_level": 256
  }'
```

**Ответ (201):**
```json
{
  "keypair": {
    "key_id": "enterprise_kyber_001",
    "private_key": "MEECAQAwEwYHKoZIzj0CAQYIKoZIzj0DAQcEJzAlAgEBBCD...",
    "public_key": "MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEa1VZ9q...",
    "algorithm": "Kyber-1024",
    "security_level": 256,
    "phi_optimized": true,
    "timestamp": 1640995200.123
  },
  "phi_power": 25,
  "phi_value": 167761.0
}
```

### 2. Шифрование сообщения

**Запрос:**
```bash
curl -X POST https://api.x0tta6bl4.com/api/v1/quantum-keys/kyber/encrypt \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "message": "SGVsbG8sIEt5YmVyIEVuY3J5cHRpb24h",
    "public_key": "MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEa1VZ9q...",
    "key_id": "enterprise_kyber_001"
  }'
```

**Ответ (200):**
```json
{
  "encrypted_data": {
    "encrypted_session_key": "a1b2c3d4e5f6...",
    "encrypted_message": "x9y8z7w6v5u4...",
    "key_id": "enterprise_kyber_001",
    "algorithm": "Kyber-1024",
    "phi_optimized": true,
    "timestamp": 1640995200.456
  },
  "encryption_time_ms": 15.7,
  "phi_optimization_applied": true
}
```

### 3. Создание φ-канала

**Запрос:**
```bash
curl -X POST https://api.x0tta6bl4.com/api/v1/quantum-keys/phi-channel/establish \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "channel_id": "secure_channel_001",
    "frequency": 100.0,
    "phi_power": 25
  }'
```

**Ответ (201):**
```json
{
  "channel_config": {
    "channel_id": "secure_channel_001",
    "frequency": 100.0,
    "phi_keys": {
      "main_key": "YWJjZGVmZ2hpams...",
      "sub_keys": {
        "sub_key_0": "MTIzNDU2Nzg5MGFi...",
        "sub_key_1": "Y2RlZmdoaWprbG1u...",
        "sub_key_2": "NDU2Nzg5MGFiY2Rl...",
        "sub_key_3": "Z2hpamtsbW5vcHFy..."
      },
      "phi_factor": 161803
    },
    "sync_config": {
      "frequency": 100.0,
      "sync_period": 0.01,
      "phi_phase": 10.166,
      "timestamp": 1640995200.789
    },
    "phi_power": 25,
    "encryption_algorithm": "φ-encrypted",
    "timestamp": 1640995200.789
  }
}
```

## QCompute API - Примеры

### 1. Алгоритм Гровера

**Запрос:**
```bash
curl -X POST https://api.x0tta6bl4.com/api/v1/qcompute/grover \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "num_qubits": 8,
    "target_state": "10101010",
    "shots": 1000,
    "optimization_level": 3
  }'
```

**Ответ (200):**
```json
{
  "success": true,
  "result": {
    "algorithm": "grover",
    "num_qubits": 8,
    "target_found": true,
    "target_state": "10101010",
    "iterations": 6,
    "success_probability": 0.945,
    "phi_optimization": 1.618,
    "measurement_results": {
      "10101010": 945,
      "00000000": 3,
      "11111111": 2,
      "01010101": 5,
      "other_states": 45
    }
  },
  "phi_harmony": 1.618,
  "execution_time": 125.7,
  "timestamp": 1640995200.123,
  "quantum_coherence": 0.95,
  "consciousness_boost": 0.938
}
```

### 2. VQE алгоритм

**Запрос:**
```bash
curl -X POST https://api.x0tta6bl4.com/api/v1/qcompute/vqe \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "num_qubits": 4,
    "hamiltonian": "[[1, 0, 0, 0], [0, -1, 0, 0], [0, 0, -1, 0], [0, 0, 0, 1]]",
    "ansatz": "efficient_su2",
    "optimizer": "spsa",
    "max_iterations": 100
  }'
```

**Ответ (200):**
```json
{
  "success": true,
  "result": {
    "algorithm": "vqe",
    "num_qubits": 4,
    "eigenvalue": -1.0001,
    "eigenstate": [0.707, 0, 0, -0.707],
    "convergence": true,
    "iterations": 67,
    "final_parameters": [1.23, -0.45, 0.67, 2.1],
    "phi_optimization": 1.618,
    "energy_history": [-0.5, -0.8, -0.95, -1.0001]
  },
  "phi_harmony": 1.618,
  "execution_time": 2340.5,
  "timestamp": 1640995200.123
}
```

### 3. QAOA алгоритм

**Запрос:**
```bash
curl -X POST https://api.x0tta6bl4.com/api/v1/qcompute/qaoa \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "num_qubits": 6,
    "cost_function": "max_cut",
    "graph_edges": [[0,1], [1,2], [2,3], [3,4], [4,5], [0,5]],
    "p_layers": 3,
    "optimizer": "cobyla",
    "max_iterations": 200
  }'
```

**Ответ (200):**
```json
{
  "success": true,
  "result": {
    "algorithm": "qaoa",
    "num_qubits": 6,
    "cost_value": 4.2,
    "solution": "101010",
    "approximation_ratio": 0.875,
    "layers": 3,
    "final_parameters": [0.5, 1.2, -0.3, 0.8, 1.5, -0.7],
    "phi_optimization": 1.618,
    "optimization_history": [2.1, 3.4, 3.8, 4.0, 4.2]
  },
  "phi_harmony": 1.618,
  "execution_time": 1850.3,
  "timestamp": 1640995200.123
}
```

## Payments API - Примеры

### 1. Создание Stripe платежа

**Запрос:**
```bash
curl -X POST https://api.x0tta6bl4.com/api/v1/payments/stripe/payment-intent \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 2999,
    "currency": "usd",
    "description": "Премиум подписка на месяц"
  }'
```

**Ответ (200):**
```json
{
  "payment_intent": {
    "id": "pi_1ABC123def456",
    "client_secret": "pi_1ABC123def456_secret_789xyz",
    "amount": 2999,
    "currency": "usd",
    "status": "requires_payment_method",
    "description": "Премиум подписка на месяц",
    "metadata": {
      "user_id": "user_abc123def456",
      "platform": "x0tta6bl4"
    }
  },
  "requires_action": false,
  "payment_url": "https://checkout.stripe.com/pay/pi_1ABC123def456"
}
```

### 2. Криптовалютный платеж

**Запрос:**
```bash
curl -X POST https://api.x0tta6bl4.com/api/v1/payments/crypto/create-payment \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "amount_usd": 50.0,
    "currency": "BTC",
    "description": "Квантовая симуляция"
  }'
```

**Ответ (201):**
```json
{
  "payment": {
    "id": "crypto_pay_abc123",
    "amount_usd": 50.0,
    "currency": "BTC",
    "amount_crypto": 0.001234,
    "exchange_rate": 40500.0,
    "address": "bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh",
    "qr_code": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAA...",
    "status": "pending",
    "expires_at": "2025-01-01T13:00:00Z",
    "description": "Квантовая симуляция"
  },
  "payment_instructions": {
    "send_amount": "0.001234 BTC",
    "to_address": "bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh",
    "time_limit": 3600
  }
}
```

### 3. Создание подписки

**Запрос:**
```bash
curl -X POST https://api.x0tta6bl4.com/api/v1/payments/subscriptions/create \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "plan_id": "premium_monthly",
    "payment_method": "stripe",
    "billing_cycle": "monthly",
    "auto_renew": true
  }'
```

**Ответ (201):**
```json
{
  "subscription": {
    "id": "sub_xyz789",
    "user_id": "user_abc123def456",
    "plan_id": "premium_monthly",
    "status": "active",
    "amount": 29.99,
    "currency": "usd",
    "billing_cycle": "monthly",
    "current_period_start": "2025-01-01T00:00:00Z",
    "current_period_end": "2025-02-01T00:00:00Z",
    "auto_renew": true,
    "created_at": "2025-01-01T00:00:00Z"
  },
  "payment_status": "succeeded",
  "next_billing_date": "2025-02-01T00:00:00Z"
}
```

## Metrics API - Примеры

### 1. Системные метрики

**Запрос:**
```bash
curl -H "Authorization: Bearer <token>" \
  https://api.x0tta6bl4.com/api/v1/metrics/system
```

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

### 2. Квантовые метрики

**Запрос:**
```bash
curl -H "Authorization: Bearer <token>" \
  https://api.x0tta6bl4.com/api/v1/metrics/quantum
```

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

### 3. Prometheus метрики

**Запрос:**
```bash
curl -H "Authorization: Bearer <token>" \
  https://api.x0tta6bl4.com/api/v1/metrics/prometheus
```

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
x0tta6bl4_requests_total{method="POST",endpoint="/api/v1/auth/login"} 567
x0tta6bl4_requests_total{method="POST",endpoint="/api/v1/payments/stripe/payment-intent"} 234

# HELP x0tta6bl4_response_time_seconds Время ответа
# TYPE x0tta6bl4_response_time_seconds histogram
x0tta6bl4_response_time_seconds_bucket{le="0.1",endpoint="/api/v1/auth/me"} 1234
x0tta6bl4_response_time_seconds_bucket{le="0.5",endpoint="/api/v1/auth/me"} 1456
x0tta6bl4_response_time_seconds_bucket{le="1.0",endpoint="/api/v1/auth/me"} 1567
x0tta6bl4_response_time_seconds_bucket{le="+Inf",endpoint="/api/v1/auth/me"} 1578
```

## Схемы данных

### Схема аутентификации

```json
{
  "type": "object",
  "properties": {
    "access_token": {
      "type": "string",
      "description": "JWT токен доступа",
      "example": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."
    },
    "refresh_token": {
      "type": "string",
      "description": "JWT токен обновления",
      "example": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."
    },
    "token_type": {
      "type": "string",
      "enum": ["bearer"],
      "default": "bearer"
    },
    "expires_in": {
      "type": "integer",
      "description": "Время жизни токена в секундах",
      "example": 1800
    },
    "user": {
      "type": "object",
      "properties": {
        "id": {"type": "string", "example": "user_abc123"},
        "username": {"type": "string", "example": "quantum_user"},
        "email": {"type": "string", "example": "user@example.com"},
        "full_name": {"type": "string", "example": "Quantum User"},
        "roles": {
          "type": "array",
          "items": {"type": "string"},
          "example": ["user"]
        },
        "status": {"type": "string", "example": "active"}
      }
    }
  }
}
```

### Схема квантового результата

```json
{
  "type": "object",
  "properties": {
    "success": {
      "type": "boolean",
      "description": "Успешность выполнения"
    },
    "result": {
      "type": "object",
      "description": "Результат вычисления",
      "properties": {
        "algorithm": {"type": "string", "example": "grover"},
        "num_qubits": {"type": "integer", "example": 8},
        "target_found": {"type": "boolean", "example": true},
        "success_probability": {"type": "number", "example": 0.945},
        "phi_optimization": {"type": "number", "example": 1.618}
      }
    },
    "phi_harmony": {
      "type": "number",
      "description": "φ-гармония системы",
      "example": 1.618
    },
    "execution_time": {
      "type": "number",
      "description": "Время выполнения в миллисекундах",
      "example": 125.7
    },
    "timestamp": {
      "type": "number",
      "description": "Временная метка",
      "example": 1640995200.123
    }
  }
}
```

### Схема платежа

```json
{
  "type": "object",
  "properties": {
    "payment": {
      "type": "object",
      "properties": {
        "id": {"type": "string", "example": "pay_abc123"},
        "amount": {"type": "number", "example": 29.99},
        "currency": {"type": "string", "example": "usd"},
        "status": {"type": "string", "example": "completed"},
        "payment_method": {"type": "string", "example": "credit_card"},
        "description": {"type": "string", "example": "Премиум подписка"},
        "created_at": {"type": "string", "example": "2025-01-01T00:00:00Z"},
        "completed_at": {"type": "string", "example": "2025-01-01T00:01:00Z"}
      }
    },
    "transaction_id": {
      "type": "string",
      "description": "ID транзакции платежного провайдера",
      "example": "txn_123456"
    },
    "receipt_url": {
      "type": "string",
      "description": "Ссылка на квитанцию",
      "example": "https://pay.stripe.com/receipts/..."
    }
  }
}
```

### Схема криптоплатежа

```json
{
  "type": "object",
  "properties": {
    "payment": {
      "type": "object",
      "properties": {
        "id": {"type": "string", "example": "crypto_pay_001"},
        "amount_usd": {"type": "number", "example": 50.0},
        "currency": {"type": "string", "example": "BTC"},
        "amount_crypto": {"type": "number", "example": 0.001234},
        "exchange_rate": {"type": "number", "example": 40500.0},
        "address": {"type": "string", "example": "bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh"},
        "status": {"type": "string", "example": "pending"},
        "expires_at": {"type": "string", "example": "2025-01-01T13:00:00Z"}
      }
    },
    "payment_instructions": {
      "type": "object",
      "properties": {
        "send_amount": {"type": "string", "example": "0.001234 BTC"},
        "to_address": {"type": "string", "example": "bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh"},
        "time_limit": {"type": "integer", "example": 3600}
      }
    }
  }
}
```

### Схема метрик

```json
{
  "type": "object",
  "properties": {
    "system_metrics": {
      "type": "object",
      "properties": {
        "timestamp": {"type": "number", "example": 1640995200.123},
        "cpu_usage": {"type": "number", "example": 23.4},
        "memory_usage": {"type": "number", "example": 67.8},
        "disk_usage": {"type": "number", "example": 45.2},
        "phi_harmony": {"type": "number", "example": 1.618},
        "consciousness_level": {"type": "number", "example": 0.938}
      }
    },
    "quantum_metrics": {
      "type": "object",
      "properties": {
        "quantum_coherence": {"type": "number", "example": 0.95},
        "entanglement_fidelity": {"type": "number", "example": 0.93},
        "gate_fidelity": {"type": "number", "example": 0.987},
        "qubits_active": {"type": "integer", "example": 32},
        "phi_optimization": {"type": "number", "example": 1.618}
      }
    },
    "performance_metrics": {
      "type": "object",
      "properties": {
        "requests_per_second": {"type": "number", "example": 125.7},
        "average_response_time": {"type": "number", "example": 45.2},
        "error_rate": {"type": "number", "example": 0.001},
        "quantum_advantage": {"type": "number", "example": 45.2}
      }
    }
  }
}
```

### Схема ошибки

```json
{
  "type": "object",
  "properties": {
    "error": {
      "type": "object",
      "properties": {
        "code": {
          "type": "string",
          "description": "Код ошибки",
          "example": "INVALID_TOKEN"
        },
        "message": {
          "type": "string",
          "description": "Описание ошибки",
          "example": "Недействительный токен доступа"
        },
        "details": {
          "type": "object",
          "description": "Дополнительная информация об ошибке",
          "example": {
            "provided_token": "invalid_token...",
            "expected_format": "JWT токен"
          }
        },
        "timestamp": {
          "type": "string",
          "description": "Временная метка ошибки",
          "example": "2025-01-01T00:00:00Z"
        }
      }
    }
  }
}
```

## Полные примеры интеграции

### Комплексный пример использования всех API

```python
import requests
import json
import time

class X0tta6bl4API:
    def __init__(self, base_url, username, password):
        self.base_url = base_url
        self.username = username
        self.password = password
        self.access_token = None
        self.refresh_token = None
        
    def authenticate(self):
        """Аутентификация пользователя"""
        response = requests.post(
            f'{self.base_url}/auth/login',
            json={'username': self.username, 'password': self.password}
        )
        data = response.json()
        self.access_token = data['access_token']
        self.refresh_token = data['refresh_token']
        return data
        
    def get_headers(self):
        """Получение заголовков с токеном"""
        return {
            'Authorization': f'Bearer {self.access_token}',
            'Content-Type': 'application/json'
        }
    
    def run_quantum_computation(self, qubits=4, algorithm='grover'):
        """Выполнение квантовых вычислений"""
        data = {
            'num_qubits': qubits,
            'algorithm_type': algorithm,
            'shots': 1000
        }
        
        response = requests.post(
            f'{self.base_url}/qcompute/grover',
            headers=self.get_headers(),
            json=data
        )
        return response.json()
    
    def create_crypto_payment(self, amount_usd=10.0, currency='BTC'):
        """Создание криптоплатежа"""
        data = {
            'amount_usd': amount_usd,
            'currency': currency,
            'description': 'Оплата за квантовые вычисления'
        }
        
        response = requests.post(
            f'{self.base_url}/payments/crypto/create-payment',
            headers=self.get_headers(),
            json=data
        )
        return response.json()
    
    def get_system_metrics(self):
        """Получение метрик системы"""
        response = requests.get(
            f'{self.base_url}/metrics/system',
            headers=self.get_headers()
        )
        return response.json()
    
    def generate_quantum_keys(self):
        """Генерация квантовых ключей"""
        # Kyber ключи
        kyber_response = requests.post(
            f'{self.base_url}/quantum-keys/kyber/generate-keypair',
            headers=self.get_headers(),
            json={'key_id': 'demo_kyber', 'security_level': 256}
        )
        
        # Dilithium ключи
        dilithium_response = requests.post(
            f'{self.base_url}/quantum-keys/dilithium/generate-keypair',
            headers=self.get_headers(),
            json={'key_id': 'demo_dilithium', 'security_level': 512}
        )
        
        return {
            'kyber': kyber_response.json(),
            'dilithium': dilithium_response.json()
        }

# Использование
api = X0tta6bl4API('https://api.x0tta6bl4.com/api/v1', 'demo_user', 'demo_pass')

# Аутентификация
auth_result = api.authenticate()
print(f"Аутентифицирован пользователь: {auth_result['user']['username']}")

# Получение метрик системы
metrics = api.get_system_metrics()
print(f"CPU: {metrics['system_metrics']['cpu_usage']}%, φ-гармония: {metrics['system_metrics']['phi_harmony']}")

# Генерация квантовых ключей
keys = api.generate_quantum_keys()
print(f"Kyber ключ создан: {keys['kyber']['keypair']['key_id']}")
print(f"Dilithium ключ создан: {keys['dilithium']['keypair']['key_id']}")

# Выполнение квантовых вычислений
quantum_result = api.run_quantum_computation(qubits=6)
print(f"Алгоритм Гровера выполнен за {quantum_result['execution_time']}мс")
print(f"Вероятность успеха: {quantum_result['result']['success_probability']}")

# Создание криптоплатежа
payment = api.create_crypto_payment(amount_usd=25.0, currency='ETH')
print(f"ETH адрес для оплаты: {payment['payment']['address']}")
print(f"Сумма к оплате: {payment['payment']['amount_crypto']} ETH")

print("✅ Все API работают корректно!")
```

### JavaScript пример комплексного использования

```javascript
class X0tta6bl4SDK {
    constructor(baseURL, username, password) {
        this.baseURL = baseURL;
        this.username = username;
        this.password = password;
        this.accessToken = null;
        this.refreshToken = null;
    }

    async authenticate() {
        const response = await fetch(`${this.baseURL}/auth/login`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                username: this.username,
                password: this.password
            })
        });
        
        const data = await response.json();
        this.accessToken = data.access_token;
        this.refreshToken = data.refresh_token;
        return data;
    }

    getHeaders() {
        return {
            'Authorization': `Bearer ${this.accessToken}`,
            'Content-Type': 'application/json'
        };
    }

    async runQuantumComputation(qubits = 4, algorithm = 'grover') {
        const response = await fetch(`${this.baseURL}/qcompute/grover`, {
            method: 'POST',
            headers: this.getHeaders(),
            body: JSON.stringify({
                num_qubits: qubits,
                algorithm_type: algorithm,
                shots: 1000
            })
        });
        return await response.json();
    }

    async createCryptoPayment(amountUSD = 10.0, currency = 'BTC') {
        const response = await fetch(`${this.baseURL}/payments/crypto/create-payment`, {
            method: 'POST',
            headers: this.getHeaders(),
            body: JSON.stringify({
                amount_usd: amountUSD,
                currency: currency,
                description: 'Оплата за квантовые вычисления'
            })
        });
        return await response.json();
    }

    async getSystemMetrics() {
        const response = await fetch(`${this.baseURL}/metrics/system`, {
            headers: this.getHeaders()
        });
        return await response.json();
    }

    async generateQuantumKeys() {
        // Генерация Kyber ключей
        const kyberResponse = await fetch(`${this.baseURL}/quantum-keys/kyber/generate-keypair`, {
            method: 'POST',
            headers: this.getHeaders(),
            body: JSON.stringify({
                key_id: 'js_demo_kyber',
                security_level: 256
            })
        });
        
        // Генерация Dilithium ключей
        const dilithiumResponse = await fetch(`${this.baseURL}/quantum-keys/dilithium/generate-keypair`, {
            method: 'POST',
            headers: this.getHeaders(),
            body: JSON.stringify({
                key_id: 'js_demo_dilithium',
                security_level: 512
            })
        });
        
        return {
            kyber: await kyberResponse.json(),
            dilithium: await dilithiumResponse.json()
        };
    }
}

// Использование
async function completeDemo() {
    const sdk = new X0tta6bl4SDK('https://api.x0tta6bl4.com/api/v1', 'demo_user', 'demo_pass');
    
    try {
        // Аутентификация
        const auth = await sdk.authenticate();
        console.log(`✅ Аутентифицирован: ${auth.user.username}`);
        
        // Параллельное выполнение операций
        const [metrics, keys, quantumResult, payment] = await Promise.all([
            sdk.getSystemMetrics(),
            sdk.generateQuantumKeys(),
            sdk.runQuantumComputation(6),
            sdk.createCryptoPayment(25.0, 'ETH')
        ]);
        
        console.log(`📊 Системные метрики:`);
        console.log(`   CPU: ${metrics.system_metrics.cpu_usage}%`);
        console.log(`   φ-гармония: ${metrics.system_metrics.phi_harmony}`);
        
        console.log(`🔐 Квантовые ключи:`);
        console.log(`   Kyber: ${keys.kyber.keypair.key_id}`);
        console.log(`   Dilithium: ${keys.dilithium.keypair.key_id}`);
        
        console.log(`⚛️ Квантовые вычисления:`);
        console.log(`   Время выполнения: ${quantumResult.execution_time}мс`);
        console.log(`   Вероятность успеха: ${quantumResult.result.success_probability}`);
        
        console.log(`💰 Криптоплатеж:`);
        console.log(`   Адрес: ${payment.payment.address}`);
        console.log(`   Сумма: ${payment.payment.amount_crypto} ${payment.payment.currency}`);
        
        console.log(`🎉 Все API работают идеально!`);
        
    } catch (error) {
        console.error(`❌ Ошибка: ${error.message}`);
    }
}

completeDemo();
```

### PHP пример полного цикла

```php
<?php

class X0tta6bl4API {
    private $baseUrl;
    private $username;
    private $password;
    private $accessToken;
    private $refreshToken;

    public function __construct($baseUrl, $username, $password) {
        $this->baseUrl = $baseUrl;
        $this->username = $username;
        $this->password = $password;
    }

    public function authenticate() {
        $data = json_encode([
            'username' => $this->username,
            'password' => $this->password
        ]);
        
        $result = $this->makeRequest('POST', '/auth/login', $data);
        $this->accessToken = $result['access_token'];
        $this->refreshToken = $result['refresh_token'];
        return $result;
    }

    private function getHeaders() {
        return [
            'Authorization: Bearer ' . $this->accessToken,
            'Content-Type: application/json'
        ];
    }

    private function makeRequest($method, $endpoint, $data = null) {
        $url = $this->baseUrl . $endpoint;
        $contextOptions = [
            'http' => [
                'method' => $method,
                'header' => $this->getHeaders()
            ]
        ];

        if ($data !== null) {
            $contextOptions['http']['content'] = $data;
        }

        $context = stream_context_create($contextOptions);
        $result = file_get_contents($url, false, $context);
        
        if ($result === false) {
            throw new Exception('Ошибка HTTP запроса');
        }
        
        return json_decode($result, true);
    }

    public function runQuantumComputation($qubits = 4, $algorithm = 'grover') {
        $data = json_encode([
            'num_qubits' => $qubits,
            'algorithm_type' => $algorithm,
            'shots' => 1000
        ]);
        return $this->makeRequest('POST', '/qcompute/grover', $data);
    }

    public function createCryptoPayment($amountUSD = 10.0, $currency = 'BTC') {
        $data = json_encode([
            'amount_usd' => $amountUSD,
            'currency' => $currency,
            'description' => 'Оплата за квантовые вычисления'
        ]);
        return $this->makeRequest('POST', '/payments/crypto/create-payment', $data);
    }

    public function getSystemMetrics() {
        return $this->makeRequest('GET', '/metrics/system');
    }

    public function generateQuantumKeys() {
        // Kyber ключи
        $kyberData = json_encode([
            'key_id' => 'php_demo_kyber',
            'security_level' => 256
        ]);
        $kyberResult = $this->makeRequest('POST', '/quantum-keys/kyber/generate-keypair', $kyberData);
        
        // Dilithium ключи
        $dilithiumData = json_encode([
            'key_id' => 'php_demo_dilithium',
            'security_level' => 512
        ]);
        $dilithiumResult = $this->makeRequest('POST', '/quantum-keys/dilithium/generate-keypair', $dilithiumData);
        
        return [
            'kyber' => $kyberResult,
            'dilithium' => $dilithiumResult
        ];
    }
}

// Использование
try {
    $api = new X0tta6bl4API('https://api.x0tta6bl4.com/api/v1', 'demo_user', 'demo_pass');
    
    // Аутентификация
    $auth = $api->authenticate();
    echo "✅ Аутентифицирован: {$auth['user']['username']}\n";
    
    // Получение метрик
    $metrics = $api->getSystemMetrics();
    echo "📊 CPU: {$metrics['system_metrics']['cpu_usage']}%, φ-гармония: {$metrics['system_metrics']['phi_harmony']}\n";
    
    // Генерация ключей
    $keys = $api->generateQuantumKeys();
    echo "🔐 Kyber ключ: {$keys['kyber']['keypair']['key_id']}\n";
    echo "🔐 Dilithium ключ: {$keys['dilithium']['keypair']['key_id']}\n";
    
    // Квантовые вычисления
    $quantum = $api->runQuantumComputation(6);
    echo "⚛️ Время выполнения: {$quantum['execution_time']}мс\n";
    echo "⚛️ Вероятность успеха: {$quantum['result']['success_probability']}\n";
    
    // Криптоплатеж
    $payment = $api->createCryptoPayment(25.0, 'ETH');
    echo "💰 ETH адрес: {$payment['payment']['address']}\n";
    echo "💰 Сумма: {$payment['payment']['amount_crypto']} ETH\n";
    
    echo "🎉 Все API работают идеально!\n";
    
} catch (Exception $e) {
    echo "❌ Ошибка: " . $e->getMessage() . "\n";
}

?>
```

## Заключение

Представленные примеры демонстрируют полное использование всех API-интерфейсов x0tta6bl4:

- **Auth API**: Аутентификация и управление пользователями
- **Quantum Key Manager API**: Постквантовая криптография и управление ключами
- **QCompute API**: Квантовые вычисления с φ-оптимизацией
- **Payments API**: Платежи через Stripe и криптовалюты
- **Metrics API**: Мониторинг и аналитика системы

Все примеры используют реальные сценарии использования и показывают, как интегрировать API в различные типы приложений.

---

*Документация обновлена: 30 сентября 2025*