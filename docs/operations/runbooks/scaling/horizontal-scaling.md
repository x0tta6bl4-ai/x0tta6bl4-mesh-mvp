# Горизонтальное масштабирование x0tta6bl4

## Обзор

Этот runbook описывает процедуру горизонтального масштабирования компонентов системы x0tta6bl4 для обработки увеличенной нагрузки.

## Требования

### Доступы
- kubectl настроен для всех кластеров
- Доступ к системам мониторинга
- Доступ к AWS для управления EKS

### Инструменты
- kubectl >= 1.28
- aws-cli >= 2.0
- curl для тестирования

### Предварительные условия
- Система мониторинга активна
- Метрики производительности доступны
- HorizontalPodAutoscaler настроены

## Шаги выполнения

### Шаг 1: Анализ текущей нагрузки (10 минут)

```bash
#!/bin/bash
# analyze-current-load.sh

echo "=== Анализ текущей нагрузки ==="

# Проверка использования ресурсов кластеров
for context in eks-us-east-1 eks-eu-west-1 eks-ap-southeast-1; do
    echo "Кластер: $context"
    kubectl --context=$context top nodes
    kubectl --context=$context top pods -A --sort-by=cpu | head -10
    echo "---"
done

# Проверка HPA состояния
kubectl get hpa -A

# Проверка очередей и задержек
curl -s http://prometheus:9090/api/v1/query?query='rate(http_requests_total[5m])' | jq '.data.result'
curl -s http://prometheus:9090/api/v1/query?query='histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))' | jq '.data.result'

echo "Анализ нагрузки завершен"
```

### Шаг 2: Масштабирование API Gateway (15 минут)

#### 2.1 Масштабирование в облаке

```bash
#!/bin/bash
# scale-api-gateway.sh

echo "=== Масштабирование API Gateway ==="

# Масштабирование в основном регионе (us-east-1)
kubectl --context=eks-us-east-1 scale deployment api-gateway --replicas=10 -n x0tta6bl4-system

# Масштабирование в EU регионе (eu-west-1)
kubectl --context=eks-eu-west-1 scale deployment api-gateway --replicas=8 -n x0tta6bl4-system

# Масштабирование в Asia Pacific регионе (ap-southeast-1)
kubectl --context=eks-ap-southeast-1 scale deployment api-gateway --replicas=6 -n x0tta6bl4-system

# Ожидание готовности новых реплик
kubectl --context=eks-us-east-1 rollout status deployment/api-gateway -n x0tta6bl4-system --timeout=300s
kubectl --context=eks-eu-west-1 rollout status deployment/api-gateway -n x0tta6bl4-system --timeout=300s
kubectl --context=eks-ap-southeast-1 rollout status deployment/api-gateway -n x0tta6bl4-system --timeout=300s

echo "API Gateway масштабирован"
```

#### 2.2 Обновление балансировщика нагрузки

```bash
#!/bin/bash
# update-load-balancer.sh

echo "=== Обновление конфигурации балансировщика нагрузки ==="

# Получение текущих targets
TARGET_GROUPS=$(aws elbv2 describe-target-groups --names x0tta6bl4-api-tg --region us-east-1 --query 'TargetGroups[0].TargetGroupArn' --output text)

# Регистрация новых инстансов
aws elbv2 register-targets \
    --target-group-arn $TARGET_GROUPS \
    --targets Id=i-1234567890abcdef0,Port=8000 Id=i-0987654321fedcba0,Port=8000 \
    --region us-east-1

# Проверка здоровья targets
aws elbv2 describe-target-health --target-group-arn $TARGET_GROUPS --region us-east-1

echo "Балансировщик нагрузки обновлен"
```

### Шаг 3: Масштабирование агентских сервисов (20 минут)

#### 3.1 Масштабирование культурных агентов

