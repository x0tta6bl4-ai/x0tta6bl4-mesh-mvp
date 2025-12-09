# Payments API - Платежные операции

## Обзор

Payments API предоставляет полный набор функций для обработки платежей, включая интеграцию со Stripe, криптовалютные платежи и управление подписками в системе x0tta6bl4.

## Архитектура платежей

```
┌─────────────────────────────────────────────────────────────┐
│              x0tta6bl4 Payment Gateway                       │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │   Stripe    │  │   Crypto    │  │ Subscriptions│         │
│  │ Integration │  │  Payments   │  │ Management   │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │   Billing   │  │   Invoices  │  │   Analytics  │         │
│  │ Engine      │  │ Generation  │  │ & Reports    │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
└─────────────────────────────────────────────────────────────┘
```

## Базовая информация

- **Базовый URL**: `https://api.x0tta6bl4.com/api/v1/payments`
- **Аутентификация**: Bearer токен (обязательна)
- **Формат**: JSON
- **Поддерживаемые валюты**: USD, EUR, BTC, ETH, XMR, USDT

## Модели данных

### Платежный метод

```typescript
enum PaymentMethod {
  CREDIT_CARD = "credit_card",
  DEBIT_CARD = "debit_card",
  PAYPAL = "paypal",
  BANK_TRANSFER = "bank_transfer",
  CRYPTO = "crypto",
  QUANTUM_PAYMENT = "quantum_payment"
}
```

### Статус платежа

```typescript
enum PaymentStatus {
  PENDING = "pending",           // Ожидает обработки
  PROCESSING = "processing",     // В обработке
  COMPLETED = "completed",       // Завершен успешно
  FAILED = "failed",            // Неудачный платеж
  CANCELLED = "cancelled",      // Отменен
  REFUNDED = "refunded",        // Возвращен
  PARTIALLY_REFUNDED = "partially_refunded"
}
```

### Тип транзакции

```typescript
enum TransactionType {
  PAYMENT = "payment",           // Оплата
  REFUND = "refund",            // Возврат
  SUBSCRIPTION = "subscription", // Подписка
  USAGE = "usage"               // Оплата за использование
}
```

## Эндпоинты

### Создание платежного намерения (Stripe)

**POST** `/stripe/payment-intent`

Создает платежное намерение в Stripe.

**Заголовки:**
```
Authorization: Bearer <access_token>
```

**Запрос:**
```json
{
  "amount": 2999,                    // Сумма в центах ($29.99)
  "currency": "usd",
  "description": "Квантовая симуляция - 16 кубитов",
  "metadata": {
    "simulation_id": "sim_123",
    "qubits": 16,
    "user_type": "premium"
  }
}
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
    "description": "Квантовая симуляция - 16 кубитов",
    "metadata": {
      "simulation_id": "sim_123",
      "qubits": 16,
      "user_type": "premium"
    }
  },
  "requires_action": false,
  "payment_url": "https://checkout.stripe.com/pay/pi_1ABC123def456"
}
```

**Пример cURL:**
```bash
curl -X POST https://api.x0tta6bl4.com/api/v1/payments/stripe/payment-intent \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 2999,
    "currency": "usd",
    "description": "Квантовая симуляция - 16 кубитов"
  }'
```

### Подтверждение платежа

**POST** `/stripe/confirm-payment`

Подтверждает платеж в Stripe.

**Запрос:**
```json
{
  "payment_intent_id": "pi_1ABC123def456",
  "payment_method_id": "pm_1ABC123def456"
}
```

**Ответ (200):**
```json
{
  "payment_confirmed": true,
  "status": "succeeded",
  "amount_paid": 2999,
  "currency": "usd",
  "receipt_url": "https://pay.stripe.com/receipts/...",
  "transaction_id": "txn_1ABC123def456"
}
```

### Создание криптовалютного платежа

**POST** `/crypto/create-payment`

Создает криптовалютный платеж.

**Запрос:**
```json
{
  "amount_usd": 50.0,
  "currency": "BTC",
  "description": "Премиум подписка на 1 месяц",
  "callback_url": "https://yourapp.com/payment/callback",
  "expires_in": 3600
}
```

