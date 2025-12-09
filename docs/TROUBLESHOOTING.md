# Troubleshooting Guide - x0tta6bl4

## Обзор

Данное руководство содержит решения для наиболее распространённых проблем при работе с x0tta6bl4. Руководство организовано по категориям проблем и включает диагностические команды, решения и профилактические меры.

## Диагностические инструменты

### Основные команды

```bash
# Проверка статуса кластера
kubectl get nodes
kubectl get pods -A
kubectl get services -A

# Проверка событий
kubectl get events --sort-by=.metadata.creationTimestamp

# Проверка ресурсов
kubectl top nodes
kubectl top pods -A

# Проверка логов
kubectl logs <pod-name> -n <namespace> --tail=100
kubectl logs <pod-name> -n <namespace> --previous
```

### Специализированные инструменты

```bash
# Istio диагностика
istioctl proxy-status
istioctl proxy-config cluster <pod-name>
istioctl analyze

# Cilium диагностика
cilium status
cilium connectivity test
cilium hubble observe

# Submariner диагностика
subctl show connections
subctl show endpoints
subctl show networks
```

## Проблемы с аутентификацией

### OAuth 2.0 ошибки

#### Проблема: Invalid client credentials

**Симптомы**:
```
HTTP 401 Unauthorized
{
  "error": "invalid_client",
  "error_description": "Invalid client credentials"
}
```

**Диагностика**:
```bash
# Проверка клиентов
kubectl get configmap oauth-clients -n x0tta6bl4-system -o yaml

# Проверка логов OAuth provider
kubectl logs -l app=oauth-provider -n x0tta6bl4-system --tail=50
```

**Решение**:
```bash
# Обновление client secret
kubectl patch configmap oauth-clients -n x0tta6bl4-system --patch '
data:
  web-app-secret: "new_secret_here"
'

# Перезапуск OAuth provider
kubectl rollout restart deployment/oauth-provider -n x0tta6bl4-system
```

#### Проблема: Token expired

**Симптомы**:
```
HTTP 401 Unauthorized
{
  "error": "invalid_token",
  "error_description": "Token expired"
}
```

**Решение**:
```bash
# Получение нового токена
curl -X POST https://api.x0tta6bl4.com/oauth/token \
  -d "grant_type=refresh_token&refresh_token=REFRESH_TOKEN&client_id=web-app&client_secret=secret"

# Проверка настроек токена
kubectl get configmap oauth-config -n x0tta6bl4-system -o yaml
```

### mTLS проблемы

#### Проблема: Certificate validation failed

**Симптомы**:
```
x509: certificate signed by unknown authority
TLS handshake failed
```

**Диагностика**:
```bash
# Проверка сертификатов
kubectl get secrets -n istio-system | grep cacerts
kubectl describe secret istio-ca-secret -n istio-system

# Проверка Istio конфигурации
istioctl proxy-config rootca <pod-name>
```

**Решение**:
```bash
# Пересоздание CA сертификатов
kubectl delete secret istio-ca-secret -n istio-system
istioctl install --set values.pilot.env.EXTERNAL_ISTIOD=false

# Проверка после исправления
istioctl proxy-status
```

## Проблемы с сетью

### Mesh Network проблемы

#### Проблема: Nodes не могут подключиться

**Симптомы**:
```
Connection refused
Network unreachable
High packet loss
```

**Диагностика**:
```bash
# Проверка статуса mesh
curl -H "Authorization: Bearer $TOKEN" \
  https://api.x0tta6bl4.com/api/v1/mesh/status

# Проверка BATMAN-adv
kubectl exec -it <mesh-node-pod> -- batctl o
kubectl exec -it <mesh-node-pod> -- batctl n

# Проверка сетевых интерфейсов
kubectl exec -it <mesh-node-pod> -- ip addr show
```

**Решение**:
```bash
# Перезапуск mesh узлов
kubectl rollout restart daemonset/mesh-node -n x0tta6bl4-system

# Проверка firewall правил
kubectl exec -it <mesh-node-pod> -- ufw status

# Обновление маршрутов
kubectl exec -it <mesh-node-pod> -- batctl gw_mode server
```

#### Проблема: Высокая задержка

