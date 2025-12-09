# Руководство по troubleshooting x0tta6bl4

## Обзор процесса диагностики

### Методология troubleshooting

1. **Сбор информации** - собрать все доступные данные о проблеме
2. **Анализ симптомов** - определить возможные причины
3. **Гипотеза** - сформулировать предположения о корне проблемы
4. **Тестирование** - проверить гипотезы
5. **Решение** - применить исправление
6. **Верификация** - убедиться в решении проблемы
7. **Документирование** - зафиксировать инцидент и решение

### Инструменты диагностики

```bash
# Основные инструменты для диагностики
kubectl          # Управление Kubernetes
stern            # Логи с нескольких подов
k9s             # TUI для Kubernetes
telepresence    # Локальная разработка
chaos-mesh      # Тестирование отказоустойчивости
```

## Распространенные проблемы и решения

### 1. Проблемы с производительностью

#### Высокая нагрузка на CPU

**Симптомы:**
- Узлы показывают >80% использования CPU
- Замедление API ответов
- Очереди в сервисах

**Диагностика:**
```bash
# Найти поды с высоким использованием CPU
kubectl top pods -A --sort-by=cpu

# Найти узлы с высокой нагрузкой
kubectl top nodes --sort-by=cpu

# Проверить горизонтальное масштабирование
kubectl get hpa -A

# Анализ логов на предмет узких мест
kubectl logs -l app=api-gateway --since=10m | grep -E "(ERROR|WARN|timeout)"
```

**Решения:**
```bash
# Масштабирование HPA
kubectl patch hpa api-gateway-hpa -p '{"spec":{"minReplicas":5}}' -n x0tta6bl4-system

# Добавление ресурсов узлам
kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: cluster-autoscaler-config
  namespace: kube-system
data:
  cluster-autoscaler-config: |
    scale-down-enabled: true
    scale-down-delay-after-add: 10m
    scale-down-delay-after-delete: 10s
    scale-down-delay-after-failure: 3m
EOF
```

#### Высокое использование памяти

**Симптомы:**
- OOMKilled события в логах
- Поды перезапускаются
- Замедление системы

**Диагностика:**
```bash
# Поиск OOMKilled подов
kubectl get events --field-selector involvedObject.kind=Pod | grep OOMKilled

# Анализ использования памяти
kubectl top pods -A --sort-by=memory

# Проверка лимитов памяти
kubectl describe pod <pod-name> | grep -A 10 "Containers"

# Анализ утечек памяти
kubectl exec <pod-name> -- sh -c 'ps aux | head -20'
```

**Решения:**
```bash
# Увеличение лимитов памяти
kubectl patch deployment api-gateway -p '{"spec":{"template":{"spec":{"containers":[{"name":"api-gateway","resources":{"limits":{"memory":"1Gi"}}}]}}}' -n x0tta6bl4-system

# Перезапуск подов с утечкой памяти
kubectl rollout restart deployment/api-gateway -n x0tta6bl4-system
```

### 2. Проблемы с сетью

#### Потеря соединений между кластерами

**Симптомы:**
- Submariner показывает disconnected статус
- API вызовы между регионами таймаутятся
- Логи показывают connection refused

**Диагностика:**
```bash
# Проверка статуса Submariner
kubectl get submariner -A

# Проверка Gateway nodes
kubectl get nodes -l submariner.io/gateway=true

# Тестирование сетевого соединения
kubectl run test-pod --image=curlimages/curl --restart=Never --rm -it -- \
    curl -m 10 http://test-service.k3s-moscow.svc.clusterset.local/health

# Проверка firewall правил
kubectl get networkpolicies -A
```

**Решения:**
```bash
# Перезапуск Submariner компонентов
kubectl rollout restart deployment/submariner-operator -n submariner-operator

# Проверка и обновление сетевых политик
kubectl apply -f network-policies/ -n x0tta6bl4-system

# Диагностика конкретного соединения
kubectl exec test-pod -- traceroute test-service.k3s-moscow.svc.clusterset.local
```

#### Проблемы с сервис-дискавери

