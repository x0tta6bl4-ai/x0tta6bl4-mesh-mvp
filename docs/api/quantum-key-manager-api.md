# Quantum Key Manager API - Управление квантовыми ключами

## Обзор

Quantum Key Manager API предоставляет полный набор функций для управления квантовыми ключами, постквантовой криптографией и φ-оптимизированным шифрованием в системе x0tta6bl4.

## Архитектура безопасности

Система использует многоуровневую архитектуру безопасности:

```
┌─────────────────────────────────────────────────────────────┐
│              x0tta6bl4 Quantum Key Manager                   │
├─────────────────────────────────────────────────────────────┤
│  Layer 1: QKD (Quantum Key Distribution)                   │
│  Layer 2: Kyber (ML-KEM) - Post-quantum encryption         │
│  Layer 3: Dilithium (ML-DSA) - Digital signatures          │
│  Layer 4: φ-encrypted channels (100 Hz synchronization)    │
└─────────────────────────────────────────────────────────────┘
```

## Базовая информация

- **Базовый URL**: `https://api.x0tta6bl4.com/api/v1/quantum-keys`
- **Аутентификация**: Bearer токен (обязательна)
- **Формат**: JSON

## Модели данных

### Конфигурация безопасности

```typescript
interface PQCSecurityConfig {
  BASE_FREQUENCY: number;        // 100 Hz
  golden_ratio: number;         // 1.6180339887...
  phi_power: number;           // 25 (φ²⁵ = 167,761)
  key_size_kyber: number;      // 1024 bits
  key_size_dilithium: number;  // 2048 bits
  qkd_rate: number;           // 1.0 Mbps
  error_threshold: number;    // 0.001 (0.1%)
}
```

### Уровни безопасности

```typescript
enum SecurityLayer {
  QKD = 1,           // Quantum Key Distribution
  KYBER = 2,         // ML-KEM encryption
  DILITHIUM = 3,     // ML-DSA signatures
  PHI_ENCRYPTED = 4  // φ-encrypted channels
}
```

## Эндпоинты

### Генерация Kyber ключей

**POST** `/kyber/generate-keypair`

Генерирует пару ключей Kyber (ML-KEM) для постквантового шифрования.

**Заголовки:**
```
Authorization: Bearer <access_token>
```

**Запрос:**
```json
{
  "key_id": "my_kyber_keys_001",
  "security_level": 256
}
```

**Ответ (201):**
```json
{
  "keypair": {
    "key_id": "my_kyber_keys_001",
    "private_key": "base64_encoded_private_key...",
    "public_key": "base64_encoded_public_key...",
    "algorithm": "Kyber-1024",
    "security_level": 256,
    "phi_optimized": true,
    "timestamp": 1640995200.123
  },
  "phi_power": 25,
  "phi_value": 167761.0
}
```

**Пример cURL:**
```bash
curl -X POST https://api.x0tta6bl4.com/api/v1/quantum-keys/kyber/generate-keypair \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "key_id": "my_kyber_keys_001",
    "security_level": 256
  }'
```

### Шифрование Kyber

**POST** `/kyber/encrypt`

Шифрует сообщение с помощью Kyber алгоритма.

**Заголовки:**
```
Authorization: Bearer <access_token>
```

**Запрос:**
```json
{
  "message": "base64_encoded_message",
  "public_key": "base64_encoded_public_key",
  "key_id": "my_kyber_keys_001"
}
```

**Ответ (200):**
```json
{
  "encrypted_data": {
    "encrypted_session_key": "base64_encrypted_session_key...",
    "encrypted_message": "base64_encrypted_message...",
    "key_id": "my_kyber_keys_001",
    "algorithm": "Kyber-1024",
    "phi_optimized": true,
    "timestamp": 1640995200.123
  },
  "encryption_time_ms": 15.7,
  "phi_optimization_applied": true
}
```

### Расшифровка Kyber

