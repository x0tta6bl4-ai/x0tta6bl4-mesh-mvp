# ISSUE: P0 PQC Adapter Implementation (Kyber + Dilithium)

ID: P0-1
Priority: CRITICAL
Status: OPEN
Owner: Quantum Team Lead
Estimate: 20-30h

## Problem
`pqc_adapter.py` содержит заглушки (NotImplemented) для Kyber KEM и Dilithium signature. Без реализации система не соответствует требованиям постквантовой стойкости.

## Scope
- Kyber: keypair(), encapsulate(public_key) -> (ciphertext, shared_secret), decapsulate(ciphertext, secret_key) -> shared_secret
- Dilithium: keypair(), sign(message, secret_key) -> signature, verify(message, signature, public_key) -> bool
- Hybrid: комбинированная подпись (Ed25519 + Dilithium) и двоичный формат (length-prefix)

## Deliverables
1. `pqc_adapter.py` с рабочими методами (вначале mock, затем реализация через внешнюю библиотеку / binding при доступности)
2. Unit tests (round-trip Kyber, sign/verify Dilithium, hybrid bundle)
3. Performance log (время генерации ключей, операции sign/verify, размер ключей)
4. Документ `PQC_README.md` с описанием форматов и ограничений

## Acceptance Criteria
| Criterion | Target |
|-----------|--------|
| Kyber round-trip | 100% success (50 тестов) |
| Dilithium verify | 100% success (50 тестов) |
| Hybrid bundle verify | 100% success |
| Test coverage (module) | >=90% |
| No blocking exceptions | 0 |

## Steps
1. Создать интерфейс классов (KyberKEM, DilithiumSigner, HybridSignature)
2. Реализовать mock алгоритмы (sha256 для shared_secret, ed25519 для базовой части)
3. Добавить флаг USE_MOCK для переключения
4. Подготовить структуру тестов (`tests/test_pqc_adapter.py`)
5. Интегрировать с policy engine (при необходимости для future risk scoring)
6. Добавить metrics hooks (latency, key sizes)
7. Заменить mock реализацию реальными вызовами (liboqs или аналог) при доступности

## Risks & Mitigation
| Risk | Mitigation |
|------|------------|
| Отсутствие liboqs | Использовать mock и подписать технический долг |
| Высокая задержка Dilithium | Кеш ключей для частых операций |
| Неоднородный формат | Единый binary framing c length-prefix |

## Test Matrix (Initial)
| Test | Description |
|------|-------------|
| KyberKeypair | keypair не возвращает исключений |
| KyberEncapDecap | shared_secret совпадает |
| DilithiumSignVerify | verify=True для корректной подписи |
| DilithiumNegative | verify=False при модификации байта |
| HybridBundle | bundling + разбор работает |
| HybridNegative | повреждённый префикс → ошибка |

## Timeline
Week 1: Mock + tests
Week 2: Реальная интеграция / оптимизация

---
Generated 2025-11-03.