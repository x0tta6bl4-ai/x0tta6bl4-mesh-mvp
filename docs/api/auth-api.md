# Auth API - Аутентификация и авторизация

## Обзор

Auth API предоставляет полный набор функций для аутентификации, авторизации и управления пользователями в системе x0tta6bl4. Система использует JWT токены с φ-оптимизацией и ролевую модель доступа (RBAC).

## Базовая информация

- **Базовый URL**: `https://api.x0tta6bl4.com/api/v1/auth`
- **Аутентификация**: Не требуется для публичных эндпоинтов
- **Формат**: JSON

## Модели данных

### Роли пользователей

```typescript
enum Role {
  SUPER_ADMIN = "super_admin",    // Полный доступ ко всем функциям
  ADMIN = "admin",               // Администрирование пользователей и контента
  MODERATOR = "moderator",       // Модерация контента
  USER = "user",                // Обычный пользователь
  GUEST = "guest"               // Гостевой доступ
}
```

### Статусы пользователей

```typescript
enum UserStatus {
  ACTIVE = "active",           // Активный пользователь
  INACTIVE = "inactive",       // Неактивный пользователь
  SUSPENDED = "suspended",     // Заблокированный пользователь
  PENDING = "pending"          // Ожидает подтверждения
}
```

## Эндпоинты

### Регистрация пользователя

**POST** `/register`

Регистрирует нового пользователя в системе.

**Запрос:**
```json
{
  "username": "string (3-50 символов)",
  "email": "user@example.com",
  "password": "string (мин. 8 символов)",
  "full_name": "Полное имя пользователя (опционально)"
}
```

**Ответ (201):**
```json
{
  "user": {
    "id": "user_123",
    "username": "johndoe",
    "email": "john@example.com",
    "full_name": "John Doe",
    "status": "active",
    "roles": ["user"],
    "created_at": "2025-01-01T00:00:00Z",
    "updated_at": "2025-01-01T00:00:00Z"
  },
  "message": "Пользователь успешно зарегистрирован"
}
```

**Пример cURL:**
```bash
curl -X POST https://api.x0tta6bl4.com/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "johndoe",
    "email": "john@example.com",
    "password": "securepassword123",
    "full_name": "John Doe"
  }'
```

### Вход в систему

**POST** `/login`

Аутентифицирует пользователя и возвращает JWT токены.

**Запрос:**
```json
{
  "username": "johndoe",
  "password": "securepassword123"
}
```

**Ответ (200):**
```json
{
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "token_type": "bearer",
  "expires_in": 1800,
  "user": {
    "id": "user_123",
    "username": "johndoe",
    "email": "john@example.com",
    "full_name": "John Doe",
    "roles": ["user"],
    "status": "active"
  }
}
```

**Пример cURL:**
```bash
curl -X POST https://api.x0tta6bl4.com/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "johndoe",
    "password": "securepassword123"
  }'
```

### Обновление токена

**POST** `/refresh`

Обновляет access токен с помощью refresh токена.

**Заголовки:**
```
Authorization: Bearer <refresh_token>
```

**Ответ (200):**
```json
{
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "token_type": "bearer",
  "expires_in": 1800
}
```

### Выход из системы

**POST** `/logout`

Отзывает refresh токен пользователя.

**Заголовки:**
```
Authorization: Bearer <refresh_token>
```

**Ответ (200):**
```json
{
  "message": "Успешный выход из системы"
}
```

### Получение профиля пользователя

**GET** `/me`

Возвращает информацию о текущем пользователе.

**Заголовки:**
```
Authorization: Bearer <access_token>
```

**Ответ (200):**
```json
{
  "id": "user_123",
  "username": "johndoe",
  "email": "john@example.com",
  "full_name": "John Doe",
  "status": "active",
  "roles": ["user"],
  "created_at": "2025-01-01T00:00:00Z",
  "updated_at": "2025-01-01T00:00:00Z",
  "last_login": "2025-01-01T12:00:00Z"
}
```

### Обновление профиля

**PUT** `/me`

Обновляет информацию о пользователе.

**Заголовки:**
```
Authorization: Bearer <access_token>
```

**Запрос:**
```json
{
  "full_name": "John Doe Updated",
  "email": "john.doe@example.com"
}
```

**Ответ (200):**
```json
{
  "user": {
    "id": "user_123",
    "username": "johndoe",
    "email": "john.doe@example.com",
    "full_name": "John Doe Updated",
    "status": "active",
    "roles": ["user"],
    "updated_at": "2025-01-01T13:00:00Z"
  },
  "message": "Профиль успешно обновлен"
}
```