**Ответ (201):**
```json
{
  "payment": {
    "id": "crypto_pay_001",
    "amount_usd": 50.0,
    "currency": "BTC",
    "amount_crypto": 0.001234,
    "exchange_rate": 40500.0,
    "address": "bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh",
    "qr_code": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAA...",
    "status": "pending",
    "expires_at": "2025-01-01T13:00:00Z",
    "description": "Премиум подписка на 1 месяц"
  },
  "payment_instructions": {
    "send_amount": "0.001234 BTC",
    "to_address": "bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh",
    "time_limit": 3600
  }
}
```

### Проверка статуса криптоплатежа

**GET** `/crypto/payment/{payment_id}`

Проверяет статус криптовалютного платежа.

**Ответ (200):**
```json
{
  "payment_id": "crypto_pay_001",
  "status": "completed",
  "amount_received": 0.001234,
  "confirmations": 3,
  "transaction_hash": "0xabc123...",
  "completed_at": "2025-01-01T12:30:00Z",
  "usd_value": 50.0
}
```

### Создание подписки

**POST** `/subscriptions/create`

Создает подписку для пользователя.

**Запрос:**
```json
{
  "plan_id": "premium_monthly",
  "payment_method": "stripe",
  "billing_cycle": "monthly",
  "auto_renew": true,
  "coupon_code": "SAVE20"
}
```

