# Полное развертывание системы x0tta6bl4

## Обзор

Этот runbook описывает процедуру полного развертывания гибридной инфраструктуры x0tta6bl4, включая облачные кластеры EKS, локальные кластеры K3s, системы мониторинга, безопасности и всех компонентов приложения.

## Требования

### Доступы
- AWS CLI настроен с правами администратора
- SSH доступ к локальным серверам
- kubectl настроен для всех кластеров
- Доступ к Docker registry
- Доступ к Vault для секретов

### Инструменты
- terraform >= 1.0
- ansible >= 2.10
- kubectl >= 1.28
- helm >= 3.10
- aws-cli >= 2.0
- git

### Предварительные условия
- DNS зоны настроены (x0tta6bl4.com)
- SSL сертификаты получены
- Сервера подготовлены для K3s
- Terraform state доступен

## Шаги выполнения

### Шаг 1: Подготовка окружения (15 минут)

```bash
#!/bin/bash
# setup-environment.sh

echo "=== Подготовка окружения развертывания ==="

# Проверка инструментов
command -v terraform >/dev/null 2>&1 || { echo "Terraform не установлен"; exit 1; }
command -v ansible >/dev/null 2>&1 || { echo "Ansible не установлен"; exit 1; }
command -v kubectl >/dev/null 2>&1 || { echo "kubectl не установлен"; exit 1; }
command -v helm >/dev/null 2>&1 || { echo "Helm не установлен"; exit 1; }
command -v aws >/dev/null 2>&1 || { echo "AWS CLI не установлен"; exit 1; }

# Настройка AWS профиля
export AWS_PROFILE=x0tta6bl4-prod

# Проверка аутентификации AWS
aws sts get-caller-identity

# Создание директорий для логов
mkdir -p logs/
mkdir -p backups/pre-deployment/

echo "Окружение готово к развертыванию"
```

### Шаг 2: Резервное копирование текущего состояния (10 минут)

```bash
#!/bin/bash
# pre-deployment-backup.sh

echo "=== Создание резервных копий ==="

# Бэкап текущих конфигураций кластеров
for context in eks-us-east-1 eks-eu-west-1 eks-ap-southeast-1 k3s-moscow k3s-spb; do
    echo "Бэкап кластера: $context"
    kubectl --context=$context get all,ingress,networkpolicy,pvc,pv,secrets -A -o yaml > backups/pre-deployment/$context-$(date +%Y%m%d-%H%M%S).yaml
done

# Бэкап Terraform state
cp terraform.tfstate backups/pre-deployment/terraform-state-$(date +%Y%m%d-%H%M%S).backup

# Бэкап секретов из Vault
kubectl exec vault-0 -n vault -- vault kv get -format=json secret/x0tta6bl4 > backups/pre-deployment/vault-secrets-$(date +%Y%m%d-%H%M%S).json

echo "Резервные копии созданы"
```

### Шаг 3: Развертывание инфраструктуры (30 минут)

#### 3.1 Развертывание облачной инфраструктуры

```bash
#!/bin/bash
# deploy-cloud-infrastructure.sh

echo "=== Развертывание облачной инфраструктуры ==="

# Инициализация Terraform
cd terraform/
terraform init
terraform plan -out=tfplan

# Применение инфраструктуры
terraform apply tfplan

# Получение outputs
terraform output -json > ../terraform-outputs.json

echo "Облачная инфраструктура развернута"
```

#### 3.2 Настройка локальных серверов

```bash
#!/bin/bash
# setup-onprem-servers.sh

echo "=== Настройка локальных серверов ==="

# Выполнение Ansible playbook для подготовки серверов
ansible-playbook -i inventory.ini playbooks/setup-servers.yml

# Установка K3s на master узлы
for master in k3s-master-1.moscow.x0tta6bl4.local k3s-master-1.spb.x0tta6bl4.local; do
    echo "Установка K3s на $master"
    ssh root@$master "curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.28.0+k3s1 sh -s - server --cluster-init"
done

# Установка K3s на worker узлы
for worker in k3s-worker-{1,2,3}.moscow.x0tta6bl4.local k3s-worker-{1,2,3}.spb.x0tta6bl4.local; do
    echo "Установка K3s на $worker"
    ssh root@$worker "curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.28.0+k3s1 sh -s - server --server https://k3s-master-1.moscow.x0tta6bl4.local:6443"
done

echo "Локальные серверы настроены"
```