**Симптомы**:
```
Latency > 100ms
Slow response times
```

**Диагностика**:
```bash
# Проверка метрик
curl -H "Authorization: Bearer $TOKEN" \
  "https://api.x0tta6bl4.com/api/v1/metrics?metric=latency&period=1h"

# Проверка маршрутов
kubectl exec -it <mesh-node-pod> -- batctl tr <destination-ip>

# Проверка нагрузки
kubectl top pods -n x0tta6bl4-system
```

**Решение**:
```bash
# Оптимизация маршрутизации
kubectl patch configmap mesh-config -n x0tta6bl4-system --patch '
data:
  routing_algorithm: "k-disjoint-spf"
  max_hops: "5"
'

# Масштабирование узлов
kubectl scale daemonset/mesh-node --replicas=10 -n x0tta6bl4-system
```

### Submariner Federation проблемы

#### Проблема: Cross-cluster communication failed

**Симптомы**:
```
Connection timeout
Service unreachable
IPSec tunnel down
```

**Диагностика**:
```bash
# Проверка соединений
subctl show connections

# Проверка endpoints
subctl show endpoints

# Проверка IPSec статуса
kubectl logs -l app=submariner-gateway -n submariner-operator --tail=100
```

**Решение**:
```bash
# Перезапуск Submariner
kubectl rollout restart daemonset/submariner-gateway -n submariner-operator

# Проверка firewall правил
ufw allow 500/udp
ufw allow 4500/udp

# Обновление PSK
kubectl delete secret submariner-ipsec-keys -n submariner-operator
subctl join broker-info.subm --clusterid k3s-moscow-dc1
```

## Проблемы с AI/ML сервисами

### Anomaly Detection проблемы

#### Проблема: False positives

**Симптомы**:
```
Too many anomalies detected
Low precision
High false positive rate
```

**Диагностика**:
```bash
# Проверка модели
kubectl exec -it <ai-service-pod> -- python -c "
import pickle
with open('/models/isolation_forest.pkl', 'rb') as f:
    model = pickle.load(f)
print(f'Model contamination: {model.contamination}')
print(f'Model n_estimators: {model.n_estimators}')
"

# Проверка метрик
curl -H "Authorization: Bearer $TOKEN" \
  "https://api.x0tta6bl4.com/api/v1/ai/anomaly-detection/metrics"
```

**Решение**:
```bash
# Обновление порога
kubectl patch configmap ai-config -n x0tta6bl4-system --patch '
data:
  anomaly_threshold: "0.05"
  contamination: "0.01"
'

# Переобучение модели
kubectl exec -it <ai-service-pod> -- python /scripts/retrain_model.py
```

#### Проблема: Model not found

**Симптомы**:
```
FileNotFoundError: /models/isolation_forest.pkl
Model loading failed
```

**Решение**:
```bash
# Проверка PVC
kubectl get pvc ml-models-pvc -n x0tta6bl4-system

# Восстановление модели
kubectl exec -it <ai-service-pod> -- python /scripts/download_model.py

# Проверка после восстановления
kubectl exec -it <ai-service-pod> -- ls -la /models/
```

### Predictive Maintenance проблемы

#### Проблема: Low prediction accuracy

**Симптомы**:
```
High prediction error
Poor model performance
```

**Диагностика**:
```bash
# Проверка качества данных
kubectl exec -it <ai-service-pod> -- python -c "
import pandas as pd
df = pd.read_csv('/data/metrics.csv')
print(f'Data shape: {df.shape}')
print(f'Missing values: {df.isnull().sum().sum()}')
print(f'Data quality: {df.describe()}')
"

# Проверка метрик модели
curl -H "Authorization: Bearer $TOKEN" \
  "https://api.x0tta6bl4.com/api/v1/ai/predictive-maintenance/metrics"
```

**Решение**:
```bash
# Обновление данных
kubectl exec -it <ai-service-pod> -- python /scripts/update_training_data.py

# Переобучение модели
kubectl exec -it <ai-service-pod> -- python /scripts/retrain_predictive_model.py

# Проверка после обновления
kubectl exec -it <ai-service-pod> -- python /scripts/validate_model.py
```

## Проблемы с Self-Healing

### MAPE-K Loop проблемы

