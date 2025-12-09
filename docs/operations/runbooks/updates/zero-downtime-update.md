# Zero-downtime обновление x0tta6bl4

## Обзор

Этот runbook описывает процедуру обновления компонентов системы x0tta6bl4 без простоев с использованием стратегий rolling update и blue-green deployment.

## Требования

### Доступы
- kubectl настроен для всех кластеров
- Доступ к Docker registry
- Доступ к системам мониторинга
- Доступ к CI/CD системам

### Инструменты
- kubectl >= 1.28
- helm >= 3.10
- curl для тестирования
- jq для обработки JSON

### Предварительные условия
- Резервные копии созданы
- Мониторинг активен
- Health check endpoints настроены
- Rolling update стратегии настроены

## Шаги выполнения

### Шаг 1: Подготовка к обновлению (15 минут)

```bash
#!/bin/bash
# prepare-update.sh

UPDATE_VERSION=$1
COMPONENT=${2:-api-gateway}

echo "=== Подготовка к обновлению $COMPONENT до версии $UPDATE_VERSION ==="

# Проверка текущей версии
CURRENT_VERSION=$(kubectl --context=eks-us-east-1 get deployment $COMPONENT -n x0tta6bl4-system -o jsonpath='{.spec.template.spec.containers[0].image}' | cut -d: -f2)
echo "Текущая версия: $CURRENT_VERSION"
echo "Целевая версия: $UPDATE_VERSION"

# Создание резервной копии текущей конфигурации
kubectl --context=eks-us-east-1 get deployment $COMPONENT -n x0tta6bl4-system -o yaml > "backup-$(date +%Y%m%d-%H%M%S)-$COMPONENT.yaml"

# Проверка доступности новой версии в registry
curl -f "https://registry.x0tta6bl4.com/v2/x0tta6bl4/$COMPONENT/manifests/$UPDATE_VERSION" || {
    echo "Версия $UPDATE_VERSION не найдена в registry"
    exit 1
}

echo "Подготовка к обновлению завершена"
```

### Шаг 2: Тестирование обновления в staging (20 минут)

```bash
#!/bin/bash
# test-update-staging.sh

echo "=== Тестирование обновления в staging окружении ==="

# Развертывание в staging namespace
kubectl --context=eks-us-east-1 apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: $COMPONENT-staging
  namespace: staging
spec:
  replicas: 1
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  selector:
    matchLabels:
      app: $COMPONENT-staging
  template:
    metadata:
      labels:
        app: $COMPONENT-staging
    spec:
      containers:
      - name: $COMPONENT
        image: x0tta6bl4/$COMPONENT:$UPDATE_VERSION
        ports:
        - containerPort: 8000
EOF

# Ожидание готовности staging версии
kubectl --context=eks-us-east-1 wait --for=condition=available --timeout=300s deployment/$COMPONENT-staging -n staging

# Тестирование staging версии
kubectl --context=eks-us-east-1 exec deployment/$COMPONENT-staging -n staging -- \
    curl -f http://localhost:8000/health

# Интеграционные тесты
kubectl --context=eks-us-east-1 exec deployment/test-runner -n staging -- \
    ./run-integration-tests.sh $COMPONENT $UPDATE_VERSION

echo "Тестирование в staging завершено"
```

### Шаг 3: Обновление в основном регионе (25 минут)

#### 3.1 Обновление API Gateway

```bash
#!/bin/bash
# update-api-gateway.sh

echo "=== Обновление API Gateway в основном регионе ==="

# Обновление deployment стратегии
kubectl --context=eks-us-east-1 patch deployment api-gateway -n x0tta6bl4-system -p "
spec:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 0
"

# Обновление образа
kubectl --context=eks-us-east-1 set image deployment/api-gateway api-gateway=x0tta6bl4/api-gateway:$UPDATE_VERSION -n x0tta6bl4-system

# Мониторинг процесса обновления
kubectl --context=eks-us-east-1 rollout status deployment/api-gateway -n x0tta6bl4-system --timeout=600s

# Проверка работоспособности после обновления
for i in {1..10}; do
    if curl -f https://api.x0tta6bl4.com/health; then
        echo "API Gateway успешно обновлен"
        break
    fi
    sleep 30
done

echo "Обновление API Gateway завершено"
```

