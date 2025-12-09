# Руководство оператора x0tta6bl4

## Ежедневные процедуры эксплуатации

### Утренний чек-лист (09:00 MSK)

#### 1. Проверка статуса кластеров
```bash
# Проверка облачных кластеров EKS
for region in us-east-1 eu-west-1 ap-southeast-1; do
    echo "=== Проверка кластера EKS в $region ==="
    kubectl --context=eks-${region} get nodes
    kubectl --context=eks-${region} get pods -A --field-selector=status.phase!=Running
    kubectl --context=eks-${region} get events --sort-by=.metadata.creationTimestamp | tail -10
done

# Проверка локальных кластеров K3s
for cluster in moscow spb; do
    echo "=== Проверка кластера K3s в $cluster ==="
    kubectl --context=k3s-${cluster} get nodes
    kubectl --context=k3s-${cluster} get pods -A --field-selector=status.phase!=Running
done
```

#### 2. Проверка систем мониторинга
```bash
# Проверка Prometheus targets
kubectl --context=eks-us-east-1 port-forward svc/kube-prometheus-prometheus 9090:9090 -n monitoring &
PROMETHEUS_PID=$!

curl -s http://localhost:9090/api/v1/query?query=up | jq '.data.result[] | select(.value[1] == "0") | .metric'

kill $PROMETHEUS_PID

# Проверка активных алертов
kubectl --context=eks-us-east-1 exec -it deployment/kube-prometheus-alertmanager -n monitoring -- \
    amtool alert query
```

#### 3. Проверка бизнес-метрик
```bash
# Проверка ключевых метрик API Gateway
curl -s http://localhost:9090/api/v1/query?query='rate(http_requests_total[5m])' | jq '.data.result'

# Проверка статуса квантовых операций
curl -s http://localhost:9090/api/v1/query?query='quantum_operations_total' | jq '.data.result'

# Проверка использования ресурсов
curl -s http://localhost:9090/api/v1/query?query='sum(rate(container_cpu_usage_seconds_total[5m])) by (namespace)' | jq '.data.result'
```

### Мониторинг в течение дня

#### 1. Мониторинг производительности
- **CPU/RAM**: следить за использованием ресурсов в Grafana дашборде
- **Network I/O**: мониторить трафик между регионами
- **Storage**: проверять использование persistent volumes
- **Quantum operations**: отслеживать coherence time и gate errors

#### 2. Мониторинг безопасности
```bash
# Проверка логов аутентификации
kubectl --context=eks-us-east-1 logs -n x0tta6bl4-system deployment/api-gateway | \
    grep -E "(ERROR|WARN|auth|login|token)" | tail -20

# Проверка сетевых политик
kubectl --context=eks-us-east-1 get networkpolicies -A

# Проверка сертификатов TLS
kubectl --context=eks-us-east-1 get certificates -A -o wide
```

#### 3. Мониторинг бизнес-процессов
- Количество активных пользователей
- Успешность API вызовов
- Время ответа сервисов
- Количество обработанных квантовых операций

### Вечерние процедуры (18:00 MSK)

#### 1. Проверка резервных копий
```bash
# Проверка статуса backup jobs
kubectl --context=eks-us-east-1 get cronjobs -n velero
kubectl --context=eks-us-east-1 get backups -n velero

# Проверка Aurora backups
aws rds describe-db-cluster-snapshots --db-cluster-identifier x0tta6bl4-aurora --region us-east-1

# Проверка кросс-региональной репликации
aws s3 ls s3://x0tta6bl4-backups-eu-west-1/ --region eu-west-1
```

#### 2. Проверка логов и событий
```bash
# Проверка системных логов за день
kubectl --context=eks-us-east-1 logs -n monitoring deployment/kube-prometheus-prometheus --since=1d | \
    grep -v "ts=.*level=info" | head -50

# Проверка событий кластера
kubectl --context=eks-us-east-1 get events --sort-by=.metadata.creationTimestamp --since=1h

# Проверка алертов за день
kubectl --context=eks-us-east-1 exec deployment/kube-prometheus-alertmanager -n monitoring -- \
    amtool alert query --resolved
```

#### 3. Подготовка отчета о состоянии
```bash
# Сбор статистики для отчета
echo "=== Отчет о состоянии системы $(date) ===" > daily-report.txt

# Метрики производительности
echo -e "\n1. Производительность:" >> daily-report.txt
curl -s http://localhost:9090/api/v1/query?query='avg_over_time(http_request_duration_seconds[1d])' | \
    jq -r '.data.result[] | "\(.metric) = \(.value[1])"' >> daily-report.txt

# Использование ресурсов
echo -e "\n2. Использование ресурсов:" >> daily-report.txt
curl -s http://localhost:9090/api/v1/query?query='sum(kube_pod_container_resource_requests_cpu_cores) by (namespace)' | \
    jq -r '.data.result[] | "\(.metric.namespace) = \(.value[1]) cores"' >> daily-report.txt

# Статус сервисов
echo -e "\n3. Статус сервисов:" >> daily-report.txt
kubectl --context=eks-us-east-1 get deployments -A -o custom-columns=NS:.metadata.namespace,NAME:.metadata.name,READY:.status.readyReplicas >> daily-report.txt
```