**Симптомы:**
- Сервисы не могут найти друг друга
- DNS резолвинг не работает
- CoreDNS поды в CrashLoopBackOff

**Диагностика:**
```bash
# Проверка CoreDNS
kubectl get pods -n kube-system -l k8s-app=kube-dns

# Тестирование DNS резолвинга
kubectl run dns-test --image=busybox:1.28 --restart=Never --rm -it -- nslookup kubernetes.default

# Проверка сервисов
kubectl get endpoints -A

# Логи CoreDNS
kubectl logs -n kube-system -l k8s-app=kube-dns
```

**Решения:**
```bash
# Перезапуск CoreDNS
kubectl rollout restart deployment/coredns -n kube-system

# Проверка конфигурации DNS
kubectl get configmap coredns -n kube-system -o yaml

# Очистка DNS кэша
kubectl delete pod -l k8s-app=kube-dns -n kube-system
```

### 3. Проблемы с хранением данных

#### Проблемы с PersistentVolumes

**Симптомы:**
- PVC в Pending состоянии
- StorageClass не найден
- Недостаточно места в storage

**Диагностика:**
```bash
# Проверка PVC и PV
kubectl get pvc,pv -A

# Проверка StorageClass
kubectl get storageclass

# Проверка событий
kubectl get events --field-selector involvedObject.kind=PersistentVolumeClaim

# Проверка места в storage
kubectl exec deployment/storage-exporter -- df -h
```

**Решения:**
```bash
# Создание нового StorageClass
kubectl apply -f - <<EOF
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: x0tta6bl4-fast-ssd
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp3
  iopsPerGB: "3000"
  throughputPerGB: "125"
reclaimPolicy: Delete
allowVolumeExpansion: true
EOF

# Расширение PVC
kubectl patch pvc <pvc-name> -p '{"spec":{"resources":{"requests":{"storage":"50Gi"}}}}'
```

#### Проблемы с базами данных

**Симптомы:**
- Медленные запросы к БД
- Connection pool исчерпан
- Replica lag в PostgreSQL

**Диагностика:**
```bash
# Проверка состояния Aurora
aws rds describe-db-clusters --db-cluster-identifier x0tta6bl4-aurora --region us-east-1

# Проверка репликации
kubectl exec postgresql-client -- psql $DATABASE_URL -c "SELECT * FROM pg_stat_replication;"

# Проверка медленных запросов
kubectl exec postgresql-client -- psql $DATABASE_URL -c "SELECT * FROM pg_stat_statements ORDER BY mean_time DESC LIMIT 10;"

# Проверка подключений
kubectl exec postgresql-client -- psql $DATABASE_URL -c "SELECT count(*) FROM pg_stat_activity;"
```

**Решения:**
```bash
# Перезапуск connection pool
kubectl rollout restart deployment/api-gateway -n x0tta6bl4-system

# Оптимизация запросов
kubectl exec postgresql-client -- psql $DATABASE_URL -c "CREATE INDEX CONCURRENTLY idx_name ON table_name(column_name);"

# Масштабирование read replicas
aws rds create-db-instance-read-replica --db-instance-identifier x0tta6bl4-aurora-replica-3 --source-db-cluster-identifier x0tta6bl4-aurora --region us-east-1
```

### 4. Проблемы с безопасностью

#### Проблемы с аутентификацией

**Симптомы:**
- Пользователи не могут войти в систему
- JWT токены не валидируются
- Vault недоступен

**Диагностика:**
```bash
# Проверка логов аутентификации
kubectl logs -l app=api-gateway -n x0tta6bl4-system | grep -i auth

# Проверка статуса Vault
kubectl exec vault-0 -n vault -- vault status

# Проверка секретов
kubectl get secrets -n x0tta6bl4-system

# Проверка сертификатов
kubectl get certificates -A --sort-by=.spec.renewBefore
```

**Решения:**
```bash
# Разблокировка Vault (если запечатан)
kubectl exec vault-0 -n vault -- vault operator unseal <unseal-key>

# Обновление сертификатов
kubectl apply -f certificates/ -n x0tta6bl4-system

# Проверка политик аутентификации
kubectl exec vault-0 -n vault -- vault auth list
```