```bash
#!/bin/bash
# scale-cultural-agents.sh

echo "=== Масштабирование культурных агентов ==="

# Масштабирование в облаке
kubectl --context=eks-us-east-1 scale deployment cultural-agents --replicas=15 -n x0tta6bl4-system
kubectl --context=eks-eu-west-1 scale deployment cultural-agents --replicas=12 -n x0tta6bl4-system
kubectl --context=eks-ap-southeast-1 scale deployment cultural-agents --replicas=10 -n x0tta6bl4-system

# Масштабирование в локальных кластерах
kubectl --context=k3s-moscow scale deployment cultural-agents-moscow --replicas=8 -n x0tta6bl4-system
kubectl --context=k3s-spb scale deployment cultural-agents-spb --replicas=6 -n x0tta6bl4-system

# Ожидание готовности
kubectl --context=eks-us-east-1 rollout status deployment/cultural-agents -n x0tta6bl4-system --timeout=300s

echo "Культурные агенты масштабированы"
```

#### 3.2 Масштабирование бизнес-агентов

```bash
#!/bin/bash
# scale-business-agents.sh

echo "=== Масштабирование бизнес-агентов ==="

# Масштабирование в облаке
kubectl --context=eks-us-east-1 scale deployment business-agents --replicas=12 -n x0tta6bl4-system
kubectl --context=eks-eu-west-1 scale deployment business-agents --replicas=10 -n x0tta6bl4-system

# Масштабирование в локальных кластерах
kubectl --context=k3s-moscow scale deployment business-agents-moscow --replicas=8 -n x0tta6bl4-system
kubectl --context=k3s-spb scale deployment business-agents-spb --replicas=6 -n x0tta6bl4-system

# Ожидание готовности
kubectl --context=eks-us-east-1 rollout status deployment/business-agents -n x0tta6bl4-system --timeout=300s

echo "Бизнес-агенты масштабированы"
```

### Шаг 4: Масштабирование квантовых сервисов (25 минут)

#### 4.1 Масштабирование квантовых вычислений

```bash
#!/bin/bash
# scale-quantum-services.sh

echo "=== Масштабирование квантовых сервисов ==="

# Масштабирование в облаке (требует dedicated узлов)
kubectl --context=eks-us-east-1 scale deployment quantum-services --replicas=6 -n x0tta6bl4-quantum
kubectl --context=eks-eu-west-1 scale deployment quantum-services --replicas=4 -n x0tta6bl4-quantum
kubectl --context=eks-ap-southeast-1 scale deployment quantum-services --replicas=3 -n x0tta6bl4-quantum

# Масштабирование в локальных кластерах
kubectl --context=k3s-moscow scale deployment quantum-services-moscow --replicas=5 -n x0tta6bl4-quantum
kubectl --context=k3s-spb scale deployment quantum-services-spb --replicas=4 -n x0tta6bl4-quantum

# Ожидание готовности
kubectl --context=eks-us-east-1 rollout status deployment/quantum-services -n x0tta6bl4-quantum --timeout=600s

echo "Квантовые сервисы масштабированы"
```

#### 4.2 Масштабирование квантового оборудования

```bash
#!/bin/bash
# scale-quantum-hardware.sh

echo "=== Масштабирование квантового оборудования ==="

# Добавление новых узлов для квантовых вычислений
aws eks create-nodegroup \
    --cluster-name x0tta6bl4-eks-us-east-1 \
    --nodegroup-name quantum-compute-ng-2 \
    --node-role arn:aws:iam::ACCOUNT:role/NodeInstanceRole \
    --subnets subnet-12345 subnet-67890 \
    --instance-types c5n.4xlarge \
    --disk-size 200 \
    --scaling-config minSize=1,maxSize=8,desiredSize=3 \
    --labels node-type=quantum,region=us-east-1 \
    --taints key=dedicated,value=quantum,effect=NoSchedule \
    --region us-east-1

# Ожидание готовности узлов
kubectl --context=eks-us-east-1 wait --for=condition=Ready nodes --all --timeout=600s

echo "Квантовое оборудование масштабировано"
```

### Шаг 5: Масштабирование инфраструктуры (30 минут)

#### 5.1 Масштабирование баз данных