#### 3.2 Обновление агентских сервисов

```bash
#!/bin/bash
# update-agents.sh

echo "=== Обновление агентских сервисов ==="

# Обновление культурных агентов
kubectl --context=eks-us-east-1 set image deployment/cultural-agents cultural-agents=x0tta6bl4/cultural-agents:$UPDATE_VERSION -n x0tta6bl4-system
kubectl --context=eks-us-east-1 rollout status deployment/cultural-agents -n x0tta6bl4-system --timeout=600s

# Обновление бизнес-агентов
kubectl --context=eks-us-east-1 set image deployment/business-agents business-agents=x0tta6bl4/business-agents:$UPDATE_VERSION -n x0tta6bl4-system
kubectl --context=eks-us-east-1 rollout status deployment/business-agents -n x0tta6bl4-system --timeout=600s

# Обновление локальных агентов
kubectl --context=k3s-moscow set image deployment/cultural-agents-moscow cultural-agents=x0tta6bl4/cultural-agents:$UPDATE_VERSION -n x0tta6bl4-system
kubectl --context=k3s-spb set image deployment/cultural-agents-spb cultural-agents=x0tta6bl4/cultural-agents:$UPDATE_VERSION -n x0tta6bl4-system

echo "Обновление агентских сервисов завершено"
```

### Шаг 4: Обновление квантовых сервисов (30 минут)

#### 4.1 Обновление в облаке

```bash
#!/bin/bash
# update-quantum-cloud.sh

echo "=== Обновление квантовых сервисов в облаке ==="

# Обновление в основном регионе
kubectl --context=eks-us-east-1 set image deployment/quantum-services quantum-engine=x0tta6bl4/quantum-engine:$UPDATE_VERSION -n x0tta6bl4-quantum

# Настройка стратегии обновления для квантовых сервисов
kubectl --context=eks-us-east-1 patch deployment quantum-services -n x0tta6bl4-quantum -p "
spec:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
"

# Мониторинг обновления
kubectl --context=eks-us-east-1 rollout status deployment/quantum-services -n x0tta6bl4-quantum --timeout=900s

# Валидация квантовых операций после обновления
kubectl --context=eks-us-east-1 exec deployment/quantum-services -- \
    curl -f http://localhost:8301/health

echo "Обновление квантовых сервисов в облаке завершено"
```

#### 4.2 Обновление в локальных кластерах

```bash
#!/bin/bash
# update-quantum-local.sh

echo "=== Обновление квантовых сервисов в локальных кластерах ==="

# Обновление в Москве
kubectl --context=k3s-moscow set image deployment/quantum-services-moscow quantum-engine=x0tta6bl4/quantum-engine:$UPDATE_VERSION -n x0tta6bl4-quantum
kubectl --context=k3s-moscow rollout status deployment/quantum-services-moscow -n x0tta6bl4-quantum --timeout=900s

# Обновление в СПб
kubectl --context=k3s-spb set image deployment/quantum-services-spb quantum-engine=x0tta6bl4/quantum-engine:$UPDATE_VERSION -n x0tta6bl4-quantum
kubectl --context=k3s-spb rollout status deployment/quantum-services-spb -n x0tta6bl4-quantum --timeout=900s

# Валидация после обновления
kubectl --context=k3s-moscow exec deployment/quantum-services-moscow -- \
    curl -f http://localhost:8301/health

echo "Обновление квантовых сервисов в локальных кластерах завершено"
```

### Шаг 5: Обновление инфраструктурных компонентов (20 минут)

#### 5.1 Обновление систем мониторинга

```bash
#!/bin/bash
# update-monitoring.sh

echo "=== Обновление систем мониторинга ==="

# Обновление Prometheus Operator
helm upgrade kube-prometheus prometheus-community/kube-prometheus-stack \
    -f k8s/monitoring/prometheus-values.yaml \
    --namespace monitoring

# Ожидание готовности обновленных компонентов
kubectl --context=eks-us-east-1 wait --for=condition=available --timeout=300s deployment --all -n monitoring

# Валидация мониторинга
curl -f http://prometheus:9090/-/healthy
curl -f http://grafana:3000/api/health

echo "Обновление мониторинга завершено"
```

#### 5.2 Обновление систем безопасности