### Шаг 4: Развертывание базовых сервисов (20 минут)

#### 4.1 Развертывание систем мониторинга

```bash
#!/bin/bash
# deploy-monitoring.sh

echo "=== Развертывание систем мониторинга ==="

# Создание namespace мониторинга
kubectl --context=eks-us-east-1 apply -f k8s/monitoring/namespace.yaml

# Установка Prometheus Operator
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install kube-prometheus prometheus-community/kube-prometheus-stack \
    -f k8s/monitoring/prometheus-values.yaml \
    --namespace monitoring

# Ожидание готовности мониторинга
kubectl --context=eks-us-east-1 wait --for=condition=available --timeout=300s deployment --all -n monitoring

echo "Системы мониторинга развернуты"
```

#### 4.2 Развертывание систем безопасности

```bash
#!/bin/bash
# deploy-security.sh

echo "=== Развертывание систем безопасности ==="

# Создание namespace для безопасности
kubectl --context=eks-us-east-1 apply -f k8s/security/namespace.yaml

# Установка Vault
helm repo add hashicorp https://helm.releases.hashicorp.com
helm install vault hashicorp/vault \
    -f k8s/security/vault-values.yaml \
    --namespace vault

# Инициализация и настройка Vault
kubectl --context=eks-us-east-1 exec vault-0 -n vault -- vault operator init -format=json > vault-keys.json
kubectl --context=eks-us-east-1 exec vault-0 -n vault -- vault operator unseal $(jq -r '.unseal_keys_b64[0]' vault-keys.json)

# Настройка аутентификации Kubernetes
kubectl --context=eks-us-east-1 exec vault-0 -n vault -- vault auth enable kubernetes
kubectl --context=eks-us-east-1 exec vault-0 -n vault -- vault write auth/kubernetes/config \
    kubernetes_host="https://kubernetes.default.svc.cluster.local:443" \
    kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt

# Установка SPIRE
helm repo add spire https://spire-project.github.io/helm-charts
helm install spire spire/spire \
    -f k8s/security/spire-values.yaml \
    --namespace spire-system

echo "Системы безопасности развернуты"
```

### Шаг 5: Развертывание приложений (25 минут)

#### 5.1 Развертывание в облаке (EKS)

```bash
#!/bin/bash
# deploy-cloud-applications.sh

echo "=== Развертывание приложений в облаке ==="

# Развертывание API Gateway
kubectl --context=eks-us-east-1 apply -f k8s/cloud/api-gateway/
kubectl --context=eks-eu-west-1 apply -f k8s/cloud/api-gateway/
kubectl --context=eks-ap-southeast-1 apply -f k8s/cloud/api-gateway/

# Развертывание агентских сервисов
kubectl --context=eks-us-east-1 apply -f k8s/cloud/agents/
kubectl --context=eks-eu-west-1 apply -f k8s/cloud/agents/
kubectl --context=eks-ap-southeast-1 apply -f k8s/cloud/agents/

# Развертывание квантовых сервисов
kubectl --context=eks-us-east-1 apply -f k8s/cloud/quantum-services/
kubectl --context=eks-eu-west-1 apply -f k8s/cloud/quantum-services/
kubectl --context=eks-ap-southeast-1 apply -f k8s/cloud/quantum-services/

# Ожидание готовности приложений
kubectl --context=eks-us-east-1 wait --for=condition=available --timeout=600s deployment --all -n x0tta6bl4-system
kubectl --context=eks-us-east-1 wait --for=condition=available --timeout=600s deployment --all -n x0tta6bl4-quantum

echo "Приложения в облаке развернуты"
```

#### 5.2 Развертывание локальных сервисов (K3s)