**POST** `/kyber/decrypt`

Расшифровывает сообщение с помощью Kyber алгоритма.

**Заголовки:**
```
Authorization: Bearer <access_token>
```

**Запрос:**
```json
{
  "encrypted_data": {
    "encrypted_session_key": "base64_encrypted_session_key...",
    "encrypted_message": "base64_encrypted_message...",
    "key_id": "my_kyber_keys_001"
  },
  "private_key": "base64_encoded_private_key"
}
```

**Ответ (200):**
```json
{
  "decrypted_message": "base64_decrypted_message...",
  "decryption_time_ms": 12.3,
  "phi_optimization_applied": true
}
```

### Генерация Dilithium ключей

**POST** `/dilithium/generate-keypair`

Генерирует пару ключей Dilithium (ML-DSA) для цифровых подписей.

**Заголовки:**
```
Authorization: Bearer <access_token>
```

**Запрос:**
```json
{
  "key_id": "my_dilithium_keys_001",
  "security_level": 512
}
```

**Ответ (201):**
```json
{
  "keypair": {
    "key_id": "my_dilithium_keys_001",
    "private_key": "base64_encoded_private_key...",
    "public_key": "base64_encoded_public_key...",
    "algorithm": "Dilithium-2048",
    "security_level": 512,
    "phi_optimized": true,
    "timestamp": 1640995200.123
  }
}
```

### Подписание сообщения

**POST** `/dilithium/sign`

Подписывает сообщение с помощью Dilithium алгоритма.

**Заголовки:**
```
Authorization: Bearer <access_token>
```

**Запрос:**
```json
{
  "message": "base64_encoded_message",
  "private_key": "base64_encoded_private_key",
  "key_id": "my_dilithium_keys_001"
}
```

**Ответ (200):**
```json
{
  "signed_data": {
    "message": "base64_encoded_message",
    "signature": "base64_dilithium_signature...",
    "key_id": "my_dilithium_keys_001",
    "algorithm": "Dilithium-2048",
    "phi_optimized": true,
    "timestamp": 1640995200.123
  },
  "signing_time_ms": 8.5
}
```

### Проверка подписи

**POST** `/dilithium/verify`

Проверяет подпись Dilithium.

**Запрос:**
```json
{
  "signed_data": {
    "message": "base64_encoded_message",
    "signature": "base64_dilithium_signature...",
    "key_id": "my_dilithium_keys_001"
  },
  "public_key": "base64_encoded_public_key"
}
```

**Ответ (200):**
```json
{
  "is_valid": true,
  "verification_time_ms": 6.2,
  "phi_optimization_applied": true
}
```

### Настройка QKD канала

**POST** `/qkd/setup-channel`

Настраивает канал квантового распределения ключей.

**Заголовки:**
```
Authorization: Bearer <access_token>
```

**Запрос:**
```json
{
  "channel_id": "qkd_channel_001",
  "frequency": 100.0,
  "key_rate_mbps": 1.0,
  "error_threshold": 0.001
}
```

**Ответ (201):**
```json
{
  "qkd_config": {
    "channel_id": "qkd_channel_001",
    "frequency": 100.0,
    "quantum_states": ["complex_array_of_quantum_states..."],
    "optimized_channel": ["phi_optimized_states..."],
    "key_rate": 1.0,
    "error_threshold": 0.001,
    "phi_optimized": true,
    "timestamp": 1640995200.123
  },
  "channel_established": true
}
```

### Создание φ-шифрованного канала

**POST** `/phi-channel/establish`

Устанавливает φ-шифрованный канал связи.

**Заголовки:**
```
Authorization: Bearer <access_token>
```

**Запрос:**
```json
{
  "channel_id": "phi_channel_001",
  "frequency": 100.0,
  "phi_power": 25
}
```