#### Нарушения сетевой безопасности

**Симптомы:**
- Неожиданные соединения в логах
- Срабатывание WAF правил
- Аномалии в сетевом трафике

**Диагностика:**
```bash
# Проверка сетевых политик
kubectl get networkpolicies -A

# Анализ сетевого трафика
kubectl exec cilium-pod -- cilium bpf tunnel list

# Проверка логов WAF
kubectl logs -l app=waf-proxy | grep -E "(blocked|denied|attack)"

# Анализ аномалий
kubectl exec deployment/anomaly-detector -- python detect_anomalies.py
```

**Решения:**
```bash
# Усиление сетевых политик
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: strict-api-access
  namespace: x0tta6bl4-system
spec:
  podSelector:
    matchLabels:
      app: api-gateway
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: ingress-nginx
    ports:
    - protocol: TCP
      port: 8000
EOF

# Блокировка подозрительных IP
kubectl exec deployment/waf-proxy -- iptables -A INPUT -s <suspicious-ip> -j DROP
```

### 5. Проблемы с квантовыми сервисами

#### Отказ квантовых вычислений

**Симптомы:**
- Квантовые операции завершаются с ошибками
- Низкий coherence time
- Высокий уровень gate errors

**Диагностика:**
```bash
# Проверка статуса квантовых сервисов
kubectl get pods -n x0tta6bl4-quantum -l app=quantum-services

# Проверка метрик квантовых операций
curl -s http://quantum-monitor:9090/api/v1/query?query='quantum_gate_error_rate'

# Анализ логов квантовых сервисов
kubectl logs -n x0tta6bl4-quantum -l app=quantum-services --since=10m

# Проверка квантового оборудования
kubectl exec quantum-exporter -- python check_quantum_hardware.py
```

**Решения:**
```bash
# Перезапуск квантовых сервисов
kubectl rollout restart deployment/quantum-services -n x0tta6bl4-quantum

# Калибровка квантового оборудования
kubectl exec quantum-calibration -- python calibrate_quantum_system.py

# Проверка и обновление квантовых ключей
kubectl exec vault-0 -n vault -- vault kv get secret/x0tta6bl4/quantum-keys
```

#### Проблемы с квантовыми ключами

**Симптомы:**
- Ошибки шифрования/дешифрования
- Невалидные квантовые ключи
- Проблемы с Vault интеграцией

**Диагностика:**
```bash
# Проверка статуса Vault
kubectl exec vault-0 -n vault -- vault status

# Проверка квантовых секретов
kubectl get secrets -n x0tta6bl4-quantum

# Тестирование квантового шифрования
kubectl exec quantum-test -- python test_quantum_encryption.py

# Проверка ротации ключей
kubectl exec vault-0 -n vault -- vault kv metadata get secret/x0tta6bl4/quantum-keys
```

**Решения:**
```bash
# Ротация квантовых ключей
kubectl exec vault-0 -n vault -- vault kv put secret/x0tta6bl4/quantum-keys \
    public_key="$(openssl rand -hex 32)" \
    private_key="$(openssl rand -hex 64)"

# Перезапуск сервисов с новыми ключами
kubectl rollout restart deployment/quantum-services -n x0tta6bl4-quantum

# Валидация новых ключей
kubectl exec quantum-validator -- python validate_quantum_keys.py
```

## Инструменты диагностики

### Скрипт полной диагностики системы