#### Проблема: Loop stuck in MONITOR state

**Симптомы**:
```
No recovery actions taken
High MTTR
System not healing
```

**Диагностика**:
```bash
# Проверка статуса MAPE-K
curl -H "Authorization: Bearer $TOKEN" \
  https://api.x0tta6bl4.com/api/v1/self-healing/mape-k/status

# Проверка логов
kubectl logs -l app=mape-k-controller -n x0tta6bl4-system --tail=100

# Проверка метрик
kubectl exec -it <mape-k-pod> -- curl localhost:8080/metrics
```

**Решение**:
```bash
# Принудительный переход в ANALYZE
kubectl exec -it <mape-k-pod> -- curl -X POST localhost:8080/force-analyze

# Обновление конфигурации
kubectl patch configmap mape-k-config -n x0tta6bl4-system --patch '
data:
  analysis_threshold: "0.5"
  monitoring_interval: "30s"
'

# Перезапуск контроллера
kubectl rollout restart deployment/mape-k-controller -n x0tta6bl4-system
```

#### Проблема: Recovery actions failing

**Симптомы**:
```
Recovery timeout
Action execution failed
High failure rate
```

**Диагностика**:
```bash
# Проверка recovery логов
kubectl logs -l app=recovery-executor -n x0tta6bl4-system --tail=100

# Проверка RBAC
kubectl auth can-i create pods --as=system:serviceaccount:x0tta6bl4-system:recovery-executor

# Проверка ресурсов
kubectl top pods -n x0tta6bl4-system
```

**Решение**:
```bash
# Обновление RBAC
kubectl apply -f k8s-manifests/recovery-rbac.yaml

# Увеличение timeout
kubectl patch configmap recovery-config -n x0tta6bl4-system --patch '
data:
  execution_timeout: "600s"
  retry_attempts: "3"
'

# Перезапуск executor
kubectl rollout restart deployment/recovery-executor -n x0tta6bl4-system
```

## Проблемы с Quantum Services

### Post-Quantum Cryptography проблемы

#### Проблема: PQC operations failing

**Симптомы**:
```
Encryption failed
Signature verification failed
Key generation timeout
```

**Диагностика**:
```bash
# Проверка python-oqs
kubectl exec -it <quantum-service-pod> -- python -c "
import oqs
print(f'OQS version: {oqs.version()}')
print(f'Available KEMs: {oqs.get_enabled_kem_mechanisms()}')
print(f'Available Sigs: {oqs.get_enabled_sig_mechanisms()}')
"

# Проверка логов
kubectl logs -l app=quantum-service -n x0tta6bl4-quantum --tail=100
```

**Решение**:
```bash
# Обновление python-oqs
kubectl exec -it <quantum-service-pod> -- pip install --upgrade oqs

# Проверка fallback режима
kubectl patch configmap quantum-config -n x0tta6bl4-quantum --patch '
data:
  fallback_enabled: "true"
  fallback_algorithm: "RSA-2048"
'

# Перезапуск сервиса
kubectl rollout restart deployment/quantum-service -n x0tta6bl4-quantum
```

#### Проблема: Key rotation failed

**Симптомы**:
```
Key rotation timeout
Certificate expired
mTLS handshake failed
```

**Диагностика**:
```bash
# Проверка сертификатов
kubectl get secrets -n x0tta6bl4-quantum | grep cert
kubectl describe secret quantum-ca-cert -n x0tta6bl4-quantum

# Проверка rotation логов
kubectl logs -l app=key-rotator -n x0tta6bl4-quantum --tail=100
```

**Решение**:
```bash
# Принудительная ротация
kubectl exec -it <key-rotator-pod> -- curl -X POST localhost:8080/rotate-keys

# Обновление расписания
kubectl patch configmap key-rotation-config -n x0tta6bl4-quantum --patch '
data:
  rotation_interval: "24h"
  grace_period: "2h"
'

# Перезапуск rotator
kubectl rollout restart deployment/key-rotator -n x0tta6bl4-quantum
```

## Проблемы с мониторингом

### Prometheus проблемы

#### Проблема: Metrics not collected

**Симптомы**:
```
No metrics in Grafana
ServiceMonitor not working
Targets down
```