**Ответ (201):**
```json
{
  "channel_config": {
    "channel_id": "phi_channel_001",
    "frequency": 100.0,
    "phi_keys": {
      "main_key": "base64_main_key...",
      "sub_keys": {
        "sub_key_0": "base64_sub_key_0...",
        "sub_key_1": "base64_sub_key_1...",
        "sub_key_2": "base64_sub_key_2...",
        "sub_key_3": "base64_sub_key_3..."
      },
      "phi_factor": 161803
    },
    "sync_config": {
      "frequency": 100.0,
      "sync_period": 0.01,
      "phi_phase": 10.166,
      "timestamp": 1640995200.123
    },
    "phi_power": 25,
    "encryption_algorithm": "φ-encrypted",
    "timestamp": 1640995200.123
  }
}
```

### φ-шифрование сообщения

**POST** `/phi-channel/encrypt`

Шифрует сообщение через φ-канал.

**Заголовки:**
```
Authorization: Bearer <access_token>
```

**Запрос:**
```json
{
  "message": "base64_encoded_message",
  "channel_id": "phi_channel_001"
}
```

**Ответ (200):**
```json
{
  "encrypted_data": {
    "encrypted_message": "base64_phi_encrypted...",
    "channel_id": "phi_channel_001",
    "frequency": 100.0,
    "phi_power": 25,
    "timestamp": 1640995200.123
  },
  "encryption_layers": 3,
  "phi_optimization_applied": true
}
```

### φ-расшифровка сообщения

**POST** `/phi-channel/decrypt`

Расшифровывает сообщение из φ-канала.

**Запрос:**
```json
{
  "encrypted_data": {
    "encrypted_message": "base64_phi_encrypted...",
    "channel_id": "phi_channel_001"
  }
}
```

**Ответ (200):**
```json
{
  "decrypted_message": "base64_decrypted_message...",
  "decryption_time_ms": 9.8,
  "phi_optimization_applied": true
}
```

### Создание гибридной PQC системы

**POST** `/hybrid/create-system`

Создает полную гибридную постквантовую систему безопасности.

**Заголовки:**
```
Authorization: Bearer <access_token>
```

**Запрос:**
```json
{
  "system_id": "enterprise_security_system_001",
  "frequency": 100.0,
  "phi_power": 25
}
```

**Ответ (201):**
```json
{
  "hybrid_system": {
    "system_id": "enterprise_security_system_001",
    "layers": {
      "qkd": {
        "channel_id": "enterprise_security_system_001_qkd",
        "frequency": 100.0,
        "key_rate": 1.0,
        "phi_optimized": true
      },
      "kyber": {
        "key_id": "enterprise_security_system_001_kyber",
        "algorithm": "Kyber-1024",
        "security_level": 256,
        "phi_optimized": true
      },
      "dilithium": {
        "key_id": "enterprise_security_system_001_dilithium",
        "algorithm": "Dilithium-2048",
        "security_level": 512,
        "phi_optimized": true
      },
      "phi_encrypted": {
        "channel_id": "enterprise_security_system_001_phi",
        "frequency": 100.0,
        "phi_power": 25,
        "encryption_algorithm": "φ-encrypted"
      }
    },
    "security_level": "Post-Quantum + φ-optimized",
    "frequency": 100.0,
    "phi_power": 25,
    "timestamp": 1640995200.123
  },
  "supremacy_achieved": true
}
```

### Получение метрик безопасности

**GET** `/metrics/security`

Возвращает метрики безопасности системы.

**Заголовки:**
```
Authorization: Bearer <access_token>
```

**Ответ (200):**
```json
{
  "security_metrics": {
    "frequency": 100.0,
    "golden_ratio": 1.618033988749895,
    "phi_power": 25,
    "kyber_keys_count": 15,
    "dilithium_keys_count": 12,
    "qkd_channels_count": 8,
    "phi_channels_count": 6,
    "security_level": "Post-Quantum + φ-optimized",
    "supremacy_achieved": true,
    "phi_value": 167761.0
  },
  "performance_metrics": {
    "avg_encryption_time_ms": 15.2,
    "avg_decryption_time_ms": 11.8,
    "avg_signing_time_ms": 8.1,
    "avg_verification_time_ms": 5.9,
    "quantum_coherence": 0.95,
    "phi_harmony": 1.618
  }
}
```