### Смена пароля

**POST** `/change-password`

Изменяет пароль пользователя.

**Заголовки:**
```
Authorization: Bearer <access_token>
```

**Запрос:**
```json
{
  "current_password": "oldpassword",
  "new_password": "newsecurepassword123"
}
```

**Ответ (200):**
```json
{
  "message": "Пароль успешно изменен"
}
```

## Администрирование пользователей

### Получение списка пользователей

**GET** `/admin/users`

Возвращает список всех пользователей (только для администраторов).

**Заголовки:**
```
Authorization: Bearer <access_token>
```

**Параметры запроса:**
- `page` (int): Номер страницы (по умолчанию: 1)
- `per_page` (int): Количество пользователей на странице (по умолчанию: 20)
- `status` (string): Фильтр по статусу
- `role` (string): Фильтр по роли
- `search` (string): Поиск по имени/email

**Ответ (200):**
```json
{
  "users": [
    {
      "id": "user_123",
      "username": "johndoe",
      "email": "john@example.com",
      "full_name": "John Doe",
      "status": "active",
      "roles": ["user"],
      "created_at": "2025-01-01T00:00:00Z",
      "last_login": "2025-01-01T12:00:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "per_page": 20,
    "total": 150,
    "total_pages": 8
  }
}
```

### Получение пользователя по ID

**GET** `/admin/users/{user_id}`

Возвращает информацию о конкретном пользователе.

**Заголовки:**
```
Authorization: Bearer <access_token>
```

**Ответ (200):**
```json
{
  "id": "user_123",
  "username": "johndoe",
  "email": "john@example.com",
  "full_name": "John Doe",
  "status": "active",
  "roles": ["user"],
  "created_at": "2025-01-01T00:00:00Z",
  "updated_at": "2025-01-01T00:00:00Z",
  "last_login": "2025-01-01T12:00:00Z",
  "login_attempts": 0
}
```

### Обновление пользователя

**PUT** `/admin/users/{user_id}`

Обновляет информацию о пользователе (только для администраторов).

**Заголовки:**
```
Authorization: Bearer <access_token>
```

**Запрос:**
```json
{
  "full_name": "Updated Name",
  "email": "newemail@example.com",
  "status": "active",
  "roles": ["user", "moderator"]
}
```

**Ответ (200):**
```json
{
  "user": {
    "id": "user_123",
    "username": "johndoe",
    "email": "newemail@example.com",
    "full_name": "Updated Name",
    "status": "active",
    "roles": ["user", "moderator"],
    "updated_at": "2025-01-01T13:00:00Z"
  },
  "message": "Пользователь успешно обновлен"
}
```

### Удаление пользователя

**DELETE** `/admin/users/{user_id}`

Удаляет пользователя из системы (только для администраторов).

**Заголовки:**
```
Authorization: Bearer <access_token>
```

**Ответ (200):**
```json
{
  "message": "Пользователь успешно удален"
}
```

### Блокировка пользователя

**POST** `/admin/users/{user_id}/suspend`

Блокирует пользователя (только для администраторов).

**Заголовки:**
```
Authorization: Bearer <access_token>
```

**Запрос:**
```json
{
  "reason": "Нарушение правил использования",
  "duration_hours": 24
}
```

**Ответ (200):**
```json
{
  "message": "Пользователь заблокирован",
  "suspended_until": "2025-01-02T13:00:00Z"
}
```

### Разблокировка пользователя

**POST** `/admin/users/{user_id}/activate`

Разблокирует пользователя (только для администраторов).

**Заголовки:**
```
Authorization: Bearer <access_token>
```

**Ответ (200):**
```json
{
  "message": "Пользователь разблокирован"
}
```

## Права доступа

### Проверка прав

**GET** `/permissions/check`

Проверяет наличие прав у текущего пользователя.

**Заголовки:**
```
Authorization: Bearer <access_token>
```

**Параметры запроса:**
- `permission` (string): Право для проверки

**Ответ (200):**
```json
{
  "has_permission": true,
  "permission": "user:create",
  "user_roles": ["admin"]
}
```

### Получение прав пользователя

**GET** `/me/permissions`

Возвращает все права текущего пользователя.

**Заголовки:**
```
Authorization: Bearer <access_token>
```

**Ответ (200):**
```json
{
  "permissions": [
    "user:create",
    "user:read",
    "content:create",
    "content:read"
  ],
  "roles": ["admin"]
}
```

## Безопасность