```bash
#!/bin/bash
# deploy-local-applications.sh

echo "=== Развертывание локальных приложений ==="

# Развертывание квантовых сервисов в Москве
kubectl --context=k3s-moscow apply -f k8s/local/quantum-services-moscow/
kubectl --context=k3s-moscow apply -f k8s/local/agents-moscow/

# Развертывание квантовых сервисов в СПб
kubectl --context=k3s-spb apply -f k8s/local/quantum-services-spb/
kubectl --context=k3s-spb apply -f k8s/local/agents-spb/

# Ожидание готовности локальных приложений
kubectl --context=k3s-moscow wait --for=condition=available --timeout=600s deployment --all -n x0tta6bl4-quantum
kubectl --context=k3s-spb wait --for=condition=available --timeout=600s deployment --all -n x0tta6bl4-quantum

echo "Локальные приложения развернуты"
```

### Шаг 6: Настройка сетевого взаимодействия (15 минут)

#### 6.1 Настройка Submariner

```bash
#!/bin/bash
# setup-submariner.sh

echo "=== Настройка Submariner ==="

# Установка Submariner Operator в облачные кластеры
for region in us-east-1 eu-west-1 ap-southeast-1; do
    echo "Установка Submariner в регион $region"
    kubectl --context=eks-${region} apply -f submariner-operator.yaml

    # Ожидание готовности operator
    kubectl --context=eks-${region} wait --for=condition=available --timeout=300s deployment/submariner-operator -n submariner-operator

    # Присоединение к брокеру
    submariner join --clusterid "eks-${region}" --repository "${DOCKER_REGISTRY}" --version "0.16.0"
done

# Установка Submariner в локальные кластеры
for cluster in moscow spb; do
    echo "Установка Submariner в кластер $cluster"
    kubectl --context=k3s-${cluster} apply -f submariner-operator.yaml

    # Присоединение к брокеру
    submariner join --clusterid "k3s-${cluster}" --repository "${DOCKER_REGISTRY}" --version "0.16.0"
done

# Проверка статуса Submariner
kubectl --context=eks-us-east-1 get submariner

echo "Submariner настроен"
```

#### 6.2 Настройка KubeFed

```bash
#!/bin/bash
# setup-kubefed.sh

echo "=== Настройка KubeFed ==="

# Установка KubeFed в выделенный кластер
kubectl --context=kubefed-admin@kubefed-cluster apply -f kubefed-namespace.yaml

helm install kubefed kubefed-charts/kubefed \
    --namespace kube-federation-system \
    --set global.scope=Namespaced

# Присоединение кластеров к федерации
for context in eks-us-east-1 eks-eu-west-1 eks-ap-southeast-1 k3s-moscow k3s-spb; do
    kubefedctl join ${context} \
        --cluster-context ${context} \
        --host-cluster-context kubefed-admin@kubefed-cluster
done

echo "KubeFed настроен"
```

### Шаг 7: Валидация развертывания (20 минут)

#### 7.1 Проверка работоспособности кластеров

```bash
#!/bin/bash
# validate-clusters.sh

echo "=== Валидация кластеров ==="

CLUSTERS=("eks-us-east-1" "eks-eu-west-1" "eks-ap-southeast-1" "k3s-moscow" "k3s-spb")

for cluster in "${CLUSTERS[@]}"; do
    echo "Проверка кластера: ${cluster}"

    kubectl --context=${cluster} get nodes
    kubectl --context=${cluster} get pods -A --field-selector=status.phase!=Running
    kubectl --context=${cluster} get services
    kubectl --context=${cluster} get ingress

    echo "---"
done

echo "Валидация кластеров завершена"
```

#### 7.2 Тестирование сетевого взаимодействия