**Диагностика**:
```bash
# Проверка ServiceMonitor
kubectl get servicemonitor -A
kubectl describe servicemonitor x0tta6bl4-services -n monitoring

# Проверка targets
kubectl port-forward svc/prometheus 9090:9090 -n monitoring
# Открыть http://localhost:9090/targets

# Проверка endpoints
kubectl get endpoints -A
```

**Решение**:
```bash
# Обновление ServiceMonitor
kubectl apply -f k8s-manifests/prometheus-servicemonitor.yaml

# Проверка метрик endpoint
kubectl exec -it <app-pod> -- curl localhost:8080/metrics

# Перезапуск Prometheus
kubectl rollout restart deployment/prometheus -n monitoring
```

### Grafana проблемы

#### Проблема: Dashboard not loading

**Симптомы**:
```
Dashboard empty
Query failed
No data points
```

**Диагностика**:
```bash
# Проверка Grafana логов
kubectl logs -l app=grafana -n monitoring --tail=100

# Проверка Prometheus connection
kubectl exec -it <grafana-pod> -- curl http://prometheus:9090/api/v1/query?query=up

# Проверка datasource
kubectl exec -it <grafana-pod> -- curl http://localhost:3000/api/datasources
```

**Решение**:
```bash
# Обновление datasource
kubectl patch configmap grafana-datasources -n monitoring --patch '
data:
  datasources.yaml: |
    apiVersion: 1
    datasources:
    - name: Prometheus
      type: prometheus
      url: http://prometheus:9090
      access: proxy
'

# Перезапуск Grafana
kubectl rollout restart deployment/grafana -n monitoring
```

## Проблемы с производительностью

### Высокое использование ресурсов

#### Проблема: High CPU usage

**Симптомы**:
```
CPU usage > 80%
Slow response times
Pod eviction
```

**Диагностика**:
```bash
# Проверка ресурсов
kubectl top pods -A
kubectl describe pod <high-cpu-pod> -n <namespace>

# Проверка профиля
kubectl exec -it <pod> -- top
kubectl exec -it <pod> -- ps aux
```

**Решение**:
```bash
# Увеличение ресурсов
kubectl patch deployment <deployment> -n <namespace> --patch '
spec:
  template:
    spec:
      containers:
      - name: <container>
        resources:
          requests:
            cpu: 500m
            memory: 1Gi
          limits:
            cpu: 2000m
            memory: 4Gi
'

# Масштабирование
kubectl scale deployment <deployment> --replicas=3 -n <namespace>
```

#### Проблема: High memory usage

**Симптомы**:
```
Memory usage > 90%
OOMKilled pods
Memory leaks
```

**Диагностика**:
```bash
# Проверка памяти
kubectl top pods -A --sort-by=memory
kubectl describe pod <high-memory-pod> -n <namespace>

# Проверка heap
kubectl exec -it <pod> -- python -c "
import psutil
print(f'Memory usage: {psutil.virtual_memory().percent}%')
print(f'Available memory: {psutil.virtual_memory().available / 1024**3:.2f} GB')
"
```

**Решение**:
```bash
# Увеличение memory limits
kubectl patch deployment <deployment> -n <namespace> --patch '
spec:
  template:
    spec:
      containers:
      - name: <container>
        resources:
          limits:
            memory: 8Gi
'

# Оптимизация приложения
kubectl exec -it <pod> -- python /scripts/optimize_memory.py
```

## Проблемы с безопасностью

### Network Policy проблемы

#### Проблема: Traffic blocked by policy

**Симптомы**:
```
Connection refused
Network unreachable
Policy violation
```

**Диагностика**:
```bash
# Проверка policies
kubectl get ciliumnetworkpolicies -A
kubectl describe ciliumnetworkpolicy <policy> -n <namespace>

# Проверка flows
kubectl exec -it <cilium-pod> -- cilium hubble observe --follow

# Проверка endpoints
kubectl get endpoints -A
```

**Решение**:
```bash
# Обновление policy
kubectl patch ciliumnetworkpolicy <policy> -n <namespace> --patch '
spec:
  ingress:
  - fromEndpoints:
    - matchLabels:
        app: <allowed-app>
    toPorts:
    - ports:
      - port: "8080"
        protocol: TCP
'

# Временное отключение policy
kubectl delete ciliumnetworkpolicy <policy> -n <namespace>
```