```bash
#!/bin/bash
# full-system-diag.sh

echo "=== Полная диагностика системы x0tta6bl4 ==="
echo "$(date)"

# Диагностика кластеров
echo -e "\n1. Диагностика кластеров:"
for context in eks-us-east-1 eks-eu-west-1 eks-ap-southeast-1 k3s-moscow k3s-spb; do
    echo -e "\n--- Кластер: $context ---"
    kubectl --context=$context cluster-info
    kubectl --context=$context get nodes | grep -E "(NAME|Ready|NotReady)"
    kubectl --context=$context get pods -A | grep -v Running | wc -l
done

# Диагностика сети
echo -e "\n2. Диагностика сети:"
kubectl --context=eks-us-east-1 get submariner
kubectl --context=eks-us-east-1 exec test-pod -- nslookup kubernetes.default

# Диагностика хранилища
echo -e "\n3. Диагностика хранилища:"
kubectl --context=eks-us-east-1 get pv,pvc -A
df -h | grep -E "(kubelet|/var/lib)"

# Диагностика безопасности
echo -e "\n4. Диагностика безопасности:"
kubectl --context=eks-us-east-1 get certificates -A
kubectl --context=eks-us-east-1 get networkpolicies -A

# Диагностика мониторинга
echo -e "\n5. Диагностика мониторинга:"
kubectl --context=eks-us-east-1 get pods -n monitoring
kubectl --context=eks-us-east-1 exec deployment/kube-prometheus-prometheus -n monitoring -- \
    wget -qO- http://localhost:9090/-/healthy

echo -e "\n=== Диагностика завершена ==="
```

### Скрипт анализа производительности

```bash
#!/bin/bash
# performance-analysis.sh

echo "=== Анализ производительности ==="
echo "$(date)"

# Анализ CPU
echo -e "\n1. Анализ CPU:"
kubectl top nodes --sort-by=cpu | head -10

# Анализ памяти
echo -e "\n2. Анализ памяти:"
kubectl top pods -A --sort-by=memory | head -10

# Анализ сети
echo -e "\n3. Анализ сети:"
kubectl exec cilium-pod -- cilium metrics list | grep -E "(drop|forward)"

# Анализ хранилища
echo -e "\n4. Анализ хранилища:"
kubectl exec deployment/storage-exporter -- df -h | grep -v "tmpfs"

# Анализ базы данных
echo -e "\n5. Анализ базы данных:"
kubectl exec postgresql-client -- psql $DATABASE_URL -c "
SELECT datname, numbackends, xact_commit, xact_rollback,
       blks_read, blks_hit, tup_returned, tup_fetched
FROM pg_stat_database WHERE datname != 'template0';"

echo -e "\n=== Анализ завершен ==="
```

## Процедуры восстановления

### Восстановление после сбоя кластера

```bash
#!/bin/bash
# cluster-recovery.sh

CLUSTER_NAME=$1
RECOVERY_TYPE=${2:-full}

echo "Восстановление кластера: $CLUSTER_NAME"

case $RECOVERY_TYPE in
    "full")
        # Полное восстановление из backup
        kubectl config use-context $CLUSTER_NAME

        # Восстановление из Velero
        velero restore create --from-backup daily-backup-$(date +%Y-%m-%d)

        # Ожидание завершения восстановления
        kubectl wait --for=condition=Available --timeout=600s deployment --all -A

        # Валидация восстановления
        kubectl get deployments -A
        kubectl get pods -A
        ;;

    "partial")
        # Частичное восстановление конкретных namespace
        NAMESPACES=("x0tta6bl4-system" "x0tta6bl4-quantum")

        for ns in "${NAMESPACES[@]}"; do
            velero restore create --from-backup daily-backup-$(date +%Y-%m-%d) \
                --include-namespaces $ns
        done
        ;;

    "application")
        # Восстановление только приложений
        kubectl rollout restart deployment --all -A
        kubectl rollout status deployment --all -A
        ;;
esac

echo "Восстановление кластера $CLUSTER_NAME завершено"
```

### Восстановление данных