**Ответ (201):**
```json
{
  "subscription": {
    "id": "sub_001",
    "user_id": "user_123",
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

### Отмена подписки

**POST** `/subscriptions/{subscription_id}/cancel`

Отменяет подписку.

**Запрос:**
```json
{
  "cancel_at_period_end": true,
  "cancellation_reason": "Не устраивает цена"
}
```

**Ответ (200):**
```json
{
  "subscription_cancelled": true,
  "cancel_at_period_end": true,
  "cancelled_at": "2025-01-01T00:00:00Z",
  "access_until": "2025-02-01T00:00:00Z"
}
```

### Получение истории платежей

**GET** `/payments/history`

Возвращает историю платежей пользователя.

**Параметры запроса:**
- `limit` (int): Количество записей (по умолчанию: 20)
- `offset` (int): Смещение (по умолчанию: 0)
- `status` (string): Фильтр по статусу
- `from_date` (string): Начальная дата (ISO 8601)
- `to_date` (string): Конечная дата (ISO 8601)

**Ответ (200):**
```json
{
  "payments": [
    {
      "id": "pay_001",
      "amount": 29.99,
      "currency": "usd",
      "status": "completed",
      "payment_method": "credit_card",
      "description": "Премиум подписка",
      "created_at": "2025-01-01T00:00:00Z",
      "completed_at": "2025-01-01T00:01:00Z",
      "transaction_id": "txn_123",
      "receipt_url": "https://pay.stripe.com/receipts/..."
    },
    {
      "id": "pay_002",
      "amount": 0.001234,
      "currency": "BTC",
      "status": "completed",
      "payment_method": "crypto",
      "description": "Квантовая симуляция",
      "created_at": "2025-01-02T00:00:00Z",
      "completed_at": "2025-01-02T00:15:00Z",
      "transaction_hash": "0xabc123...",
      "usd_value": 50.0
    }
  ],
  "pagination": {
    "total": 45,
    "limit": 20,
    "offset": 0,
    "has_more": true
  },
  "summary": {
    "total_paid": 79.99,
    "total_crypto_paid": 50.0,
    "payments_count": 2,
    "successful_payments": 2
  }
}
```

### Возврат платежа

**POST** `/payments/{payment_id}/refund`

Выполняет возврат платежа.

**Запрос:**
```json
{
  "amount": 29.99,              // Полный возврат
  "reason": "requested_by_customer",
  "metadata": {
    "refund_reason": "Клиент не удовлетворен сервисом"
  }
}
```

**Ответ (200):**
```json
{
  "refund": {
    "id": "ref_001",
    "payment_id": "pay_001",
    "amount": 29.99,
    "currency": "usd",
    "status": "succeeded",
    "reason": "requested_by_customer",
    "created_at": "2025-01-01T00:00:00Z"
  },
  "original_payment": {
    "id": "pay_001",
    "status": "partially_refunded",
    "refunded_amount": 29.99
  }
}
```

### Получение тарифов

**GET** `/pricing`

Возвращает актуальные тарифы и цены.

**Ответ (200):**
```json
{
  "quantum_simulation_pricing": {
    "1": 0.001,
    "2": 0.002,
    "4": 0.005,
    "8": 0.01,
    "16": 0.02,
    "32": 0.05
  },
  "subscription_plans": [
    {
      "id": "basic_monthly",
      "name": "Базовый",
      "price": 9.99,
      "currency": "usd",
      "interval": "month",
      "features": [
        "10 симуляций в день",
        "До 4 кубитов",
        "Поддержка по email"
      ],
      "popular": false
    },
    {
      "id": "premium_monthly",
      "name": "Премиум",
      "price": 29.99,
      "currency": "usd",
      "interval": "month",
      "features": [
        "100 симуляций в день",
        "До 16 кубитов",
        "Приоритетная поддержка",
        "Доступ к API"
      ],
      "popular": true
    },
    {
      "id": "enterprise_monthly",
      "name": "Корпоративный",
      "price": 99.99,
      "currency": "usd",
      "interval": "month",
      "features": [
        "Безлимитные симуляции",
        "До 32 кубитов",
        "Поддержка 24/7",
        "Кастомные алгоритмы"
      ],
      "popular": false
    }
  ],
  "crypto_discounts": {
    "BTC": 0.05,    // 5% скидка
    "ETH": 0.03,    // 3% скидка
    "XMR": 0.1      // 10% скидка за приватность
  },
  "last_updated": "2025-01-01T00:00:00Z"
}
```

### Получение криптовалютных адресов

**GET** `/crypto/wallets`

Возвращает адреса криптовалютных кошельков для платежей.

**Ответ (200):**
```json
{
  "wallets": {
    "BTC": {
      "address": "bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh",
      "balance": 0.123456,
      "minimum_payment": 0.0001
    },
    "ETH": {
      "address": "0x742d35Cc6635C0532925a3b8D0C8B4E3f0E5f5B8",
      "balance": 2.5,
      "minimum_payment": 0.001
    },
    "XMR": {
      "address": "888tNkZrjZ9cKyuxkHh7EQCqY3bR3sAkhJ6E8B5Q7c8d9e0f1g2h3i4j5k6l7m8n9o0p1q2r3s4t5",
      "balance": 15.7,
      "minimum_payment": 0.01
    },
    "USDT": {
      "address": "0x742d35Cc6635C0532925a3b8D0C8B4E3f0E5f5B8",
      "balance": 1000.0,
      "minimum_payment": 1.0
    }
  },
  "exchange_rates": {
    "BTC_USD": 45000.0,
    "ETH_USD": 2800.0,
    "XMR_USD": 180.0,
    "USDT_USD": 1.0
  },
  "last_updated": "2025-01-01T12:00:00Z"
}
```

### Создание инвойса

**POST** `/invoices/create`

Создает инвойс за использование сервиса.

**Запрос:**
```json
{
  "customer_id": "user_123",
  "items": [
    {
      "description": "Квантовая симуляция - 16 кубитов",
      "quantity": 5,
      "unit_price": 0.02,
      "currency": "usd"
    },
    {
      "description": "Премиум поддержка",
      "quantity": 1,
      "unit_price": 10.0,
      "currency": "usd"
    }
  ],
  "due_date": "2025-02-01",
  "auto_charge": true
}
```

**Ответ (201):**
```json
{
  "invoice": {
    "id": "inv_001",
    "customer_id": "user_123",
    "status": "draft",
    "subtotal": 0.1,
    "tax": 0.0,
    "total": 0.1,
    "currency": "usd",
    "items": [
      {
        "id": "item_001",
        "description": "Квантовая симуляция - 16 кубитов",
        "quantity": 5,
        "unit_price": 0.02,
        "amount": 0.1
      }
    ],
    "created_at": "2025-01-01T00:00:00Z",
    "due_date": "2025-02-01T00:00:00Z"
  },
  "payment_url": "https://yourapp.com/pay/inv_001"
}
```

### Получение активных подписок

**GET** `/subscriptions/active`

Возвращает активные подписки пользователя.

**Ответ (200):**
```json
{
  "subscriptions": [
    {
      "id": "sub_001",
      "plan_name": "Премиум",
      "status": "active",
      "amount": 29.99,
      "currency": "usd",
      "billing_cycle": "monthly",
      "current_period_start": "2025-01-01T00:00:00Z",
      "current_period_end": "2025-02-01T00:00:00Z",
      "auto_renew": true,
      "cancel_at_period_end": false,
      "next_billing_date": "2025-02-01T00:00:00Z"
    }
  ],
  "total_active": 1,
  "total_amount": 29.99
}
```

### Вебхуки для обработки платежей

**POST** `/webhooks/stripe`

Обрабатывает вебхуки от Stripe.

**Заголовки:**
```
Stripe-Signature: t=1640995200,v1=signature...
Content-Type: application/json
```

**Тело запроса (пример от Stripe):**
```json
{
  "id": "evt_1ABC123def456",
  "object": "event",
  "type": "payment_intent.succeeded",
  "data": {
    "object": {
      "id": "pi_1ABC123def456",
      "amount": 2999,
      "currency": "usd",
      "status": "succeeded",
      "metadata": {
        "user_id": "user_123",
        "simulation_id": "sim_001"
      }
    }
  }
}
```

**Ответ (200):**
```json
{
  "received": true,
  "event_type": "payment_intent.succeeded",
  "processed": true,
  "actions_taken": [
    "user_credits_updated",
    "simulation_unlocked",
    "notification_sent"
  ]
}
```

## Криптовалютные платежи

### Поддерживаемые криптовалюты

| Криптовалюта | Адрес | Мин. сумма | Скидка |
|-------------|-------|------------|--------|
| Bitcoin (BTC) | bc1q... | 0.0001 BTC | 5% |
| Ethereum (ETH) | 0x742... | 0.001 ETH | 3% |
| Monero (XMR) | 888tNk... | 0.01 XMR | 10% |
| Tether (USDT) | 0x742... | 1.0 USDT | 2% |

### Процесс криптоплатежа

1. **Создание платежа**: Клиент создает платеж с указанием суммы и валюты
2. **Получение адреса**: Сервер возвращает уникальный адрес для платежа
3. **Оплата**: Клиент отправляет криптовалюту на указанный адрес
4. **Подтверждение**: Система отслеживает транзакцию в блокчейне
5. **Активация**: После подтверждения сервис активируется

## Управление подписками

### Доступные тарифные планы

#### Базовый (Basic) - $9.99/месяц
- 10 симуляций в день
- До 4 кубитов
- Поддержка по email
- Стандартные алгоритмы

#### Премиум (Premium) - $29.99/месяц
- 100 симуляций в день
- До 16 кубитов
- Приоритетная поддержка
- Доступ к API
- Расширенные алгоритмы

#### Корпоративный (Enterprise) - $99.99/месяц
- Безлимитные симуляции
- До 32 кубитов
- Поддержка 24/7
- Кастомные алгоритмы
- Выделенная инфраструктура

### Управление подпиской

**Изменение тарифного плана:**
```json
POST /subscriptions/{id}/change-plan
{
  "new_plan_id": "enterprise_monthly",
  "proration_mode": "immediate"
}
```

**Пауза подписки:**
```json
POST /subscriptions/{id}/pause
{
  "pause_until": "2025-03-01"
}
```

## Аналитика платежей

### Статистика платежей

**GET** `/analytics/payments`

Возвращает аналитику платежей.

**Параметры запроса:**
- `period` (string): Период (day, week, month, year)
- `from_date` (string): Начальная дата
- `to_date` (string): Конечная дата

**Ответ (200):**
```json
{
  "period": "month",
  "total_revenue": 15420.50,
  "total_payments": 234,
  "successful_payments": 228,
  "failed_payments": 6,
  "success_rate": 0.974,
  "payment_methods": {
    "stripe": 180,
    "crypto": 48,
    "paypal": 6
  },
  "crypto_breakdown": {
    "BTC": 25,
    "ETH": 15,
    "XMR": 6,
    "USDT": 2
  },
  "average_payment": 65.90,
  "top_plans": [
    {
      "plan_id": "premium_monthly",
      "count": 120,
      "revenue": 3598.80
    }
  ],
  "daily_revenue": [
    {"date": "2025-01-01", "revenue": 450.0},
    {"date": "2025-01-02", "revenue": 680.0}
  ],
  "currency": "usd"
}
```

## Примеры кода

### Python

```python
import requests
import json