### Генерация отчета безопасности

**GET** `/reports/security`

Генерирует подробный отчет о безопасности.

**Заголовки:**
```
Authorization: Bearer <access_token>
```

**Ответ (200):**
```json
{
  "security_report": {
    "title": "ОТЧЕТ О ПОСТКВАНТОВОЙ БЕЗОПАСНОСТИ x0tta6bl4",
    "qkd_channels": {
      "count": 8,
      "frequency": 100.0,
      "key_rate_mbps": 1.0
    },
    "cryptographic_keys": {
      "kyber_keys": 15,
      "dilithium_keys": 12,
      "phi_channels": 6
    },
    "phi_optimization": {
      "golden_ratio": 1.618033988749895,
      "phi_power_25": 167761.0,
      "frequency": 100.0
    },
    "security_status": {
      "level": "Post-Quantum + φ-optimized",
      "supremacy_achieved": true
    },
    "generated_at": "2025-01-01T00:00:00Z"
  }
}
```

## Управление ключами

### Получение списка ключей

**GET** `/keys/list`

Возвращает список всех ключей пользователя.

**Заголовки:**
```
Authorization: Bearer <access_token>
```

**Параметры запроса:**
- `algorithm` (string): Фильтр по алгоритму (kyber, dilithium)
- `limit` (int): Количество ключей (по умолчанию: 50)
- `offset` (int): Смещение (по умолчанию: 0)

**Ответ (200):**
```json
{
  "keys": [
    {
      "key_id": "my_kyber_keys_001",
      "algorithm": "Kyber-1024",
      "security_level": 256,
      "created_at": "2025-01-01T00:00:00Z",
      "phi_optimized": true
    },
    {
      "key_id": "my_dilithium_keys_001",
      "algorithm": "Dilithium-2048",
      "security_level": 512,
      "created_at": "2025-01-01T00:00:00Z",
      "phi_optimized": true
    }
  ],
  "total_count": 2,
  "algorithms": ["kyber", "dilithium"]
}
```

### Получение ключа по ID

**GET** `/keys/{key_id}`

Возвращает информацию о конкретном ключе.

**Заголовки:**
```
Authorization: Bearer <access_token>
```

**Ответ (200):**
```json
{
  "key": {
    "key_id": "my_kyber_keys_001",
    "algorithm": "Kyber-1024",
    "security_level": 256,
    "public_key": "base64_encoded_public_key...",
    "created_at": "2025-01-01T00:00:00Z",
    "phi_optimized": true,
    "metadata": {
      "frequency": 100.0,
      "phi_power": 25
    }
  }
}
```

### Удаление ключа

**DELETE** `/keys/{key_id}`

Удаляет ключ из системы.

**Заголовки:**
```
Authorization: Bearer <access_token>
```

**Ответ (200):**
```json
{
  "message": "Ключ успешно удален",
  "key_id": "my_kyber_keys_001",
  "deleted_at": "2025-01-01T00:00:00Z"
}
```

### Ротация ключей

**POST** `/keys/rotate`

Выполняет ротацию всех ключей пользователя.

**Заголовки:**
```
Authorization: Bearer <access_token>
```

**Запрос:**
```json
{
  "algorithms": ["kyber", "dilithium"],
  "preserve_channels": true
}
```

**Ответ (200):**
```json
{
  "rotation_results": {
    "kyber_keys_rotated": 5,
    "dilithium_keys_rotated": 3,
    "channels_preserved": 2,
    "new_keys_generated": 8
  },
  "rotation_time_ms": 245.6,
  "next_rotation_due": "2025-02-01T00:00:00Z"
}
```