### Certificate проблемы

#### Проблема: Certificate expired

**Симптомы**:
```
TLS handshake failed
Certificate expired
mTLS connection failed
```

**Диагностика**:
```bash
# Проверка сертификатов
kubectl get secrets -A | grep cert
kubectl describe secret <cert-secret> -n <namespace>

# Проверка даты истечения
kubectl exec -it <pod> -- openssl x509 -in /etc/ssl/certs/cert.pem -text -noout | grep "Not After"
```

**Решение**:
```bash
# Обновление сертификата
kubectl delete secret <cert-secret> -n <namespace>
kubectl apply -f k8s-manifests/new-certificate.yaml

# Перезапуск pods
kubectl rollout restart deployment <deployment> -n <namespace>
```

## Профилактические меры

### Регулярные проверки

```bash
#!/bin/bash
# health-check.sh

echo "=== x0tta6bl4 Health Check ==="

# Проверка кластера
echo "1. Checking cluster status..."
kubectl get nodes
kubectl get pods -A | grep -v Running

# Проверка ресурсов
echo "2. Checking resources..."
kubectl top nodes
kubectl top pods -A | head -20

# Проверка событий
echo "3. Checking recent events..."
kubectl get events --sort-by=.metadata.creationTimestamp | tail -10

# Проверка сертификатов
echo "4. Checking certificates..."
kubectl get secrets -A | grep cert | while read ns name rest; do
  kubectl get secret $name -n $ns -o jsonpath='{.data.tls\.crt}' | base64 -d | openssl x509 -noout -dates
done

# Проверка mesh статуса
echo "5. Checking mesh status..."
curl -s -H "Authorization: Bearer $TOKEN" \
  https://api.x0tta6bl4.com/api/v1/mesh/status | jq '.network_health'

echo "=== Health Check Complete ==="
```

### Мониторинг алертов

```bash
#!/bin/bash
# alert-check.sh

echo "=== Checking Alerts ==="

# Проверка Prometheus алертов
kubectl port-forward svc/prometheus 9090:9090 -n monitoring &
sleep 5

ALERTS=$(curl -s http://localhost:9090/api/v1/alerts | jq '.data.alerts | length')
echo "Active alerts: $ALERTS"

if [ $ALERTS -gt 0 ]; then
  echo "Alert details:"
  curl -s http://localhost:9090/api/v1/alerts | jq '.data.alerts[] | {alertname: .labels.alertname, state: .state, severity: .labels.severity}'
fi

kill %1
```

### Автоматическое восстановление

```bash
#!/bin/bash
# auto-recovery.sh

echo "=== Auto Recovery ==="

# Проверка и перезапуск failed pods
kubectl get pods -A --field-selector=status.phase=Failed -o name | while read pod; do
  echo "Restarting failed pod: $pod"
  kubectl delete $pod
done

# Проверка и перезапуск pending pods
kubectl get pods -A --field-selector=status.phase=Pending -o name | while read pod; do
  echo "Checking pending pod: $pod"
  kubectl describe $pod | grep -i "failed to pull image" && kubectl delete $pod
done

# Проверка и перезапуск crashloopbackoff pods
kubectl get pods -A | grep CrashLoopBackOff | awk '{print $1 " " $2}' | while read ns pod; do
  echo "Restarting crashloop pod: $ns/$pod"
  kubectl delete pod $pod -n $ns
done

echo "=== Auto Recovery Complete ==="
```

## Контакты поддержки

### Внутренняя поддержка

- **Slack**: #x0tta6bl4-support
- **Email**: support@x0tta6bl4.com
- **Phone**: +1-555-x0tta6bl4

### Внешняя поддержка

- **GitHub Issues**: https://github.com/x0tta6bl4/issues
- **Discord**: https://discord.gg/x0tta6bl4
- **Documentation**: https://docs.x0tta6bl4.com

### Экстренные контакты

- **PagerDuty**: x0tta6bl4-oncall
- **Emergency Email**: emergency@x0tta6bl4.com
- **Emergency Phone**: +1-555-EMERGENCY