class PaymentAPI:
    def __init__(self, base_url, token):
        self.base_url = base_url
        self.token = token
        self.headers = {
            'Authorization': f'Bearer {token}',
            'Content-Type': 'application/json'
        }

    def create_stripe_payment(self, amount, currency='usd', description=''):
        """Создание платежа через Stripe"""
        data = {
            'amount': amount,  # в центах
            'currency': currency,
            'description': description
        }
        
        response = requests.post(
            f'{self.base_url}/payments/stripe/payment-intent',
            headers=self.headers,
            json=data
        )
        return response.json()

    def create_crypto_payment(self, amount_usd, currency='BTC'):
        """Создание криптовалютного платежа"""
        data = {
            'amount_usd': amount_usd,
            'currency': currency,
            'description': 'Оплата за квантовые вычисления'
        }
        
        response = requests.post(
            f'{self.base_url}/payments/crypto/create-payment',
            headers=self.headers,
            json=data
        )
        return response.json()

    def create_subscription(self, plan_id, payment_method='stripe'):
        """Создание подписки"""
        data = {
            'plan_id': plan_id,
            'payment_method': payment_method,
            'billing_cycle': 'monthly',
            'auto_renew': True
        }
        
        response = requests.post(
            f'{self.base_url}/payments/subscriptions/create',
            headers=self.headers,
            json=data
        )
        return response.json()

    def get_payment_history(self, limit=20, offset=0):
        """Получение истории платежей"""
        params = {'limit': limit, 'offset': offset}
        
        response = requests.get(
            f'{self.base_url}/payments/history',
            headers=self.headers,
            params=params
        )
        return response.json()

    def refund_payment(self, payment_id, amount=None, reason='requested_by_customer'):
        """Возврат платежа"""
        data = {
            'amount': amount,
            'reason': reason
        }
        
        response = requests.post(
            f'{self.base_url}/payments/{payment_id}/refund',
            headers=self.headers,
            json=data
        )
        return response.json()

    def get_pricing(self):
        """Получение актуальных тарифов"""
        response = requests.get(
            f'{self.base_url}/payments/pricing',
            headers=self.headers
        )
        return response.json()

    def get_crypto_wallets(self):
        """Получение криптовалютных адресов"""
        response = requests.get(
            f'{self.base_url}/payments/crypto/wallets',
            headers=self.headers
        )
        return response.json()