```bash
#!/bin/bash
# scale-databases.sh

echo "=== Масштабирование баз данных ==="

# Масштабирование Aurora read replicas
aws rds create-db-instance-read-replica \
    --db-instance-identifier x0tta6bl4-aurora-replica-us-east-1-3 \
    --source-db-cluster-identifier x0tta6bl4-aurora \
    --db-instance-class db.r6g.2xlarge \
    --region us-east-1

aws rds create-db-instance-read-replica \
    --db-instance-identifier x0tta6bl4-aurora-replica-eu-west-1-3 \
    --source-db-cluster-identifier x0tta6bl4-aurora-eu \
    --db-instance-class db.r6g.2xlarge \
    --region eu-west-1

# Масштабирование ElastiCache
aws elasticache create-cache-cluster \
    --cache-cluster-id x0tta6bl4-redis-003 \
    --cache-node-type cache.r6g.xlarge \
    --num-cache-nodes 3 \
    --engine redis \
    --engine-version 7.0 \
    --region us-east-1

echo "Базы данных масштабированы"
```

#### 5.2 Масштабирование хранилища

```bash
#!/bin/bash
# scale-storage.sh

echo "=== Масштабирование хранилища ==="

# Расширение persistent volumes
kubectl patch pvc quantum-data-pvc -n x0tta6bl4-quantum -p '{"spec":{"resources":{"requests":{"storage":"500Gi"}}}}'
kubectl patch pvc agents-data-pvc -n x0tta6bl4-system -p '{"spec":{"resources":{"requests":{"storage":"200Gi"}}}}'

# Создание дополнительных storage classes
kubectl apply -f - <<EOF
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: x0tta6bl4-fast-ssd-encrypted
provisioner: kubernetes.io/aws-ebs
parameters:
  type: io2
  iopsPerGB: "1000"
  throughputPerGB: "500"
  encrypted: "true"
reclaimPolicy: Delete
allowVolumeExpansion: true
EOF

echo "Хранилище масштабировано"
```

### Шаг 6: Обновление сетевой конфигурации (15 минут)

#### 6.1 Обновление балансировщиков нагрузки

```bash
#!/bin/bash
# update-networking.sh

echo "=== Обновление сетевой конфигурации ==="

# Обновление ALB capacity
aws elbv2 modify-load-balancer \
    --load-balancer-arn arn:aws:elasticloadbalancing:us-east-1:ACCOUNT:loadbalancer/app/x0tta6bl4-alb/1234567890123456 \
    --region us-east-1

# Обновление target group health checks
aws elbv2 modify-target-group \
    --target-group-arn $TARGET_GROUPS \
    --health-check-interval-seconds 15 \
    --health-check-timeout-seconds 5 \
    --healthy-threshold-count 2 \
    --unhealthy-threshold-count 2 \
    --region us-east-1

echo "Сетевая конфигурация обновлена"
```

#### 6.2 Обновление сетевых политик

```bash
#!/bin/bash
# update-network-policies.sh

echo "=== Обновление сетевых политик ==="

# Обновление политик для новых реплик
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: scaled-api-gateway-access
  namespace: x0tta6bl4-system
spec:
  podSelector:
    matchLabels:
      app: api-gateway
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: ingress-nginx
    - podSelector:
        matchLabels:
          app: agents
    ports:
    - protocol: TCP
      port: 8000
  egress:
  - to: []
    ports:
    - protocol: TCP
      port: 5432
    - protocol: TCP
      port: 6379
EOF

echo "Сетевые политики обновлены"
```

### Шаг 7: Валидация масштабирования (20 минут)

#### 7.1 Тестирование производительности

```bash
#!/bin/bash
# validate-scaling.sh

echo "=== Валидация масштабирования ==="

# Тестирование API Gateway
echo "Тестирование API Gateway..."
for i in {1..10}; do
    curl -w "@curl-format.txt" -s -o /dev/null https://api.x0tta6bl4.com/health &
done
wait

# Тестирование квантовых сервисов
echo "Тестирование квантовых сервисов..."
kubectl --context=eks-us-east-1 exec deployment/quantum-services -- \
    curl -f http://localhost:8301/health

# Тестирование агентских сервисов
echo "Тестирование агентских сервисов..."
kubectl --context=eks-us-east-1 exec deployment/cultural-agents -- \
    curl -f http://localhost:8201/health

echo "Валидация масштабирования завершена"
```