## Реагирование на алерты

### Критические алерты (P0)

#### 1. Недоступность сервиса
```bash
# Диагностика недоступного сервиса
SERVICE_NAME=$1
NAMESPACE=${2:-x0tta6bl4-system}

echo "Диагностика сервиса: $SERVICE_NAME в namespace: $NAMESPACE"

# Проверка подов
kubectl --context=eks-us-east-1 get pods -l app=$SERVICE_NAME -n $NAMESPACE

# Проверка логов
kubectl --context=eks-us-east-1 logs -l app=$SERVICE_NAME -n $NAMESPACE --tail=50

# Проверка событий
kubectl --context=eks-us-east-1 get events -l app=$SERVICE_NAME -n $NAMESPACE --sort-by=.metadata.creationTimestamp

# Проверка ресурсов
kubectl --context=eks-us-east-1 top pods -l app=$SERVICE_NAME -n $NAMESPACE
```

#### 2. Высокая нагрузка на CPU/Memory
```bash
# Поиск узлов с высокой нагрузкой
kubectl --context=eks-us-east-1 top nodes | awk '$3 > 80 {print $1}'

# Масштабирование при необходимости
for node in $(kubectl --context=eks-us-east-1 top nodes | awk '$3 > 80 {print $1}'); do
    echo "Масштабирование кластера из-за нагрузки на узле: $node"
    # Автоматическое масштабирование через Cluster Autoscaler
done
```

### Предупреждения (P1-P2)

#### 1. Замедление API
```bash
# Анализ медленных запросов
kubectl --context=eks-us-east-1 logs -l app=api-gateway -n x0tta6bl4-system | \
    grep "duration" | awk -F'duration=' '{if($2 > 5) print $0}' | tail -10

# Проверка базы данных
kubectl --context=eks-us-east-1 exec deployment/postgresql-client -- \
    psql $DATABASE_URL -c "SELECT current_setting('log_min_duration_statement')"

# Проверка кэша Redis
kubectl --context=eks-us-east-1 exec deployment/redis-client -- \
    redis-cli --raw incr "test-connection"
```

#### 2. Проблемы с сетью
```bash
# Проверка сетевых политик
kubectl --context=eks-us-east-1 get networkpolicies -A

# Проверка сервисов
kubectl --context=eks-us-east-1 get endpoints -A | grep -v ", "

# Проверка межкластерного взаимодействия
kubectl --context=eks-us-east-1 exec deployment/test-pod -- \
    curl -m 10 http://test-service.k3s-moscow.svc.clusterset.local/health
```

## Рутинные задачи обслуживания

### Еженедельные задачи

#### 1. Обновление сертификатов TLS
```bash
# Проверка истекающих сертификатов
kubectl --context=eks-us-east-1 get certificates -A --sort-by=.spec.renewBefore

# Обновление сертификатов cert-manager
kubectl --context=eks-us-east-1 apply -f - <<EOF
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: x0tta6bl4-tls-renewal
  namespace: x0tta6bl4-system
spec:
  secretName: x0tta6bl4-tls
  renewBefore: 720h
  dnsNames:
  - api.x0tta6bl4.com
  - grafana.x0tta6bl4.com
  issuerRef:
    name: letsencrypt-prod
    kind: ClusterIssuer
EOF
```

#### 2. Очистка старых логов
```bash
# Очистка логов Elasticsearch
curl -X DELETE "localhost:9200/filebeat-*/_doc/_delete_by_query" -H 'Content-Type: application/json' -d'
{
  "query": {
    "range": {
      "@timestamp": {
        "lt": "now-30d"
      }
    }
  }
}'

# Очистка старых образов Docker
docker system prune -f --volumes
```

#### 3. Проверка резервных копий
```bash
# Тестирование восстановления из backup
kubectl --context=eks-us-east-1 apply -f test-restore.yaml

# Валидация восстановленных данных
kubectl --context=eks-us-east-1 exec deployment/test-pod -- \
    curl -f http://api-gateway.x0tta6bl4-system:8000/health

# Очистка тестового восстановления
kubectl --context=eks-us-east-1 delete -f test-restore.yaml
```

### Ежемесячные задачи