```bash
#!/bin/bash
# data-recovery.sh

RECOVERY_TYPE=$1
SOURCE_CLUSTER=${2:-eks-us-east-1}
TARGET_CLUSTER=${3:-k3s-moscow}

echo "Восстановление данных: $RECOVERY_TYPE"

case $RECOVERY_TYPE in
    "database")
        # Восстановление базы данных
        # Создание snapshot Aurora
        aws rds create-db-cluster-snapshot \
            --db-cluster-snapshot-identifier x0tta6bl4-recovery-$(date +%Y%m%d-%H%M%S) \
            --db-cluster-identifier x0tta6bl4-aurora \
            --region us-east-1

        # Восстановление кластера из snapshot
        aws rds restore-db-cluster-from-snapshot \
            --db-cluster-identifier x0tta6bl4-recovered \
            --snapshot-identifier x0tta6bl4-recovery-$(date +%Y%m%d-%H%M%M%S) \
            --engine aurora-postgresql \
            --region us-east-1
        ;;

    "volumes")
        # Восстановление persistent volumes
        velero restore create --from-backup daily-backup-$(date +%Y-%m-%d) \
            --include-resources persistentvolumeclaims,persistentvolumes

        # Ожидание монтирования volumes
        kubectl wait --for=condition=Bound pvc --all -A --timeout=300s
        ;;

    "secrets")
        # Восстановление секретов из Vault
        kubectl exec vault-0 -n vault -- vault operator unseal
        kubectl exec vault-0 -n vault -- vault kv get secret/x0tta6bl4/backup
        ;;
esac

echo "Восстановление данных завершено"
```

## Анализ инцидентов

### Шаблон пост-мортем анализа

```markdown
# Пост-мортем анализ инцидента

## Информация об инциденте

- **Дата**: YYYY-MM-DD HH:MM:SS
- **Уровень**: P0/P1/P2
- **Сервисы**: Список затронутых сервисов
- **Регионы**: Список затронутых регионов
- **Пользователи**: Количество затронутых пользователей

## Хронология событий

- **T0**: Время обнаружения проблемы
- **T0 + 5мин**: Время реакции команды
- **T0 + 15мин**: Время начала диагностики
- **T0 + 1ч**: Время решения проблемы

## Корневая причина

Описание корневой причины проблемы с техническими деталями.

## Действия по устранению

Шаги, предпринятые для решения проблемы.

## Профилактические меры

Изменения в системе для предотвращения подобных инцидентов:

1. Изменение в мониторинге
2. Изменение в конфигурации
3. Изменение в процедурах
4. Изменение в документации

## Ответственные

- **Инцидент менеджер**: Имя
- **Технический лид**: Имя
- **Команда разработки**: Команда

## Уроки learned

Ключевые выводы из инцидента.
```

### Инструменты анализа

```bash
#!/bin/bash
# incident-analysis.sh

INCIDENT_ID=$1
START_TIME=$2
END_TIME=$3

echo "Анализ инцидента: $INCIDENT_ID"
echo "Период: $START_TIME - $END_TIME"

# Сбор метрик за период инцидента
curl -s "http://prometheus:9090/api/v1/query_range" \
    -G -d "query=up" \
    -d "start=$START_TIME" \
    -d "end=$END_TIME" \
    -d "step=60s" > incident-metrics-$INCIDENT_ID.json

# Сбор логов за период
kubectl logs --since-time=$START_TIME --until-time=$END_TIME \
    -l app=api-gateway > incident-logs-$INCIDENT_ID.log

# Анализ событий кластера
kubectl get events --since-time=$START_TIME --until-time=$END_TIME \
    -o yaml > incident-events-$INCIDENT_ID.yaml

echo "Данные инцидента собраны в файлы incident-*-$INCIDENT_ID.*"
```

## Контакты для экстренной помощи

### Внутренняя команда
- **Дежурный инженер**: +7 (495) XXX-XX-XX
- **Старший инженер**: +7 (495) XXX-XX-XX
- **DevOps команда**: #devops-emergency (Slack)

### Внешние сервисы
- **AWS Support**: https://support.aws.amazon.com
- **Cloudflare Support**: https://support.cloudflare.com
- **Grafana Support**: https://grafana.com/contact

### Процедура эскалации
1. Самостоятельная диагностика (15 мин)
2. Консультация с коллегой (15 мин)
3. Эскалация старшему инженеру (30 мин)
4. Эскалация внешней поддержке (при необходимости)

Этот документ обновляется при обнаружении новых типов проблем и их решений. Последнее обновление: 2025-09-30.