### Многофакторная аутентификация (MFA)

**POST** `/mfa/setup`

Настраивает MFA для пользователя.

**Заголовки:**
```
Authorization: Bearer <access_token>
```

**Ответ (200):**
```json
{
  "qr_code": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAA...",
  "secret": "JBSWY3DPEHPK3PXP",
  "backup_codes": ["abc123de", "fgh456hi"]
}
```

**POST** `/mfa/verify`

Подтверждает настройку MFA.

**Заголовки:**
```
Authorization: Bearer <access_token>
```

**Запрос:**
```json
{
  "token": "123456",
  "backup_code": "abc123de"
}
```

### Восстановление пароля

**POST** `/forgot-password`

Отправляет письмо для восстановления пароля.

**Запрос:**
```json
{
  "email": "john@example.com"
}
```

**Ответ (200):**
```json
{
  "message": "Письмо для восстановления отправлено"
}
```

**POST** `/reset-password`

Устанавливает новый пароль.

**Запрос:**
```json
{
  "token": "reset_token_from_email",
  "new_password": "newsecurepassword123"
}
```

## Примеры кода

### Python

```python
import requests

# Регистрация
response = requests.post('https://api.x0tta6bl4.com/api/v1/auth/register', json={
    'username': 'johndoe',
    'email': 'john@example.com',
    'password': 'securepassword123'
})

# Вход
response = requests.post('https://api.x0tta6bl4.com/api/v1/auth/login', json={
    'username': 'johndoe',
    'password': 'securepassword123'
})

tokens = response.json()
access_token = tokens['access_token']

# Использование токена
headers = {'Authorization': f'Bearer {access_token}'}
user_response = requests.get('https://api.x0tta6bl4.com/api/v1/auth/me', headers=headers)
```

### JavaScript (Node.js)

```javascript
const axios = require('axios');

// Регистрация
const registerResponse = await axios.post('https://api.x0tta6bl4.com/api/v1/auth/register', {
  username: 'johndoe',
  email: 'john@example.com',
  password: 'securepassword123'
});

// Вход
const loginResponse = await axios.post('https://api.x0tta6bl4.com/api/v1/auth/login', {
  username: 'johndoe',
  password: 'securepassword123'
});

const { access_token } = loginResponse.data;

// Использование токена
const userResponse = await axios.get('https://api.x0tta6bl4.com/api/v1/auth/me', {
  headers: {
    'Authorization': `Bearer ${access_token}`
  }
});
```

### PHP

```php
<?php

// Регистрация
$data = [
    'username' => 'johndoe',
    'email' => 'john@example.com',
    'password' => 'securepassword123'
];

$context = stream_context_create([
    'http' => [
        'method' => 'POST',
        'header' => 'Content-Type: application/json',
        'content' => json_encode($data)
    ]
]);

$response = file_get_contents('https://api.x0tta6bl4.com/api/v1/auth/register', false, $context);

// Вход
$loginData = [
    'username' => 'johndoe',
    'password' => 'securepassword123'
];

$context = stream_context_create([
    'http' => [
        'method' => 'POST',
        'header' => 'Content-Type: application/json',
        'content' => json_encode($loginData)
    ]
]);

$loginResponse = file_get_contents('https://api.x0tta6bl4.com/api/v1/auth/login', false, $context);
$tokens = json_decode($loginResponse, true);
$accessToken = $tokens['access_token'];

// Использование токена
$context = stream_context_create([
    'http' => [
        'method' => 'GET',
        'header' => 'Authorization: Bearer ' . $accessToken
    ]
]);

$userResponse = file_get_contents('https://api.x0tta6bl4.com/api/v1/auth/me', false, $context);
?>
```

## Ошибки

### 400 - Неверный запрос

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Неверные данные запроса",
    "details": {
      "email": ["Неверный формат email"]
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
    "message": "Недостаточно прав для выполнения операции"
  }
}
```

### 429 - Слишком много запросов

```json
{
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Превышен лимит запросов",
    "details": {
      "retry_after": 3600
    }
  }
}
```

## Лучшие практики

1. **Хранение токенов**: Сохраняйте токены в безопасном хранилище (httpOnly cookies)
2. **Обновление токенов**: Реализуйте автоматическое обновление access токенов
3. **Безопасность**: Используйте HTTPS для всех запросов
4. **Валидация**: Всегда валидируйте данные на клиенте и сервере
5. **Логирование**: Логируйте неудачные попытки входа для мониторинга безопасности

---

*Документация обновлена: 30 сентября 2025*