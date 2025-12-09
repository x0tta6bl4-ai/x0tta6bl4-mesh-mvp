# Операционное руководство по управлению сетевой инфраструктурой x0tta6bl4

## Содержание

1. [Ежедневные операции](#ежедневные-операции)
2. [Мониторинг и алертинг](#мониторинг-и-алертинг)
3. [Управление изменениями](#управление-изменениями)
4. [Масштабирование и оптимизация](#масштабирование-и-оптимизация)
5. [Решение проблем](#решение-проблем)
6. [Безопасность и compliance](#безопасность-и-compliance)
7. [Резервное копирование и восстановление](#резервное-копирование-и-восстановление)

## Ежедневные операции

### 1. Проверка состояния системы

#### Утренняя проверка (09:00 MSK)

```bash
# Проверка статуса всех кластеров
for cluster in eks-us-east-1 eks-eu-west-1 eks-ap-southeast-1 k3s-moscow-dc1 k3s-spb-dc2; do
  echo "=== Проверка кластера: $cluster ==="
  kubectl --kubeconfig=kubeconfig/$cluster.yaml get nodes
  kubectl --kubeconfig=kubeconfig/$cluster.yaml get pods -A | grep -v Running | head -20
done

# Проверка сетевых компонентов
kubectl --kubeconfig=kubeconfig/eks-us-east-1.yaml get submariner -n submariner-operator
cilium status --kubeconfig=kubeconfig/eks-us-east-1.yaml
istioctl proxy-status --kubeconfig=kubeconfig/eks-us-east-1.yaml | grep -E "(HEALTHY|UNHEALTHY)"

# Проверка алертов
kubectl --kubeconfig=kubeconfig/eks-us-east-1.yaml get alertmanager -n x0tta6bl4-monitoring
```

#### Мониторинг ключевых метрик

**Команда для проверки**:
```bash
# Проверка основных метрик сети
curl -s http://prometheus.x0tta6bl4-monitoring:9090/api/v1/query?query=up | jq '.data.result[] | select(.value[1] == "0") | .metric.name'

# Проверка задержек API
curl -s http://prometheus.x0tta6bl4-monitoring:9090/api/v1/query?query=histogram_quantile(0.95, rate(istio_request_duration_milliseconds_bucket[5m])) | jq '.data.result[0].value[1]'

# Проверка нарушений политик безопасности
curl -s http://prometheus.x0tta6bl4-monitoring:9090/api/v1/query?query=increase(cilium_policy_denied_packets_total[1h]) | jq '.data.result[0].value[1]'
```

### 2. Проверка логов безопасности

#### Автоматизированная проверка логов

```bash
# Проверка подозрительной активности
kubectl logs -n x0tta6bl4-network-monitoring deployment/hubble-server --kubeconfig=kubeconfig/eks-us-east-1.yaml | grep -i "denied\|drop\|violation" | tail -10

# Проверка алертов безопасности
kubectl logs -n x0tta6bl4-monitoring deployment/alertmanager --kubeconfig=kubeconfig/eks-us-east-1.yaml | grep -E "(FIRING|RESOLVED)" | tail -5

# Проверка межзонного трафика
kubectl logs -n x0tta6bl4-cross-zone-security deployment/cross-zone-traffic-auditor --kubeconfig=kubeconfig/eks-us-east-1.yaml | grep -E "(suspicious|threat|violation)" | tail -10
```

### 3. Проверка производительности сети

#### Мониторинг пропускной способности

```bash
# Проверка использования сети узлами
kubectl top nodes --kubeconfig=kubeconfig/eks-us-east-1.yaml

# Проверка сетевых метрик Cilium
cilium metrics list --kubeconfig=kubeconfig/eks-us-east-1.yaml | grep -E "(packets|bytes|flows)"

# Проверка Hubble метрик
curl -s http://hubble-server.x0tta6bl4-network-monitoring:9091/metrics | grep -E "(hubble_flows|hubble_policy)" | head -10
```

## Мониторинг и алертинг

### 1. Система алертинга

#### Настройка уведомлений

**Slack интеграция**:
```yaml
# Конфигурация Slack уведомлений
apiVersion: v1
kind: ConfigMap
metadata:
  name: alertmanager-slack-config
  namespace: x0tta6bl4-monitoring
data:
  slack-config.yaml: |
    global:
      slack_api_url: '${SLACK_WEBHOOK_URL}'

    route:
      group_by: ['alertname']
      group_wait: 10s
      group_interval: 10s
      repeat_interval: 1h
      receiver: 'slack-notifications'

    receivers:
    - name: 'slack-notifications'
      slack_configs:
      - channel: '#network-alerts'
        title: 'Network Alert'
        text: '{{ range .Alerts }}{{ .Annotations.summary }}\n{{ end }}'
        send_resolved: true
```

**Email уведомления**:
```bash
# Настройка email уведомлений
kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: alertmanager-email-secret
  namespace: x0tta6bl4-monitoring
type: Opaque
data:
  password: $(echo -n 'your-email-password' | base64)
EOF
```

### 2. Ключевые алерты для мониторинга

#### Критичные алерты (P1)

| Алерт | Условие | Действие |
|-------|---------|----------|
| `SubmarinerGatewayDown` | Gateway не отвечает >5 мин | Немедленная проверка туннелей |
| `CiliumOperatorDown` | Оператор не отвечает >3 мин | Перезапуск оператора |
| `IstioPilotDown` | Pilot не отвечает >5 мин | Проверка control plane |
| `CrossZoneSecurityViolation` | Нарушение межзонной политики | Изоляция трафика |

#### Предупреждающие алерты (P2)

| Алерт | Условие | Действие |
|-------|---------|----------|
| `HighNetworkLatency` | Задержка >500ms >10 мин | Анализ сетевого пути |
| `NetworkPolicyViolation` | >100 нарушений/час | Проверка политик |
| `CertificateExpiration` | Сертификат истекает <7 дней | Планирование обновления |

### 3. Dashboard мониторинга

#### Основные дашборды

**Network Overview Dashboard**:
- Общий трафик между кластерами
- Статус туннелей Submariner
- Нарушения Network Policies
- Задержки и потери пакетов

**Security Dashboard**:
- Нарушения политик безопасности
- Подозрительная активность
- Статус mTLS соединений
- Аудит событий безопасности

**Performance Dashboard**:
- Задержки сетевых запросов
- Пропускная способность
- Использование ресурсов сети
- Очереди и бэклог

## Управление изменениями

### 1. Процесс внесения изменений

#### Стандартный процесс изменений

1. **Планирование**: Создание заявки на изменение в системе отслеживания
2. **Оценка рисков**: Анализ влияния на безопасность и производительность
3. **Тестирование**: Валидация в staging окружении
4. **Одобрение**: Получение одобрения от архитекторов и безопасности
5. **Реализация**: Внедрение в production с мониторингом
6. **Валидация**: Проверка корректности работы после изменений

#### Шаблон заявки на изменение

```yaml
change_request:
  id: "NET-2025-001"
  title: "Обновление политик безопасности для квантовых сервисов"
  type: "security_policy_update"
  priority: "medium"
  risk_level: "low"

  description: |
    Обновление Cilium Network Policies для улучшения изоляции квантовых сервисов

  impact:
    - clusters: ["k3s-moscow-dc1"]
    - services: ["quantum-service", "quantum-key-manager"]
    - downtime: "none"
    - rollback_time: "<5 minutes"

  testing:
    - staging_validation: "completed"
    - security_review: "passed"
    - performance_impact: "minimal"

  approval:
    - network_team: "approved"
    - security_team: "approved"
    - architecture_team: "approved"

  implementation:
    - method: "kubectl apply"
    - files: ["cilium-policies-quantum-update.yaml"]
    - verification: "network policy verification script"
```

### 2. Обновление компонентов

#### Обновление Submariner

```bash
#!/bin/bash
# Скрипт обновления Submariner

set -e

NEW_VERSION="0.16.0"
CLUSTERS=("eks-us-east-1" "eks-eu-west-1" "eks-ap-southeast-1" "k3s-moscow-dc1" "k3s-spb-dc2")

echo "Начинаем обновление Submariner до версии $NEW_VERSION"

# 1. Обновление CRD
for cluster in "${CLUSTERS[@]}"; do
  echo "Обновление CRD в кластере $cluster"
  kubectl --kubeconfig=kubeconfig/$cluster.yaml apply -f submariner-crd-$NEW_VERSION.yaml
done

# 2. Обновление оператора
for cluster in "${CLUSTERS[@]}"; do
  echo "Обновление оператора в кластере $cluster"
  kubectl --kubeconfig=kubeconfig/$cluster.yaml set image deployment/submariner-operator \
    submariner-operator=quay.io/submariner/submariner-operator:$NEW_VERSION
done

# 3. Перезапуск gateway узлов
for cluster in "${CLUSTERS[@]}"; do
  echo "Перезапуск gateway в кластере $cluster"
  kubectl --kubeconfig=kubeconfig/$cluster.yaml rollout restart daemonset/submariner-gateway -n submariner-operator
done

# 4. Проверка статуса
for cluster in "${CLUSTERS[@]}"; do
  echo "Проверка статуса в кластере $cluster"
  kubectl --kubeconfig=kubeconfig/$cluster.yaml get submariner -n submariner-operator
done

echo "Обновление Submariner завершено успешно"
```

#### Обновление Cilium

```bash
#!/bin/bash
# Скрипт обновления Cilium

set -e

NEW_VERSION="1.15.0"
CLUSTERS=("eks-us-east-1" "eks-eu-west-1" "eks-ap-southeast-1" "k3s-moscow-dc1" "k3s-spb-dc2")

echo "Начинаем обновление Cilium до версии $NEW_VERSION"

# 1. Предварительная проверка
for cluster in "${CLUSTERS[@]}"; do
  echo "Предварительная проверка кластера $cluster"
  cilium --kubeconfig=kubeconfig/$cluster.yaml status
done

# 2. Обновление Cilium
for cluster in "${CLUSTERS[@]}"; do
  echo "Обновление Cilium в кластере $cluster"
  cilium --kubeconfig=kubeconfig/$cluster.yaml upgrade --version=$NEW_VERSION
done

# 3. Обновление Hubble
for cluster in "${CLUSTERS[@]}"; do
  echo "Обновление Hubble в кластере $cluster"
  cilium --kubeconfig=kubeconfig/$cluster.yaml hubble upgrade --version=$NEW_VERSION
done

# 4. Проверка политик после обновления
for cluster in "${CLUSTERS[@]}"; do
  echo "Проверка политик в кластере $cluster"
  kubectl --kubeconfig=kubeconfig/$cluster.yaml get ciliumnetworkpolicies -A
done

echo "Обновление Cilium завершено успешно"
```

## Масштабирование и оптимизация

### 1. Масштабирование кластеров

#### Добавление нового облачного кластера

```bash
#!/bin/bash
# Скрипт добавления нового облачного кластера

REGION=$1
CLUSTER_NAME="eks-${REGION}"

if [ -z "$REGION" ]; then
  echo "Использование: $0 <region>"
  exit 1
fi

echo "Добавление нового кластера в регионе $REGION"

# 1. Создание инфраструктуры
cd terraform/eks-clusters
terraform apply -var-file=../environments/production.tfvars -var="region=$REGION"

# 2. Получение kubeconfig
terraform output -raw ${CLUSTER_NAME}_kubeconfig > ../../kubeconfig/${CLUSTER_NAME}.yaml

# 3. Присоединение к Submariner федерации
kubectl --kubeconfig=kubeconfig/${CLUSTER_NAME}.yaml apply -f submariner-join-config.yaml

# 4. Установка сетевых компонентов
kubectl --kubeconfig=kubeconfig/${CLUSTER_NAME}.yaml apply -f cilium-install-config.yaml
kubectl --kubeconfig=kubeconfig/${CLUSTER_NAME}.yaml apply -f istio-install-config.yaml

# 5. Применение политик безопасности
kubectl --kubeconfig=kubeconfig/${CLUSTER_NAME}.yaml apply -f network-policies-segmentation.yaml

# 6. Обновление DNS
kubectl --kubeconfig=kubeconfig/eks-us-east-1.yaml apply -f dns-update-${CLUSTER_NAME}.yaml

echo "Кластер $CLUSTER_NAME успешно добавлен"
```

#### Добавление нового локального кластера

```bash
#!/bin/bash
# Скрипт добавления нового локального кластера

DATACENTER=$1
CLUSTER_NAME="k3s-${DATACENTER}"

if [ -z "$DATACENTER" ]; then
  echo "Использование: $0 <datacenter-name>"
  exit 1
fi

echo "Добавление нового локального кластера в дата-центре $DATACENTER"

# 1. Развертывание K3s
cd ansible/k3s-deployment
ansible-playbook -i inventory/new-hosts-${DATACENTER}.yml deploy-k3s.yml

# 2. Получение kubeconfig
ansible-playbook -i inventory/new-hosts-${DATACENTER}.yml get-kubeconfig.yml

# 3. Присоединение к федерации
kubectl --kubeconfig=kubeconfig/${CLUSTER_NAME}.yaml apply -f submariner-join-config.yaml

# 4. Настройка локальных политик безопасности
kubectl --kubeconfig=kubeconfig/${CLUSTER_NAME}.yaml apply -f local-security-policies.yaml

# 5. Настройка локального мониторинга
kubectl --kubeconfig=kubeconfig/${CLUSTER_NAME}.yaml apply -f local-monitoring-config.yaml

echo "Локальный кластер $CLUSTER_NAME успешно добавлен"
```

### 2. Оптимизация производительности

#### Настройка сетевых параметров

```bash
# Оптимизация параметров Cilium
kubectl patch configmap cilium-config -n cilium-system --kubeconfig=kubeconfig/eks-us-east-1.yaml --patch '
data:
  bpf-ct-global-tcp-max: "1000000"
  bpf-ct-global-any-max: "2000000"
  bpf-policy-map-max: "16384"
  bpf-lb-map-max: "65536"
'

# Оптимизация параметров Istio
kubectl patch configmap istio -n istio-system --kubeconfig=kubeconfig/eks-us-east-1.yaml --patch '
data:
  mesh: |
    defaultConfig:
      concurrency: 4
      holdApplicationUntilProxyStarts: true
    outboundTrafficPolicy:
      mode: REGISTRY_ONLY
'
```

#### Масштабирование компонентов

```bash
# Масштабирование API Gateway
kubectl autoscale deployment x0tta6bl4-gateway -n x0tta6bl4-gateway --kubeconfig=kubeconfig/eks-us-east-1.yaml \
  --cpu-percent=70 --min=3 --max=20

# Масштабирование Hubble серверов
kubectl autoscale deployment hubble-server -n x0tta6bl4-network-monitoring --kubeconfig=kubeconfig/eks-us-east-1.yaml \
  --cpu-percent=70 --min=2 --max=10
```

## Решение проблем

### 1. Диагностика сетевых проблем

#### Инструменты диагностики

**Cilium диагностика**:
```bash
# Проверка статуса Cilium
cilium status --verbose --kubeconfig=kubeconfig/eks-us-east-1.yaml

# Анализ сетевых flow
cilium hubble observe --type=drop --since=1m --kubeconfig=kubeconfig/eks-us-east-1.yaml

# Проверка политик
cilium hubble observe --type=policy-verdict --verdict=DENIED --kubeconfig=kubeconfig/eks-us-east-1.yaml

# Диагностика endpoint'ов
cilium endpoint list --kubeconfig=kubeconfig/eks-us-east-1.yaml
cilium endpoint get <endpoint-id> --kubeconfig=kubeconfig/eks-us-east-1.yaml
```

**Istio диагностика**:
```bash
# Проверка прокси статусов
istioctl proxy-status --kubeconfig=kubeconfig/eks-us-east-1.yaml

# Анализ конфигурации прокси
istioctl proxy-config routes <pod-name> -n x0tta6bl4-common --kubeconfig=kubeconfig/eks-us-east-1.yaml

# Проверка логов прокси
istioctl proxy-config log <pod-name> -n x0tta6bl4-common --kubeconfig=kubeconfig/eks-us-east-1.yaml

# Анализ Service Mesh
istioctl analyze --kubeconfig=kubeconfig/eks-us-east-1.yaml
```

**Submariner диагностика**:
```bash
# Проверка туннелей
kubectl exec -n submariner-operator deployment/submariner-gateway --kubeconfig=kubeconfig/eks-us-east-1.yaml \
  -- submariner diagnose all

# Проверка соединений
kubectl get endpoints -n submariner-operator --kubeconfig=kubeconfig/eks-us-east-1.yaml

# Логи gateway
kubectl logs -n submariner-operator daemonset/submariner-gateway --kubeconfig=kubeconfig/eks-us-east-1.yaml
```

### 2. Решение распространенных проблем

#### Проблема: Submariner туннели не устанавливаются

**Диагностика**:
```bash
# Проверка логов gateway
kubectl logs -n submariner-operator daemonset/submariner-gateway --kubeconfig=kubeconfig/eks-us-east-1.yaml

# Проверка firewall правил
kubectl exec -n submariner-operator daemonset/submariner-gateway --kubeconfig=kubeconfig/eks-us-east-1.yaml \
  -- iptables -L -n -v | grep -E "(4500|500)"

# Проверка сетевой связности
kubectl exec -n submariner-operator daemonset/submariner-gateway --kubeconfig=kubeconfig/eks-us-east-1.yaml \
  -- nc -zv <remote-gateway-ip> 4500
```

**Решение**:
```bash
# Перезапуск gateway узлов
kubectl rollout restart daemonset/submariner-gateway -n submariner-operator --kubeconfig=kubeconfig/eks-us-east-1.yaml

# Проверка и обновление firewall правил
kubectl exec -n submariner-operator daemonset/submariner-gateway --kubeconfig=kubeconfig/eks-us-east-1.yaml \
  -- iptables -I INPUT -p udp --dport 4500 -j ACCEPT
kubectl exec -n submariner-operator daemonset/submariner-gateway --kubeconfig=kubeconfig/eks-us-east-1.yaml \
  -- iptables -I INPUT -p udp --dport 500 -j ACCEPT
```

#### Проблема: Cilium политики не применяются

**Диагностика**:
```bash
# Проверка статуса политик
kubectl get ciliumnetworkpolicies -A --kubeconfig=kubeconfig/eks-us-east-1.yaml

# Проверка логов оператора
kubectl logs -n cilium-system deployment/cilium-operator --kubeconfig=kubeconfig/eks-us-east-1.yaml

# Проверка endpoint'ов
cilium endpoint list --kubeconfig=kubeconfig/eks-us-east-1.yaml | grep -v ready
```

**Решение**:
```bash
# Перезапуск оператора
kubectl rollout restart deployment/cilium-operator -n cilium-system --kubeconfig=kubeconfig/eks-us-east-1.yaml

# Регенерация политик
cilium policy delete --all --kubeconfig=kubeconfig/eks-us-east-1.yaml
kubectl apply -f cilium-zero-trust-policies.yaml --kubeconfig=kubeconfig/eks-us-east-1.yaml
```

#### Проблема: Istio mTLS не работает

**Диагностика**:
```bash
# Проверка сертификатов
istioctl authn tls-check <pod-name> -n x0tta6bl4-common --kubeconfig=kubeconfig/eks-us-east-1.yaml

# Проверка политик аутентификации
kubectl get peerauthentication -A --kubeconfig=kubeconfig/eks-us-east-1.yaml

# Проверка логов pilot
kubectl logs -n istio-system deployment/istiod --kubeconfig=kubeconfig/eks-us-east-1.yaml | grep -i "cert\|tls"
```

**Решение**:
```bash
# Проверка и обновление сертификатов
kubectl delete secret cacerts -n istio-system --kubeconfig=kubeconfig/eks-us-east-1.yaml
kubectl apply -f istio-ca-certificates.yaml --kubeconfig=kubeconfig/eks-us-east-1.yaml

# Перезапуск sidecar прокси
kubectl rollout restart deployment/<deployment-name> -n x0tta6bl4-common --kubeconfig=kubeconfig/eks-us-east-1.yaml
```

### 3. Автоматизированные скрипты диагностики

#### Скрипт полной диагностики сети

```bash
#!/bin/bash
# Полная диагностика сетевой инфраструктуры

LOG_FILE="network-diagnosis-$(date +%Y%m%d-%H%M%S).log"

echo "Начинаем полную диагностику сети" | tee -a $LOG_FILE

# 1. Проверка кластеров
echo "=== Проверка кластеров ===" | tee -a $LOG_FILE
for cluster in eks-us-east-1 eks-eu-west-1 eks-ap-southeast-1 k3s-moscow-dc1 k3s-spb-dc2; do
  echo "Кластер: $cluster" | tee -a $LOG_FILE
  kubectl --kubeconfig=kubeconfig/$cluster.yaml get nodes | tee -a $LOG_FILE
  kubectl --kubeconfig=kubeconfig/$cluster.yaml get pods -A | grep -v Running | wc -l | tee -a $LOG_FILE
done

# 2. Проверка Submariner
echo "=== Проверка Submariner ===" | tee -a $LOG_FILE
kubectl --kubeconfig=kubeconfig/eks-us-east-1.yaml get submariner -n submariner-operator -o yaml | tee -a $LOG_FILE

# 3. Проверка Cilium
echo "=== Проверка Cilium ===" | tee -a $LOG_FILE
cilium status --kubeconfig=kubeconfig/eks-us-east-1.yaml | tee -a $LOG_FILE

# 4. Проверка Istio
echo "=== Проверка Istio ===" | tee -a $LOG_FILE
istioctl proxy-status --kubeconfig=kubeconfig/eks-us-east-1.yaml | grep -E "(HEALTHY|UNHEALTHY)" | wc -l | tee -a $LOG_FILE

# 5. Проверка политик безопасности
echo "=== Проверка политик безопасности ===" | tee -a $LOG_FILE
kubectl --kubeconfig=kubeconfig/eks-us-east-1.yaml get ciliumnetworkpolicies -A | wc -l | tee -a $LOG_FILE

echo "Диагностика завершена. Результаты в файле: $LOG_FILE" | tee -a $LOG_FILE
```

## Безопасность и compliance

### 1. Мониторинг безопасности

#### Ежедневные проверки безопасности

```bash
# Проверка нарушений политик безопасности
curl -s "http://prometheus.x0tta6bl4-monitoring:9090/api/v1/query?query=increase(cilium_policy_denied_packets_total[24h])" | \
  jq '.data.result[] | select(.value[1] != "0")'

# Проверка подозрительной активности
kubectl logs -n x0tta6bl4-cross-zone-security deployment/cross-zone-threat-detector --kubeconfig=kubeconfig/eks-us-east-1.yaml | \
  grep -E "(suspicious|threat|attack)" | tail -10

# Проверка статуса сертификатов
kubectl get certificates -A --kubeconfig=kubeconfig/eks-us-east-1.yaml | grep -v True
```

#### Еженедельный аудит безопасности

```bash
# Генерация отчета безопасности
kubectl exec -n x0tta6bl4-cross-zone-security deployment/cross-zone-compliance-monitor --kubeconfig=kubeconfig/eks-us-east-1.yaml \
  -- /app/generate-security-report.sh --period=weekly --format=pdf

# Проверка compliance метрик
curl -s "http://prometheus.x0tta6bl4-monitoring:9090/api/v1/query?query=compliance_violations_total" | jq '.'
```

### 2. Управление сертификатами

#### Автоматическая ротация сертификатов

```bash
# Проверка истекающих сертификатов
kubectl get certificates -A --kubeconfig=kubeconfig/eks-us-east-1.yaml -o jsonpath='{range .items[?(@.status.conditions[0].type=="Ready")]}{.metadata.name}{" "}{.status.notAfter}{"\n"}{end}' | \
  awk '$2 <= "'$(date -d '+7 days' -Iseconds)'" {print $1}'

# Ротация сертификатов SPIRE
kubectl exec -n x0tta6bl4-security deployment/spire-server --kubeconfig=kubeconfig/eks-us-east-1.yaml \
  -- spire-server bundle show | jq -r '.ca_certificates[0].cert'

# Обновление сертификатов Istio
kubectl exec -n istio-system deployment/istiod --kubeconfig=kubeconfig/eks-us-east-1.yaml \
  -- curl -s http://localhost:8080/certs | jq '.[] | select(.cert_chain != null)'
```

### 3. Аудит и логирование

#### Настройка аудита API сервера

```yaml
# Конфигурация аудита
apiVersion: v1
kind: ConfigMap
metadata:
  name: audit-policy
  namespace: kube-system
data:
  audit-policy.yaml: |
    apiVersion: audit.k8s.io/v1
    kind: Policy
    rules:
    - level: RequestResponse
      namespaces: ["x0tta6bl4-*"]
      resources:
      - group: "networking.k8s.io"
        resources: ["networkpolicies"]
      verbs: ["create", "update", "patch", "delete"]
    - level: Metadata
      namespaces: ["*"]
      resources:
      - group: "cilium.io"
        resources: ["ciliumnetworkpolicies"]
      verbs: ["get", "list", "watch"]
```

#### Анализ аудит логов

```bash
# Поиск подозрительной активности в аудит логах
kubectl logs -n x0tta6bl4-network-monitoring deployment/network-security-analyzer --kubeconfig=kubeconfig/eks-us-east-1.yaml | \
  grep -E "(unauthorized|violation|attack|exploit)" | tail -20

# Анализ межзонного трафика
kubectl logs -n x0tta6bl4-cross-zone-security deployment/cross-zone-traffic-auditor --kubeconfig=kubeconfig/eks-us-east-1.yaml | \
  grep -E "(unusual|anomaly|suspicious)" | tail -10
```

## Резервное копирование и восстановление

### 1. Резервное копирование конфигурации

#### Автоматизированное резервное копирование

```bash
#!/bin/bash
# Скрипт резервного копирования сетевой конфигурации

BACKUP_DIR="network-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p $BACKUP_DIR

echo "Создание резервной копии сетевой конфигурации"

# 1. Резервное копирование конфигурации сети
for cluster in eks-us-east-1 eks-eu-west-1 eks-ap-southeast-1 k3s-moscow-dc1 k3s-spb-dc2; do
  echo "Резервное копирование кластера $cluster"
  kubectl --kubeconfig=kubeconfig/$cluster.yaml get all,networkpolicies,ciliumnetworkpolicies,authorizationpolicies -A -o yaml > \
    $BACKUP_DIR/${cluster}-network-config.yaml
done

# 2. Резервное копирование секретов (зашифрованных)
kubectl get secrets -A -o yaml | kubectl view-secret -o yaml > $BACKUP_DIR/encrypted-secrets.yaml

# 3. Резервное копирование сертификатов
kubectl get certificates -A -o yaml > $BACKUP_DIR/certificates.yaml

# 4. Архивация и шифрование
tar -czf $BACKUP_DIR.tar.gz $BACKUP_DIR
openssl enc -aes-256-cbc -salt -in $BACKUP_DIR.tar.gz -out $BACKUP_DIR.enc -k $BACKUP_ENCRYPTION_KEY

# 5. Загрузка в S3
aws s3 cp $BACKUP_DIR.enc s3://x0tta6bl4-backups/network/$BACKUP_DIR.enc

echo "Резервное копирование завершено: $BACKUP_DIR.enc"
```

### 2. Восстановление конфигурации

#### Восстановление после сбоя кластера

```bash
#!/bin/bash
# Скрипт восстановления сетевой конфигурации

CLUSTER_NAME=$1
BACKUP_FILE=$2

if [ -z "$CLUSTER_NAME" ] || [ -z "$BACKUP_FILE" ]; then
  echo "Использование: $0 <cluster-name> <backup-file>"
  exit 1
fi

echo "Восстановление сетевой конфигурации для кластера $CLUSTER_NAME"

# 1. Расшифровка резервной копии
openssl enc -aes-256-cbc -d -in $BACKUP_FILE -out decrypted-backup.tar.gz -k $BACKUP_ENCRYPTION_KEY
tar -xzf decrypted-backup.tar.gz

# 2. Восстановление конфигурации сети
kubectl --kubeconfig=kubeconfig/$CLUSTER_NAME.yaml apply -f $CLUSTER_NAME-network-config.yaml

# 3. Восстановление секретов
kubectl --kubeconfig=kubeconfig/$CLUSTER_NAME.yaml apply -f encrypted-secrets.yaml

# 4. Восстановление сертификатов
kubectl --kubeconfig=kubeconfig/$CLUSTER_NAME.yaml apply -f certificates.yaml

# 5. Перезапуск компонентов
kubectl --kubeconfig=kubeconfig/$CLUSTER_NAME.yaml rollout restart deployment -n submariner-operator
kubectl --kubeconfig=kubeconfig/$CLUSTER_NAME.yaml rollout restart deployment -n cilium-system
kubectl --kubeconfig=kubeconfig/$CLUSTER_NAME.yaml rollout restart deployment -n istio-system

echo "Восстановление завершено для кластера $CLUSTER_NAME"
```

#### Восстановление после кибератаки

```bash
#!/bin/bash
# Скрипт восстановления после кибератаки

echo "Начинаем восстановление после кибератаки"

# 1. Изоляция зараженных компонентов
kubectl cordon <infected-nodes>
kubectl drain <infected-nodes> --ignore-daemonsets --delete-emptydir-data

# 2. Удаление подозрительных ресурсов
kubectl delete pods -A -l suspicious=true
kubectl delete networkpolicies -A -l suspicious=true

# 3. Восстановление из чистой резервной копии
./restore-network-config.sh eks-us-east-1 clean-backup-2025-01-01.enc

# 4. Повторная инициализация сетевой федерации
kubectl apply -f submariner-reinitialize-config.yaml

# 5. Проверка целостности
./validate-network-integrity.sh

echo "Восстановление после кибератаки завершено"
```

### 3. Тестирование восстановления

#### Регулярное тестирование процедур восстановления

```bash
# Тестирование восстановления API Gateway
kubectl scale deployment x0tta6bl4-gateway -n x0tta6bl4-gateway --replicas=0 --kubeconfig=kubeconfig/eks-us-east-1.yaml
sleep 30
kubectl scale deployment x0tta6bl4-gateway -n x0tta6bl4-gateway --replicas=3 --kubeconfig=kubeconfig/eks-us-east-1.yaml

# Тестирование восстановления Submariner туннелей
kubectl delete submariner -n submariner-operator --kubeconfig=kubeconfig/eks-us-east-1.yaml
kubectl apply -f submariner-config.yaml --kubeconfig=kubeconfig/eks-us-east-1.yaml

# Тестирование восстановления политик безопасности
kubectl delete ciliumnetworkpolicies -n x0tta6bl4-common --kubeconfig=kubeconfig/eks-us-east-1.yaml
kubectl apply -f cilium-zero-trust-policies.yaml --kubeconfig=kubeconfig/eks-us-east-1.yaml
```

## Заключение

Это операционное руководство обеспечивает полную основу для управления сетевой инфраструктурой x0tta6bl4. Регулярное следование описанным процедурам гарантирует стабильность, безопасность и производительность системы.

**Ключевые принципы эксплуатации**:
- Проактивный мониторинг и раннее обнаружение проблем
- Структурированный подход к управлению изменениями
- Регулярное тестирование процедур восстановления
- Постоянное улучшение процессов на основе анализа инцидентов

**Контакты для поддержки**:
- Сетевая команда: network-team@x0tta6bl4.com
- Команда безопасности: security-team@x0tta6bl4.com
- Дежурный инженер: oncall@x0tta6bl4.com

Для получения дополнительной информации обращайтесь к полной документации в `docs/complete-network-architecture-documentation.md`.