#### 1. Аудит безопасности
```bash
# Проверка политик безопасности
kubectl --context=eks-us-east-1 get podsecuritypolicies

# Проверка ролей RBAC
kubectl --context=eks-us-east-1 get roles,rolebindings,clusterroles,clusterrolebindings -A

# Проверка сетевых политик
kubectl --context=eks-us-east-1 get networkpolicies -A

# Генерация отчета аудита
kubectl --context=eks-us-east-1 get events --since=30d -o yaml > security-audit-$(date +%Y-%m-%d).yaml
```

#### 2. Оптимизация производительности
```bash
# Анализ использования ресурсов
kubectl --context=eks-us-east-1 top pods -A --sort-by=cpu --no-headers | tail -10

# Поиск неиспользуемых ресурсов
kubectl --context=eks-us-east-1 get pv,pvc -A | grep Available

# Оптимизация запросов к базе данных
kubectl --context=eks-us-east-1 exec deployment/postgresql-client -- \
    psql $DATABASE_URL -c "SELECT * FROM pg_stat_statements ORDER BY mean_time DESC LIMIT 10;"
```

## Инструменты мониторинга и диагностики

### Grafana дашборды

#### Основной дашборд системы
- **URL**: https://grafana.x0tta6bl4.com/d/x0tta6bl4-overview
- **Метрики**: CPU, Memory, Network, Storage
- **Обновление**: каждые 30 секунд

#### Дашборд квантовых операций
- **URL**: https://grafana.x0tta6bl4.com/d/x0tta6bl4-quantum
- **Метрики**: coherence time, gate errors, quantum throughput
- **Обновление**: каждые 10 секунд

#### Дашборд бизнес-метрик
- **URL**: https://grafana.x0tta6bl4.com/d/x0tta6bl4-business
- **Метрики**: API usage, user activity, revenue metrics
- **Обновление**: каждые 5 минут

### Инструменты командной строки

#### Скрипт быстрой диагностики
```bash
#!/bin/bash
# quick-diag.sh

echo "=== Быстрая диагностика x0tta6bl4 ==="
echo "$(date)"

# Проверка кластеров
for context in eks-us-east-1 k3s-moscow; do
    echo -e "\n--- Кластер: $context ---"
    kubectl --context=$context get nodes | grep -E "(NAME|Ready)"
    kubectl --context=$context get pods -A | grep -v Running | wc -l
done

# Проверка алертов
echo -e "\n--- Активные алерты ---"
kubectl --context=eks-us-east-1 exec deployment/kube-prometheus-alertmanager -n monitoring -- \
    amtool alert query | jq '.alerts | length'

echo -e "\n=== Диагностика завершена ==="
```

#### Скрипт проверки производительности
```bash
#!/bin/bash
# perf-check.sh

# Проверка времени ответа API
echo "Проверка времени ответа API..."
time curl -s -o /dev/null -w "%{time_total}\n" https://api.x0tta6bl4.com/health

# Проверка квантовых операций
echo "Проверка квантовых операций..."
kubectl --context=eks-us-east-1 exec deployment/quantum-services -- \
    curl -s http://localhost:8301/metrics | grep quantum_operations_total

# Проверка использования ресурсов
echo "Использование ресурсов:"
kubectl --context=eks-us-east-1 top nodes | awk 'NR>1 {sum+=$3} END {print "Средняя нагрузка CPU:", sum/(NR-1)"%"}'
```

## Контакты и эскалация

### Команда эксплуатации
- **Дежурный инженер**: +7 (495) XXX-XX-XX
- **Старший инженер**: +7 (495) XXX-XX-XX
- **Руководитель**: +7 (495) XXX-XX-XX

### Внешние контакты
- **Провайдер облака AWS**: support.aws.amazon.com
- **Провайдер CDN Cloudflare**: support.cloudflare.com
- **Провайдер мониторинга Grafana**: support.grafana.com

### Процедура эскалации
1. Попытка самостоятельного решения (15 минут)
2. Консультация с коллегой (15 минут)
3. Эскалация старшему инженеру (30 минут)
4. Эскалация руководителю (1 час)
5. Эскалация внешним подрядчикам (при необходимости)

## Метрики производительности операционной команды

### KPI операционной команды
- **Время реакции на алерты**: < 5 минут для P0
- **Время решения инцидентов**: < 1 часа для P0
- **Доступность системы**: > 99.9%
- **Количество инцидентов в месяц**: < 5
- **Время развертывания**: < 30 минут

### Отчетность
- **Ежедневный отчет**: отправляется в 19:00 MSK
- **Еженедельный отчет**: отправляется каждую пятницу
- **Ежемесячный отчет**: отправляется 1 числа месяца
- **Пост-мортем**: после каждого P0 инцидента

Этот документ обновляется при изменении процедур или инфраструктуры. Последнее обновление: 2025-09-30.