# Использование
payment_api = PaymentAPI('https://api.x0tta6bl4.com/api/v1', 'your_token')

# Создание платежа через Stripe
stripe_payment = payment_api.create_stripe_payment(
    amount=2999,  # $29.99
    description='Премиум подписка на месяц'
)
print(f"Payment Intent ID: {stripe_payment['payment_intent']['id']}")

# Создание криптоплатежа
crypto_payment = payment_api.create_crypto_payment(
    amount_usd=50.0,
    currency='BTC'
)
print(f"Bitcoin адрес: {crypto_payment['payment']['address']}")
print(f"Сумма к оплате: {crypto_payment['payment']['amount_crypto']} BTC")

# Создание подписки
subscription = payment_api.create_subscription('premium_monthly')
print(f"Подписка создана: {subscription['subscription']['id']}")

# Получение истории платежей
history = payment_api.get_payment_history(limit=10)
print(f"Всего платежей: {history['pagination']['total']}")

# Получение тарифов
pricing = payment_api.get_pricing()
print(f"Премиум тариф: ${pricing['subscription_plans'][1]['price']}")
```

### JavaScript (Node.js)

```javascript
const axios = require('axios');

class PaymentsAPI {
    constructor(baseURL, token) {
        this.baseURL = baseURL;
        this.token = token;
        this.client = axios.create({
            baseURL: baseURL,
            headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json'
            }
        });
    }

    async createStripePayment(amount, currency = 'usd', description = '') {
        try {
            const response = await this.client.post('/payments/stripe/payment-intent', {
                amount: amount,
                currency: currency,
                description: description
            });
            return response.data;
        } catch (error) {
            console.error('Ошибка создания Stripe платежа:', error.response.data);
            throw error;
        }
    }

    async createCryptoPayment(amountUSD, currency = 'BTC') {
        try {
            const response = await this.client.post('/payments/crypto/create-payment', {
                amount_usd: amountUSD,
                currency: currency,
                description: 'Оплата за квантовые вычисления'
            });
            return response.data;
        } catch (error) {
            console.error('Ошибка создания криптоплатежа:', error.response.data);
            throw error;
        }
    }

    async createSubscription(planId, paymentMethod = 'stripe') {
        try {
            const response = await this.client.post('/payments/subscriptions/create', {
                plan_id: planId,
                payment_method: paymentMethod,
                billing_cycle: 'monthly',
                auto_renew: true
            });
            return response.data;
        } catch (error) {
            console.error('Ошибка создания подписки:', error.response.data);
            throw error;
        }
    }

    async getPaymentHistory(params = {}) {
        try {
            const response = await this.client.get('/payments/history', { params });
            return response.data;
        } catch (error) {
            console.error('Ошибка получения истории платежей:', error.response.data);
            throw error;
        }
    }

    async refundPayment(paymentId, amount = null, reason = 'requested_by_customer') {
        try {
            const response = await this.client.post(`/payments/${paymentId}/refund`, {
                amount: amount,
                reason: reason
            });
            return response.data;
        } catch (error) {
            console.error('Ошибка возврата платежа:', error.response.data);
            throw error;
        }
    }

    async getPricing() {
        try {
            const response = await this.client.get('/payments/pricing');
            return response.data;
        } catch (error) {
            console.error('Ошибка получения тарифов:', error.response.data);
            throw error;
        }
    }

    async getCryptoWallets() {
        try {
            const response = await this.client.get('/payments/crypto/wallets');
            return response.data;
        } catch (error) {
            console.error('Ошибка получения криптоадресов:', error.response.data);
            throw error;
        }
    }

    async cancelSubscription(subscriptionId, cancelAtPeriodEnd = true) {
        try {
            const response = await this.client.post(`/payments/subscriptions/${subscriptionId}/cancel`, {
                cancel_at_period_end: cancelAtPeriodEnd,
                cancellation_reason: 'Не устраивает цена'
            });
            return response.data;
        } catch (error) {
            console.error('Ошибка отмены подписки:', error.response.data);
            throw error;
        }
    }

    async getPaymentAnalytics(period = 'month') {
        try {
            const response = await this.client.get('/payments/analytics/payments', {
                params: { period: period }
            });
            return response.data;
        } catch (error) {
            console.error('Ошибка получения аналитики:', error.response.data);
            throw error;
        }
    }
}