## Мониторинг и диагностика

### Проверка здоровья системы

**GET** `/health`

Проверяет здоровье Quantum Key Manager системы.

**Ответ (200):**
```json
{
  "status": "healthy",
  "components": {
    "qkd_system": {
      "status": "operational",
      "active_channels": 8,
      "frequency": 100.0
    },
    "kyber_system": {
      "status": "operational",
      "active_keys": 15,
      "avg_encryption_time_ms": 15.2
    },
    "dilithium_system": {
      "status": "operational",
      "active_keys": 12,
      "avg_signing_time_ms": 8.1
    },
    "phi_system": {
      "status": "operational",
      "active_channels": 6,
      "phi_harmony": 1.618
    }
  },
  "overall_health": "excellent",
  "timestamp": "2025-01-01T00:00:00Z"
}
```

### Получение логов безопасности

**GET** `/logs/security`

Возвращает логи безопасности (только для администраторов).

**Заголовки:**
```
Authorization: Bearer <access_token>
```

**Параметры запроса:**
- `from_date` (string): Начальная дата (ISO 8601)
- `to_date` (string): Конечная дата (ISO 8601)
- `level` (string): Уровень логирования (info, warning, error)
- `limit` (int): Количество записей

**Ответ (200):**
```json
{
  "logs": [
    {
      "timestamp": "2025-01-01T00:00:00Z",
      "level": "info",
      "event": "key_generation",
      "details": {
        "algorithm": "Kyber-1024",
        "key_id": "user_123_kyber_001",
        "phi_optimized": true
      }
    },
    {
      "timestamp": "2025-01-01T00:01:00Z",
      "level": "warning",
      "event": "phi_sync_drift",
      "details": {
        "channel_id": "phi_channel_001",
        "drift_amount": 0.001,
        "auto_corrected": true
      }
    }
  ],
  "total_count": 156,
  "filtered_count": 45
}
```

## Примеры кода

### Python

```python
import requests
import base64

# Настройка аутентификации
headers = {
    'Authorization': 'Bearer <your_jwt_token>',
    'Content-Type': 'application/json'
}

# Генерация Kyber ключей
kyber_response = requests.post(
    'https://api.x0tta6bl4.com/api/v1/quantum-keys/kyber/generate-keypair',
    headers=headers,
    json={'key_id': 'my_kyber_keys', 'security_level': 256}
)

keypair = kyber_response.json()['keypair']
print(f"Ключ создан: {keypair['key_id']}")

# Шифрование сообщения
message = "Секретное сообщение для шифрования"
message_bytes = message.encode('utf-8')
message_b64 = base64.b64encode(message_bytes).decode()

encrypt_response = requests.post(
    'https://api.x0tta6bl4.com/api/v1/quantum-keys/kyber/encrypt',
    headers=headers,
    json={
        'message': message_b64,
        'public_key': keypair['public_key'],
        'key_id': keypair['key_id']
    }
)

encrypted_data = encrypt_response.json()['encrypted_data']
print(f"Сообщение зашифровано алгоритмом {encrypted_data['algorithm']}")

# Расшифровка сообщения
decrypt_response = requests.post(
    'https://api.x0tta6bl4.com/api/v1/quantum-keys/kyber/decrypt',
    headers=headers,
    json={
        'encrypted_data': encrypted_data,
        'private_key': keypair['private_key']
    }
)

decrypted_b64 = decrypt_response.json()['decrypted_message']
decrypted_bytes = base64.b64decode(decrypted_b64)
decrypted_message = decrypted_bytes.decode('utf-8')
print(f"Расшифрованное сообщение: {decrypted_message}")
```

### JavaScript (Node.js)