#### 7.2 Проверка метрик

```bash
#!/bin/bash
# check-metrics.sh

echo "=== Проверка метрик после масштабирования ==="

# Проверка распределения нагрузки
curl -s "http://prometheus:9090/api/v1/query" \
    -G -d "query=up{job='api-gateway'}" | jq '.data.result | length'

# Проверка времени ответа
curl -s "http://prometheus:9090/api/v1/query" \
    -G -d "query=histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))" | jq '.data.result'

# Проверка использования ресурсов
curl -s "http://prometheus:9090/api/v1/query" \
    -G -d "query=sum(kube_pod_container_resource_requests_cpu_cores) by (namespace)" | jq '.data.result'

echo "Проверка метрик завершена"
```

## Валидация

### Критерии успешного масштабирования

1. **Доступность**: Все сервисы отвечают на запросы
2. **Производительность**: Время ответа < 2 секунд для 95% запросов
3. **Распределение нагрузки**: Нагрузка равномерно распределена между репликами
4. **Ресурсы**: Использование CPU/Memory < 80% на всех узлах
5. **Сеть**: Все межкластерные соединения работают

### Метрики успеха

- Время масштабирования: < 2 часов
- Время ответа API: < 1 секунды (95th percentile)
- Доступность сервисов: > 99.9%
- Распределение нагрузки: < 20% разницы между репликами

## Откат

### Процедура отката масштабирования

```bash
#!/bin/bash
# rollback-scaling.sh

SCALE_DOWN=${1:-true}

echo "=== Откат масштабирования ==="

if [ "$SCALE_DOWN" = true ]; then
    # Масштабирование к исходным значениям
    kubectl --context=eks-us-east-1 scale deployment api-gateway --replicas=3 -n x0tta6bl4-system
    kubectl --context=eks-us-east-1 scale deployment cultural-agents --replicas=5 -n x0tta6bl4-system
    kubectl --context=eks-us-east-1 scale deployment quantum-services --replicas=2 -n x0tta6bl4-quantum

    # Удаление дополнительных узлов
    aws eks delete-nodegroup \
        --cluster-name x0tta6bl4-eks-us-east-1 \
        --nodegroup-name quantum-compute-ng-2 \
        --region us-east-1

    # Удаление дополнительных баз данных
    aws rds delete-db-instance \
        --db-instance-identifier x0tta6bl4-aurora-replica-us-east-1-3 \
        --skip-final-snapshot \
        --region us-east-1
fi

echo "Откат масштабирования завершен"
```

## Время выполнения

- **Анализ нагрузки**: 10 минут
- **Масштабирование API Gateway**: 15 минут
- **Масштабирование агентских сервисов**: 20 минут
- **Масштабирование квантовых сервисов**: 25 минут
- **Масштабирование инфраструктуры**: 30 минут
- **Обновление сети**: 15 минут
- **Валидация**: 20 минут

**Общее время**: ~2 часа 15 минут

## Риски

### Высокий риск
- **Перерасход ресурсов**: Минимизируется мониторингом использования
- **Деградация производительности**: Минимизируется тестированием

### Средний риск
- **Проблемы балансировки**: Минимизируется обновлением конфигурации
- **Задержки распространения**: Минимизируется временем ожидания

### Низкий риск
- **Проблемы сети**: Минимизируется проверкой соединений
- **Проблемы хранилища**: Минимизируется мониторингом места

## Ответственный

- **DevOps инженер**: Выполняет масштабирование
- **Архитектор системы**: Одобряет изменения архитектуры
- **Команда эксплуатации**: Мониторит процесс

## Частота

- **Автоматическое масштабирование**: По метрикам HPA
- **Ручное масштабирование**: При планируемом росте нагрузки
- **Экстренное масштабирование**: При неожиданном росте трафика

## Пост-действия

1. **Мониторинг**: Установить повышенный мониторинг на 24 часа
2. **Документирование**: Зафиксировать изменения в системе
3. **Оптимизация**: Проанализировать эффективность масштабирования
4. **Планирование**: Спланировать дальнейшее масштабирование при необходимости

Последнее обновление: 2025-09-30