// Использование
async function paymentsExample() {
    const payments = new PaymentsAPI('https://api.x0tta6bl4.com/api/v1', 'your_token');

    try {
        // Получение тарифов
        const pricing = await payments.getPricing();
        console.log('Доступные тарифы:', pricing.subscription_plans.map(p => p.name));

        // Создание подписки
        const subscription = await payments.createSubscription('premium_monthly');
        console.log(`Подписка создана: ${subscription.subscription.id}`);

        // Создание криптоплатежа
        const cryptoPayment = await payments.createCryptoPayment(50.0, 'BTC');
        console.log(`BTC адрес для оплаты: ${cryptoPayment.payment.address}`);
        console.log(`Сумма: ${cryptoPayment.payment.amount_crypto} BTC`);

        // Получение истории платежей
        const history = await payments.getPaymentHistory({ limit: 5 });
        console.log(`Всего платежей: ${history.pagination.total}`);

        // Аналитика платежей
        const analytics = await payments.getPaymentAnalytics('month');
        console.log(`Доход за месяц: $${analytics.total_revenue}`);

    } catch (error) {
        console.error('Ошибка в примере платежей:', error.message);
    }
}

// Запуск примера
paymentsExample();
```

### PHP

```php
<?php

class PaymentsAPI {
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

    public function createStripePayment($amount, $currency = 'usd', $description = '') {
        $data = [
            'amount' => $amount,
            'currency' => $currency,
            'description' => $description
        ];
        return $this->makeRequest('POST', '/payments/stripe/payment-intent', $data);
    }

