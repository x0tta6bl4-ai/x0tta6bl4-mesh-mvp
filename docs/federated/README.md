# Federated Chaos Visualization — x0tta6bl4

## Описание

Глобальная mesh-сеть dashboard-узлов для коллективной визуализации красоты и хаоса. Каждый узел — самостоятельный dashboard, синхронизирующий события красоты через P2P WebSocket и gossip-протокол.

## Основные компоненты
- P2P WebSocket mesh (src/federated/p2p/mesh_node.py)
- Gossip-протокол распространения событий (src/federated/gossip/protocol.py)
- Глобальная карта красоты (src/federated/visualization/global_map.py)
- Mesh-identity и безопасность (src/federated/security/identity.py)
- Тесты федерации (tests/federated/test_p2p_mesh.py)

## Архитектура
- Каждый dashboard — mesh-узел
- События красоты распространяются по сети
- Глобальная карта и heatmap отображают коллективную красоту

## Запуск и тестирование
- Запуск узла: см. BeautyMeshNode.start()
- Тесты: pytest tests/federated/

## Переменные окружения
| Env | Назначение | Значение по умолчанию |
|-----|------------|-----------------------|
| FEDERATED_ENABLE | Включить федеративный режим | 0 |
| FEDERATED_NODE_ID | Идентификатор узла | auto генерируется |
| FEDERATED_PORT | Порт P2P WebSocket узла | 8091 |
| FEDERATED_PEERS | Список bootstrap peers (через запятую) | '' |

## Federated Endpoints (при включенном режиме)
| Method | Path | Описание |
|--------|------|---------|
| GET | /federated/health | Состояние локального federated узла + метрики |
| GET | /federated/network | Список текущих peers |
| GET | /federated/heatmap | Агрегированные временные buckets красоты |
| GET | /federated/gossip/summary | Статистика gossip (seen, propagated, total) |
| GET | /federated/map | HTML-визуализация федеративной карты узла (peers, метрики, heatmap) |

Пример включения:
```bash
export FEDERATED_ENABLE=1
export FEDERATED_PEERS="ws://peer1:8091,ws://peer2:8091"
uvicorn src.dashboard.app:app --host 0.0.0.0 --port 8080
```

### Federated Map UI
Endpoint `/federated/map` отображает интерактивный HTML-dashboard с:
- **Метриками узла:** `beauty_avg`, `beauty_min`, `beauty_max`, `gossip_seen`, `gossip_propagated`.
- **Список peers:** все подключенные узлы.
- **Heatmap:** визуализация временной динамики средних значений красоты (последние 40 buckets).
- **Raw JSON:** отладочная информация в JSON-формате.

**Авто-обновление:** страница перезагружается каждые 10 секунд для отображения актуального состояния.

#### Пример использования:
```bash
# После запуска с FEDERATED_ENABLE=1:
curl http://localhost:8080/federated/map
# Откроется HTML-страница с глобальной картой красоты
```

#### Скриншот
*(Добавь скриншот сюда после развертывания в production)*

## Дальнейшее развитие
- Расширение протокола gossip
	- TTL распространения по mesh
	- Подпись сообщений (HMAC / PQC)
	- Сжатие пакетов событий
- Визуализация глобальных трендов
- Безопасность и mesh-auth
- Docker-оркестрация для multi-node

## Gossip-протокол (текущая версия)
Принцип работы:
1. Локальное событие вызывает `ingest_local_beauty()` → добавляется в буфер, инициируется `gossip_beauty_event()`.
2. Gossip выбирает до 3 случайных peers и отправляет пакет `{type=gossip, subtype=beauty_event, ttl=10}`.
3. Узел-получатель проверяет `event_id` против `seen_events`. Если новое — принимает, добавляет, уменьшает `ttl` и форвардит дальше.
4. Метрики: `gossip_seen`, `gossip_propagated` доступны через `/federated/health` и агрегированы в `/federated/gossip/summary`.

Ограничения MVP:
- Нет криптографической подписи сообщений.
- Нет восстановления после потери соединений.
- Нет адаптивного fanout (фиксировано 3).

План улучшений:
- Добавить доказуемую целостность (Ed25519 / PQ схемы).
- Градиентный fanout по уровню активности узлов.
- Периодическая resend-таблица для узлов с задержкой.
