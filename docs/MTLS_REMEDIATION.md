# mTLS Remediation Plan (Draft)

## 1. Objective
Устранить нестабильность взаимного TLS (mTLS): AppArmor denials, просроченные сертификаты, незавершённые handshake.

## 2. Current Symptoms
| Symptom | Possible Cause | Artifact Needed |
|---------|----------------|-----------------|
| Handshake failures | Expired / mismatched CN/SAN | Сертификат инвентарь |
| AppArmor denials | Недостаточные разрешения процессов (network, file read) | Логи /var/log/kern.log, auditd |
| Intermittent channel resets | Авто-ротация без graceful reload | systemd unit logs |
| Long reconnect delay | Backoff слишком большой | mesh retry config |

## 3. Inventory Checklist
- [ ] Список всех сертификатов (путь, CN, SAN, expiry, issuer)
- [ ] CA bundle hash и версия
- [ ] Диапазоны портов использующие TLS
- [ ] Процессы (binary path) участвующие в handshake

## 4. Certificate Expiry Policy
| Item | Rule |
|------|------|
| Leaf cert lifetime | ≤ 90 дней |
| Rotation window | T - 14 дней |
| Grace overlap | 24 часа двойной валидности |
| Alert threshold | 21 дней до expiry |

## 5. AppArmor / SecProfile Adjustments (Planned)
| Capability | Needed For | Status |
|------------|-----------|--------|
| network bind/connect | TLS listener/client | VERIFY |
| file read (cert paths) | Loading cert/key | VERIFY |
| ptrace denied | Not required | OK |
| sys_resource | Large FD limits | MAYBE |

> TODO: собрать фактические строки denials и классифицировать.

## 6. Remediation Steps
1. Запустить `scripts/mtls_audit.py --cert-dir <path>` → сформировать JSON инвентаря.
2. Сгенерировать отчёт по expiry (< 30 дней) → список на ротацию.
3. Собрать AppArmor denials: `grep DENIED /var/log/kern.log` → кластеризация.
4. Обновить профиль: разрешить чтение каталогов с ключами + network connect.
5. Внедрить graceful reload: SIGHUP или systemd `reload` вместо `restart`.
6. Smoke-test: 3 узла → 50 последовательных mTLS handshake (скрипт).
7. Мониторинг: метрика `mtls_handshake_success_ratio` ≥ 0.999 за 24ч.

## 7. Testing Plan
| Test | Method | Pass Criteria |
|------|--------|---------------|
| Expiry detection | audit script | Все истекающие < 21д отмечены |
| Denial removal | before/after diff | 0 новых DENIED записей за 1ч |
| Handshake storm | loop script | 0 failed out of 50 |
| Rotation rollover | deploy new cert | >95% handshake succeed during overlap |

## 8. Metrics (to add to Prometheus)
| Metric | Type | Description |
|--------|------|-------------|
| mtls_handshake_success_ratio | Gauge | Успешные / total в окне |
| mtls_cert_days_remaining | Gauge | Дни до expiry (per cert) |
| mtls_rotation_events_total | Counter | События ротации |
| mtls_app_armor_denials_total | Counter | Количество denials за период |

## 9. Open Questions
- Где хранится корневой CA? (путь)
- Есть ли hot-reload hook в mesh core?
- Нужно ли поддерживать разные trust domains?

## 10. Ownership & Timeline
| Task | Owner | Target |
|------|-------|--------|
| Audit script run | Ops | Day 1 |
| Denials classification | Sec | Day 1 |
| Profile patch | Sec | Day 2 |
| Cert rotation dry-run | Ops | Day 2 |
| Smoke test | QA | Day 3 |

---
*File: MTLS_REMEDIATION.md*