    public function createCryptoPayment($amountUSD, $currency = 'BTC') {
        $data = [
            'amount_usd' => $amountUSD,
            'currency' => $currency,
            'description' => 'Оплата за квантовые вычисления'
        ];
        return $this->makeRequest('POST', '/payments/crypto/create-payment', $data);
    }

    public function createSubscription($planId, $paymentMethod = 'stripe') {
        $data = [
            'plan_id' => $planId,
            'payment_method' => $paymentMethod,
            'billing_cycle' => 'monthly',
            'auto_renew' => true
        ];
        return $this->makeRequest('POST', '/payments/subscriptions/create', $data);
    }

    public function getPaymentHistory($params = []) {
        return $this->makeRequest('GET', '/payments/history', null, $params);
    }

    public function refundPayment($paymentId, $amount = null, $reason = 'requested_by_customer') {
        $data = [
            'amount' => $amount,
            'reason' => $reason
        ];
        return $this->makeRequest('POST', "/payments/{$paymentId}/refund", $data);
    }

    public function getPricing() {
        return $this->makeRequest('GET', '/payments/pricing');
    }

    public function getCryptoWallets() {
        return $this->makeRequest('GET', '/payments/crypto/wallets');
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
    $payments = new PaymentsAPI(
        'https://api.x0tta6bl4.com/api/v1',
        'your_jwt_token'
    );

    // Получение тарифов
    $pricing = $payments->getPricing();
    echo "Премиум тариф: $" . $pricing['subscription_plans'][1]['price'] . "\n";

    // Создание подписки
    $subscription = $payments->createSubscription('premium_monthly');
    echo "Подписка создана: " . $subscription['subscription']['id'] . "\n";

    // Создание криптоплатежа
    $cryptoPayment = $payments->createCryptoPayment(25.0, 'ETH');
    echo "ETH адрес: " . $cryptoPayment['payment']['address'] . "\n";
    echo "Сумма: " . $cryptoPayment['payment']['amount_crypto'] . " ETH\n";

    // История платежей
    $history = $payments->getPaymentHistory(['limit' => 10]);
    echo "Всего платежей: " . $history['pagination']['total'] . "\n";

    // Криптоадреса
    $wallets = $payments->getCryptoWallets();
    echo "BTC адрес: " . $wallets['wallets']['BTC']['address'] . "\n";

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
    "code": "INVALID_AMOUNT",
    "message": "Неверная сумма платежа",
    "details": {
      "provided": -100,
      "minimum": 0.01,
      "currency": "usd"
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

### 402 - Требуется оплата

```json
{
  "error": {
    "code": "PAYMENT_REQUIRED",
    "message": "Требуется оплата для доступа к ресурсу",
    "details": {
      "required_amount": 29.99,
      "payment_url": "https://checkout.stripe.com/pay/..."
    }
  }
}
```

### 402 - Платеж отклонен

```json
{
  "error": {
    "code": "PAYMENT_DECLINED",
    "message": "Платеж отклонен",
    "details": {
      "reason": "insufficient_funds",
      "payment_method": "card_ending_4242"
    }
  }
}
```

### 404 - Платеж не найден

```json
{
  "error": {
    "code": "PAYMENT_NOT_FOUND",
    "message": "Платеж не найден",
    "details": {
      "payment_id": "non_existent_payment"
    }
  }
}
```

## Лучшие практики

1. **Валидация платежей**: Всегда проверяйте статус платежа перед активацией сервиса
2. **Обработка ошибок**: Реализуйте retry логику для неудачных платежей
3. **Вебхуки**: Используйте вебхуки для получения уведомлений о статусе платежей
4. **Безопасность**: Никогда не храните платежную информацию на клиенте
5. **Мониторинг**: Отслеживайте успешность платежей и анализируйте неудачные транзакции
6. **Тестирование**: Используйте тестовые ключи Stripe для разработки

## Безопасность платежей

- **PCI DSS**: Соответствие стандартам безопасности платежных карт
- **Шифрование**: Все платежные данные шифруются в соответствии с PCI DSS
- **Токенизация**: Использование токенов вместо хранения данных карт
- **Мониторинг**: Постоянный мониторинг подозрительной активности
- **Фрод-защита**: Автоматическое обнаружение и предотвращение мошенничества

---

*Документация обновлена: 30 сентября 2025*