```bash
#!/bin/bash
# update-security.sh

echo "=== Обновление систем безопасности ==="

# Обновление Vault
helm upgrade vault hashicorp/vault \
    -f k8s/security/vault-values.yaml \
    --namespace vault

# Обновление SPIRE
helm upgrade spire spire/spire \
    -f k8s/security/spire-values.yaml \
    --namespace spire-system

# Ожидание готовности
kubectl --context=eks-us-east-1 wait --for=condition=available --timeout=300s deployment --all -n vault
kubectl --context=eks-us-east-1 wait --for=condition=available --timeout=300s deployment --all -n spire-system

# Валидация безопасности
kubectl --context=eks-us-east-1 exec vault-0 -n vault -- vault status

echo "Обновление безопасности завершено"
```

### Шаг 6: Валидация обновления (25 минут)

#### 6.1 Функциональное тестирование

```bash
#!/bin/bash
# functional-testing.sh

echo "=== Функциональное тестирование после обновления ==="

# Тестирование API endpoints
API_TESTS=(
    "https://api.x0tta6bl4.com/health"
    "https://api.x0tta6bl4.com/api/v1/auth/login"
    "https://api.x0tta6bl4.com/api/v1/quantum/keys"
)

for endpoint in "${API_TESTS[@]}"; do
    echo "Тестирование: $endpoint"
    curl -f -m 30 $endpoint || {
        echo "Ошибка при тестировании $endpoint"
        exit 1
    }
done

# Тестирование квантовых операций
echo "Тестирование квантовых операций..."
kubectl --context=eks-us-east-1 exec deployment/quantum-services -- \
    curl -f -X POST http://localhost:8301/api/v1/quantum/compute \
    -H "Content-Type: application/json" \
    -d '{"algorithm": "test", "data": "test"}'

# Тестирование агентских сервисов
echo "Тестирование агентских сервисов..."
kubectl --context=eks-us-east-1 exec deployment/cultural-agents -- \
    curl -f http://localhost:8201/api/v1/cultural/analyze

echo "Функциональное тестирование завершено"
```

#### 6.2 Нагрузочное тестирование

```bash
#!/bin/bash
# load-testing.sh

echo "=== Нагрузочное тестирование после обновления ==="

# Тестирование API Gateway под нагрузкой
echo "Нагрузочное тестирование API Gateway..."
kubectl --context=eks-us-east-1 exec deployment/load-test -- \
    artillery run load-test-api-gateway.yaml

# Тестирование квантовых сервисов под нагрузкой
echo "Нагрузочное тестирование квантовых сервисов..."
kubectl --context=eks-us-east-1 exec deployment/load-test -- \
    artillery run load-test-quantum.yaml

# Анализ результатов нагрузочного тестирования
kubectl --context=eks-us-east-1 exec deployment/load-test -- \
    artillery report artillery_report.json

echo "Нагрузочное тестирование завершено"
```

#### 6.3 Мониторинг после обновления

```bash
#!/bin/bash
# post-update-monitoring.sh

echo "=== Мониторинг после обновления ==="

# Проверка метрик производительности
curl -s "http://prometheus:9090/api/v1/query" \
    -G -d "query=rate(http_requests_total[5m])" | jq '.data.result'

# Проверка ошибок после обновления
curl -s "http://prometheus:9090/api/v1/query" \
    -G -d "query=rate(http_requests_total{status=~\"5..\"}[5m])" | jq '.data.result'

# Проверка времени ответа
curl -s "http://prometheus:9090/api/v1/query" \
    -G -d "query=histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))" | jq '.data.result'

# Проверка использования ресурсов
curl -s "http://prometheus:9090/api/v1/query" \
    -G -d "query=sum(kube_pod_container_resource_usage_cpu_cores) by (namespace)" | jq '.data.result'

echo "Мониторинг после обновления завершен"
```

## Валидация

### Критерии успешного обновления

1. **Доступность**: Все сервисы отвечают на запросы без простоев
2. **Функциональность**: Все функции работают корректно
3. **Производительность**: Метрики производительности не ухудшились
4. **Безопасность**: Все политики безопасности активны
5. **Мониторинг**: Все метрики собираются корректно

### Метрики успеха

- Время обновления: < 2 часов
- Доступность сервисов во время обновления: 100%
- Количество ошибок после обновления: < 1%
- Время ответа: не более чем на 20% хуже baseline