```javascript
const axios = require('axios');

class QuantumKeyManager {
    constructor(baseURL, token) {
        this.baseURL = baseURL;
        this.token = token;
        this.headers = {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
        };
    }

    async generateKyberKeypair(keyId, securityLevel = 256) {
        try {
            const response = await axios.post(
                `${this.baseURL}/quantum-keys/kyber/generate-keypair`,
                { key_id: keyId, security_level: securityLevel },
                { headers: this.headers }
            );
            return response.data.keypair;
        } catch (error) {
            console.error('Ошибка генерации ключей:', error.response.data);
            throw error;
        }
    }

    async encryptMessage(message, publicKey, keyId) {
        try {
            const messageBase64 = Buffer.from(message, 'utf8').toString('base64');
            
            const response = await axios.post(
                `${this.baseURL}/quantum-keys/kyber/encrypt`,
                {
                    message: messageBase64,
                    public_key: publicKey,
                    key_id: keyId
                },
                { headers: this.headers }
            );
            return response.data.encrypted_data;
        } catch (error) {
            console.error('Ошибка шифрования:', error.response.data);
            throw error;
        }
    }

    async decryptMessage(encryptedData, privateKey) {
        try {
            const response = await axios.post(
                `${this.baseURL}/quantum-keys/kyber/decrypt`,
                {
                    encrypted_data: encryptedData,
                    private_key: privateKey
                },
                { headers: this.headers }
            );
            const decryptedBase64 = response.data.decrypted_message;
            return Buffer.from(decryptedBase64, 'base64').toString('utf8');
        } catch (error) {
            console.error('Ошибка расшифровки:', error.response.data);
            throw error;
        }
    }

    async createPhiChannel(channelId, frequency = 100.0) {
        try {
            const response = await axios.post(
                `${this.baseURL}/quantum-keys/phi-channel/establish`,
                { channel_id: channelId, frequency: frequency },
                { headers: this.headers }
            );
            return response.data.channel_config;
        } catch (error) {
            console.error('Ошибка создания φ-канала:', error.response.data);
            throw error;
        }
    }

    async getSecurityMetrics() {
        try {
            const response = await axios.get(
                `${this.baseURL}/quantum-keys/metrics/security`,
                { headers: this.headers }
            );
            return response.data.security_metrics;
        } catch (error) {
            console.error('Ошибка получения метрик:', error.response.data);
            throw error;
        }
    }
}

// Использование
async function example() {
    const keyManager = new QuantumKeyManager(
        'https://api.x0tta6bl4.com/api/v1',
        'your_jwt_token'
    );

    // Генерация ключей
    const keypair = await keyManager.generateKyberKeypair('demo_keys');
    console.log('Ключ создан:', keypair.key_id);

    // Создание φ-канала
    const phiChannel = await keyManager.createPhiChannel('demo_phi_channel');
    console.log('φ-канал создан:', phiChannel.channel_id);

    // Получение метрик безопасности
    const metrics = await keyManager.getSecurityMetrics();
    console.log('Метрики безопасности:', metrics);
}

example().catch(console.error);
```

### PHP

