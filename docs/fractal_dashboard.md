# Fractal Beauty Dashboard — Minimal Contract

Status: APPROVED
Scope: MVP visualization layer for chaos beauty events

## 1. Goals
- Provide real-time visibility into beauty_score dynamics.
- Offer a minimal, low-latency ingestion + streaming path.
- Expose Prometheus-compatible metrics.
- Generate a simple fractal (ASCII + PNG base64) derived from rolling beauty average.

## 2. Non-Goals (MVP)
- No persistence beyond in-memory ring buffer.
- No auth beyond shared bearer token for POST /event.
- No historical querying beyond last 500 events.
- No complex chart rendering server-side.

## 3. Data Model (Event)
```json
{
  "event_id": "evt_123",
  "timestamp": "2025-10-21T04:30:00Z",
  "beauty_score": 0.92,
  "chaos_fingerprint": "ab12cd34",
  "dance_sequence": "shimmer→dissolve→diverge",
  "wisdom": "Trust the process"
}
```
Constraints:
- beauty_score: 0.0–1.5 (allow slight >1 overflow for exceptional beauty)
- chaos_fingerprint: <= 32 chars
- dance_sequence: <= 64 chars
- wisdom: <= 200 chars

## 4. Architecture Overview
```
           +------------------+
POST /event|  FastAPI App     |  WS /stream --> Browsers
  -------> |  Ring Buffer     |  GET /snapshot
           |  Fractal Gen     |  GET /fractal (ascii + png)
           |  Metrics (/metrics) <- Prometheus scrape
           +------------------+
```

## 5. Endpoints
| Method | Path       | Description | Auth |
|--------|------------|-------------|------|
| GET    | /health    | Liveness    | None |
| POST   | /event     | Ingest event| Bearer token (DASHBOARD_TOKEN) |
| GET    | /snapshot  | Last N events (default 50)| None |
| GET    | /fractal   | Fractal ASCII + PNG | None |
| WS     | /stream    | Real-time events + heartbeats | None |
| GET    | /metrics   | Prometheus metrics | None |

## 6. Ring Buffer
- Deque maxlen=500.
- O(1) append/rotate.
- Async lock for concurrency (single-process assumption).

## 7. Fractal Generation
- Rolling beauty_avg over last 50 events.
- ASCII density mapping.
- PNG Mandelbrot variant (numpy + Pillow only).
- Detail depth scales with beauty_avg.

## 8. Metrics (Prometheus)
- chaos_beauty_events_total (counter)
- chaos_beauty_score_avg (gauge)
- chaos_beauty_score_min (gauge)
- chaos_beauty_score_max (gauge)
- chaos_beauty_score_distribution (histogram)

## 9. WebSocket Protocol
Messages:
- Event broadcast: full JSON event.
- Heartbeat: {"type":"heartbeat","ts":"ISO"}
Interval: 10s heartbeat.

## 10. Configuration
| Env Var | Purpose | Default |
|---------|---------|---------|
| DASHBOARD_TOKEN | Auth token for POST /event | (required) |
| DASHBOARD_MAX_EVENTS | Ring buffer size | 500 |
| DASHBOARD_PORT | HTTP port | 8080 |
| DASHBOARD_ROLLING_WINDOW | beauty_avg window | 50 |

## 11. Error Handling
- 400: Validation error (Pydantic).
- 401: Missing/invalid token on POST /event.
- 500: Unexpected internal error (logged).

## 12. Logging
- Ingest success: INFO with event_id + beauty_score.
- Fractal request: DEBUG with rolling beauty_avg.
- WebSocket connect/disconnect: INFO.

## 13. Testing Strategy
- Unit: ring buffer, fractal generator edge cases.
- Integration (pytest + httpx + websockets):
  - POST /event then GET /snapshot contains event.
  - /fractal returns base64 png string & ascii.
  - WS receives broadcast for posted event.
  - /metrics exposes counters after events.

## 14. Future Extensions (Out of Scope Now)
- Persistent store (SQLite / Redis).
- Multi-node federation + gossip propagation.
- Client-side richer visualization (charts, animations).
- DAO-based weighting of beauty influence.
- Alerting on beauty anomaly spikes.

## 15. Security Considerations
- Shared secret token; rotate via env reload.
- No PII stored; events ephemeral.
- Rate limiting (future) if external exposure.

-- END OF SPEC --
