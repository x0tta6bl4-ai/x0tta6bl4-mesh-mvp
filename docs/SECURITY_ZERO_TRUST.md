# Zero Trust Integration (Draft)

## 1. Objective
Интегрировать Zero Trust принципы в mesh: каждый запрос подтверждается, минимальные привилегии, непрерывная проверка доверия.

## 2. Pipeline Overview
```
Request → Identity Assertion → Context Collection → Policy Evaluation → Enforcement → Telemetry/Audit
```

## 3. Identity Layer
| Component | Function | Notes |
|-----------|----------|-------|
| mTLS cert | Mutual peer identity | Связан с remediation планом |
| Service token (JWT/OIDC) | App-level identity | Rotation ≤ 15m |
| Workload attestation | Хэш бинаря / сигнатура контейнера | Optional phase |

## 4. Context Signals
| Signal | Source | Use |
|--------|--------|-----|
| Time window | System clock | Access window policies |
| Risk score | Anomaly engine | Adaptive decisions |
| Geo / region | Node tags | Geo fencing |
| TLS freshness | Handshake timestamp | Session renewal trigger |

## 5. Policy Engine
| Feature | Description | Status |
|---------|-------------|--------|
| Rule format | YAML/JSON: subject, action, resource, conditions | DESIGN |
| Evaluation order | Deny > Explicit allow > Default deny | AGREED |
| Adaptive override | Inject risk score threshold gating | TBD |
| Caching | Short TTL per subject-resource | TBD |

## 6. Enforcement Points
| Layer | Mechanism | Example |
|-------|-----------|---------|
| Network | Sidecar proxy (Envoy-like) | mTLS termination + authZ |
| Application | Middleware hook | Method-level checks |
| Data | Query filter | Row/document security |

## 7. Telemetry & Audit
| Item | Metric / Log | Retention |
|------|--------------|----------|
| Policy decisions | audit log (JSON lines) | 30d |
| Denies count | `zt_policy_denies_total` | Prometheus 30d |
| Latency eval | `zt_policy_eval_ms` | 30d |
| Token failures | `zt_token_validation_fail_total` | 30d |

## 8. Testing Matrix
| Case | Positive / Negative | Expected |
|------|---------------------|----------|
| Valid mTLS + valid token | Positive | 200 OK |
| Valid mTLS + expired token | Negative | 401 + audit entry |
| Invalid mTLS + valid token | Negative | 403 + audit entry |
| Elevated risk score | Negative | 403 adaptive deny |
| Policy missing subject | Negative | 403 default deny |

## 9. Implementation Phases
| Phase | Scope | Exit Criteria |
|-------|-------|---------------|
| 1 | mTLS + basic JWT validation | Stable handshake & token parsing |
| 2 | Static policy rules | CRUD allowed, others denied |
| 3 | Telemetry + audit logging | Metrics visible + audit rotation |
| 4 | Adaptive risk integration | Dynamic denies under threshold |
| 5 | Workload attestation (optional) | Integrity proof accepted |

## 10. Risks & Mitigation
| Risk | Impact | Mitigation |
|------|--------|-----------|
| Policy sprawl | Complexity | Rule grouping + lint tool |
| Latency overhead | Performance drop | Cache & fast path |
| Token leakage | Security breach | Short TTL + secure storage |
| Misconfigured deny | Outage | Safe default deny + dry-run mode |

## 11. Open Questions
- Выбор формата правил (Rego vs custom YAML)?
- Нужен ли multi-tenant разделение? (namespaces)
- Нужно ли SSO интеграция сразу или позже?

## 12. Artifacts (Created)
| File | Purpose | Status |
|------|---------|--------|
| `security/policy/examples/basic_allow_deny.yaml` | Базовые правила allow/deny | ADDED |
| `security/telemetry/metrics_spec.md` | Документация метрик | ADDED |
| `security/audit/audit_format.md` | Формат логов и поля | ADDED |
| `scripts/mtls_smoke_test.py` | Handshake стабильность (mTLS) | ADDED |

> Следующий шаг: интегрировать policy engine парсер и начать генерацию audit логов в JSON Lines по спецификации.

---
*File: SECURITY_ZERO_TRUST.md*