```php
<?php

class QuantumKeyManager {
    private $baseUrl;
    private $token;
    private $headers;

    public function __construct($baseUrl, $token) {
        $this->baseUrl = $baseUrl;
        $this->token = $token;
        $this->headers = [
            'Authorization: Bearer ' . $token,
            'Content-Type: application/json'
        ];
    }

    public function generateKyberKeypair($keyId, $securityLevel = 256) {
        $data = [
            'key_id' => $keyId,
            'security_level' => $securityLevel
        ];

        return $this->makeRequest('POST', '/quantum-keys/kyber/generate-keypair', $data);
    }

    public function encryptMessage($message, $publicKey, $keyId) {
        $data = [
            'message' => base64_encode($message),
            'public_key' => $publicKey,
            'key_id' => $keyId
        ];

        return $this->makeRequest('POST', '/quantum-keys/kyber/encrypt', $data);
    }

    public function decryptMessage($encryptedData, $privateKey) {
        $data = [
            'encrypted_data' => $encryptedData,
            'private_key' => $privateKey
        ];

        return $this->makeRequest('POST', '/quantum-keys/kyber/decrypt', $data);
    }

    public function createPhiChannel($channelId, $frequency = 100.0) {
        $data = [
            'channel_id' => $channelId,
            'frequency' => $frequency
        ];

        return $this->makeRequest('POST', '/quantum-keys/phi-channel/establish', $data);
    }

    public function getSecurityMetrics() {
        return $this->makeRequest('GET', '/quantum-keys/metrics/security');
    }

    private function makeRequest($method, $endpoint, $data = null) {
        $url = $this->baseUrl . $endpoint;
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
    $keyManager = new QuantumKeyManager(
        'https://api.x0tta6bl4.com/api/v1',
        'your_jwt_token'
    );

    // Генерация ключей
    $keypair = $keyManager->generateKyberKeypair('php_demo_keys');
    echo "Ключ создан: " . $keypair['keypair']['key_id'] . PHP_EOL;

    // Создание φ-канала
    $phiChannel = $keyManager->createPhiChannel('php_phi_channel');
    echo "φ-канал создан: " . $phiChannel['channel_config']['channel_id'] . PHP_EOL;

    // Получение метрик
    $metrics = $keyManager->getSecurityMetrics();
    echo "Уровень безопасности: " . $metrics['security_metrics']['security_level'] . PHP_EOL;

} catch (Exception $e) {
    echo "Ошибка: " . $e->getMessage() . PHP_EOL;
}

?>
```

## Ошибки

### 400 - Неверный запрос

```json
{
  "error": {
    "code": "INVALID_KEY_ID",
    "message": "Неверный идентификатор ключа",
    "details": {
      "provided_key_id": "invalid_key_id",
      "expected_format": "key_id должен содержать только буквы, цифры и подчеркивания"
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

### 403 - Доступ запрещен

```json
{
  "error": {
    "code": "INSUFFICIENT_PERMISSIONS",
    "message": "Недостаточно прав для выполнения операции",
    "details": {
      "required_permission": "quantum_keys:manage",
      "user_permissions": ["quantum_keys:read"]
    }
  }
}
```

### 404 - Ключ не найден

```json
{
  "error": {
    "code": "KEY_NOT_FOUND",
    "message": "Ключ не найден",
    "details": {
      "key_id": "non_existent_key"
    }
  }
}
```

### 429 - Слишком много запросов

```json
{
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Превышен лимит запросов квантовой криптографии",
    "details": {
      "limit": 100,
      "window_seconds": 3600,
      "retry_after": 1800
    }
  }
}
```

## Лучшие практики

1. **Генерация ключей**: Регулярно генерируйте новые ключи для повышения безопасности
2. **Ротация**: Автоматически ротируйте ключи каждые 30-90 дней
3. **Хранение**: Никогда не храните приватные ключи в незащищенном виде
4. **φ-синхронизация**: Поддерживайте синхронизацию φ-каналов для оптимальной производительности
5. **Мониторинг**: Регулярно проверяйте метрики безопасности и логи системы
6. **Резервное копирование**: Создавайте резервные копии важных ключей в защищенном хранилище

## Производительность

### Метрики производительности

- **Генерация Kyber ключей**: ~50-100 мс
- **Шифрование Kyber**: ~10-20 мс
- **Расшифровка Kyber**: ~8-15 мс
- **Генерация Dilithium ключей**: ~80-150 мс
- **Подписание Dilithium**: ~5-10 мс
- **Проверка подписи**: ~3-8 мс
- **φ-шифрование**: ~15-25 мс
- **φ-расшифровка**: ~12-20 мс

### Оптимизация

- Все операции используют φ-оптимизацию для повышения производительности
- Многоуровневое кеширование для часто используемых ключей
- Параллельная обработка для массовых операций
- Автоматическая балансировка нагрузки между слоями безопасности

---

*Документация обновлена: 30 сентября 2025*