## Откат

### Процедура отката при проблемах

```bash
#!/bin/bash
# rollback-update.sh

COMPONENT=${1:-api-gateway}
PREVIOUS_VERSION=${2:-v1.0.0}

echo "=== Откат обновления $COMPONENT до версии $PREVIOUS_VERSION ==="

# Откат deployment
kubectl --context=eks-us-east-1 rollout undo deployment/$COMPONENT -n x0tta6bl4-system

# Или откат к конкретной версии
kubectl --context=eks-us-east-1 set image deployment/$COMPONENT $COMPONENT=x0tta6bl4/$COMPONENT:$PREVIOUS_VERSION -n x0tta6bl4-system

# Ожидание завершения отката
kubectl --context=eks-us-east-1 rollout status deployment/$COMPONENT -n x0tta6bl4-system --timeout=600s

# Валидация после отката
curl -f https://api.x0tta6bl4.com/health

echo "Откат обновления завершен"
```

### Автоматический откат при обнаружении проблем

```bash
#!/bin/bash
# auto-rollback.sh

COMPONENT=$1
ERROR_THRESHOLD=${2:-5}  # Процент ошибок для начала отката

echo "=== Мониторинг для автоматического отката ==="

# Мониторинг ошибок
ERROR_RATE=$(curl -s "http://prometheus:9090/api/v1/query" \
    -G -d "query=rate(http_requests_total{status=~\"5..\"}[5m]) / rate(http_requests_total[5m]) * 100" | \
    jq -r '.data.result[0].value[1]')

if (( $(echo "$ERROR_RATE > $ERROR_THRESHOLD" | bc -l) )); then
    echo "Обнаружен высокий уровень ошибок ($ERROR_RATE%). Начинаю автоматический откат..."

    # Определение предыдущей версии
    PREVIOUS_VERSION=$(kubectl --context=eks-us-east-1 get deployment $COMPONENT -n x0tta6bl4-system -o jsonpath='{.spec.template.spec.containers[0].image}' | cut -d: -f2)

    # Откат
    kubectl --context=eks-us-east-1 rollout undo deployment/$COMPONENT -n x0tta6bl4-system

    # Уведомление команды
    curl -X POST -H 'Content-type: application/json' \
        --data "{\"text\":\"Автоматический откат $COMPONENT из-за высокого уровня ошибок ($ERROR_RATE%)\"}" \
        ${SLACK_WEBHOOK}

    echo "Автоматический откат выполнен"
else
    echo "Уровень ошибок в норме ($ERROR_RATE%)"
fi
```

## Время выполнения

- **Подготовка**: 15 минут
- **Тестирование в staging**: 20 минут
- **Обновление в основном регионе**: 25 минут
- **Обновление квантовых сервисов**: 30 минут
- **Обновление инфраструктуры**: 20 минут
- **Валидация**: 25 минут

**Общее время**: ~2 часа 15 минут

## Риски

### Высокий риск
- **Проблемы совместимости**: Минимизируется тестированием в staging
- **Потеря данных**: Минимизируется резервным копированием

### Средний риск
- **Временная деградация**: Минимизируется rolling update стратегией
- **Проблемы отката**: Минимизируется подготовкой rollback плана

### Низкий риск
- **Проблемы мониторинга**: Минимизируется валидацией метрик
- **Проблемы сети**: Минимизируется проверкой соединений

## Ответственный

- **DevOps инженер**: Выполняет обновление
- **QA инженер**: Тестирует обновление
- **Архитектор системы**: Одобряет изменения
- **Команда разработки**: Предоставляет обновленные артефакты

## Частота

- **Патчи безопасности**: Немедленно при обнаружении уязвимостей
- **Minor обновления**: Еженедельно
- **Major обновления**: Ежемесячно
- **Экстренные обновления**: При критических проблемах

## Пост-действия

1. **Документирование**: Зафиксировать результаты обновления
2. **Обучение**: Обучить команду новым возможностям
3. **Мониторинг**: Установить повышенный мониторинг на 48 часов
4. **Отчет**: Подготовить отчет об обновлении для руководства
5. **Очистка**: Удалить staging окружения после успешного обновления

Последнее обновление: 2025-09-30