```bash
#!/bin/bash
# test-networking.sh

echo "=== Тестирование сетевого взаимодействия ==="

# Тестирование межкластерного взаимодействия
for source in eks-us-east-1 k3s-moscow; do
    for target in eks-eu-west-1 eks-ap-southeast-1 k3s-spb; do
        if [ "${source}" != "${target}" ]; then
            echo "Тестирование соединения ${source} -> ${target}"

            kubectl --context=${source} run test-pod-${source} \
                --image=curlimages/curl \
                --restart=Never \
                --command -- sleep 300

            # Тестирование доступа к сервису в целевом кластере
            kubectl --context=${source} exec test-pod-${source} -- curl -m 10 \
                http://test-service.${target}.svc.clusterset.local/health

            kubectl --context=${source} delete pod test-pod-${source}
        fi
    done
done

echo "Тестирование сети завершено"
```

#### 7.3 Тестирование приложений

```bash
#!/bin/bash
# test-applications.sh

echo "=== Тестирование приложений ==="

# Тестирование API Gateway
echo "Тестирование API Gateway..."
curl -f https://api.x0tta6bl4.com/health || exit 1

# Тестирование квантовых сервисов
echo "Тестирование квантовых сервисов..."
kubectl --context=eks-us-east-1 exec deployment/quantum-services -- \
    curl -f http://localhost:8301/health || exit 1

# Тестирование агентских сервисов
echo "Тестирование агентских сервисов..."
kubectl --context=eks-us-east-1 exec deployment/agents -- \
    curl -f http://localhost:8201/health || exit 1

# Тестирование мониторинга
echo "Тестирование мониторинга..."
curl -f https://grafana.x0tta6bl4.com/api/health || exit 1

echo "Тестирование приложений завершено"
```

## Валидация

### Критерии успешного развертывания

1. **Кластеры**: Все узлы в Ready состоянии
2. **Приложения**: Все deployment в Available состоянии
3. **Сеть**: Submariner показывает Connected статус
4. **Безопасность**: Vault инициализирован и разблокирован
5. **Мониторинг**: Prometheus собирает метрики, Grafana доступна
6. **Приложения**: Все health check endpoints отвечают 200 OK

### Метрики успеха

- Время развертывания: < 2 часов
- Доступность системы после развертывания: > 99.9%
- Количество критических алертов: 0
- Успешность всех тестов: 100%

## Откат

### Процедура отката при проблемах

```bash
#!/bin/bash
# rollback-deployment.sh

echo "=== Откат развертывания ==="

# Восстановление из резервных копий
for context in eks-us-east-1 eks-eu-west-1 eks-ap-southeast-1 k3s-moscow k3s-spb; do
    echo "Восстановление кластера: $context"

    # Удаление неудачных ресурсов
    kubectl --context=$context delete -f k8s/ --ignore-not-found=true

    # Восстановление из backup
    kubectl --context=$context apply -f backups/pre-deployment/$context-backup.yaml
done

# Восстановление Terraform state
cd terraform/
terraform state replace -state=terraform.tfstate backups/pre-deployment/terraform-state.backup

echo "Откат завершен"
```

## Время выполнения

- **Подготовка**: 15 минут
- **Резервное копирование**: 10 минут
- **Инфраструктура**: 30 минут
- **Базовые сервисы**: 20 минут
- **Приложения**: 25 минут
- **Сетевое взаимодействие**: 15 минут
- **Валидация**: 20 минут

**Общее время**: ~2 часа 15 минут

## Риски

### Высокий риск
- **Потеря данных**: Минимизируется резервным копированием
- **Простой сервисов**: Минимизируется blue-green развертыванием

### Средний риск
- **Проблемы сети**: Минимизируется тестированием
- **Проблемы безопасности**: Минимизируется валидацией политик

### Низкий риск
- **Проблемы ресурсов**: Минимизируется мониторингом использования

## Ответственный

- **DevOps инженер**: Выполняет развертывание
- **Технический лид**: Одобряет развертывание
- **Команда разработки**: Предоставляет артефакты

## Частота

- Полное развертывание: При создании новой инфраструктуры
- Частичное развертывание: При обновлении компонентов

## Пост-действия

1. **Документирование**: Зафиксировать результаты развертывания
2. **Обучение**: Обучить команду эксплуатации новым компонентам
3. **Мониторинг**: Установить повышенный мониторинг на 24 часа
4. **Отчет**: Подготовить отчет о развертывании для руководства

Последнее обновление: 2025-09-30