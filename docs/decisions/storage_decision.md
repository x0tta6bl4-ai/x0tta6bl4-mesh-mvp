# Storage Layer Decision Document

**Date**: 2025-11-05  
**Status**: DECISION MADE ✅  
**Decision**: **SQLite**

---

## Requirements Analysis

### Functional Requirements
1. **Persistence**: Store nodes, policies, path cache bundles
2. **CRUD Operations**: Create, Read, Update, Delete
3. **Transactions**: Atomic operations with rollback
4. **Query Performance**: Fast lookups by ID, indexed search
5. **Data Durability**: 100% persistence across restarts

### Non-Functional Requirements
1. **Zero External Dependencies**: No separate database server
2. **Easy Deployment**: Single-file database, portable
3. **Low Latency**: <1ms for typical operations
4. **Small Footprint**: Minimal memory usage
5. **ACID Compliance**: Transactional guarantees

---

## Options Evaluated

### Option 1: SQLite ✅ **SELECTED**

**Pros**:
- ✅ Zero external dependencies (built into Python)
- ✅ Single-file database (easy backup/restore)
- ✅ ACID compliant
- ✅ Fast for read-heavy workloads
- ✅ Mature, battle-tested
- ✅ Excellent Python integration (sqlite3)
- ✅ <1ms latency for indexed queries
- ✅ Supports concurrent reads

**Cons**:
- ⚠️ Write concurrency limited (single writer)
- ⚠️ Not ideal for >1000 writes/sec
- ⚠️ No built-in replication

**Verdict**: **PERFECT FIT** for our use case (read-heavy, moderate writes)

---

### Option 2: Redis

**Pros**:
- ✅ Very fast (in-memory)
- ✅ Built-in TTL support
- ✅ Pub/sub capabilities
- ✅ Good for caching

**Cons**:
- ❌ Requires external Redis server
- ❌ Persistence not default
- ❌ More complex deployment
- ❌ Overkill for our needs
- ❌ Additional network latency

**Verdict**: Too complex, requires external dependency

---

### Option 3: PostgreSQL

**Pros**:
- ✅ Excellent concurrency
- ✅ Advanced features (JSON, arrays, etc.)
- ✅ Replication support
- ✅ Scalable

**Cons**:
- ❌ Requires external PostgreSQL server
- ❌ Complex setup and maintenance
- ❌ Overkill for current scale
- ❌ Higher resource usage

**Verdict**: Too heavyweight for current requirements

---

## Decision: SQLite

### Rationale

1. **Simplicity**: Zero external dependencies, built into Python
2. **Deployment**: Single file, easy backup/restore
3. **Performance**: Sufficient for our scale (5000 nodes, moderate writes)
4. **Reliability**: ACID compliant, battle-tested
5. **Migration Path**: Can migrate to PostgreSQL later if needed

### Performance Expectations

| Operation | Expected Latency |
|-----------|-----------------|
| **Insert node** | <1ms |
| **Read node by ID** | <0.5ms |
| **Update policy** | <1ms |
| **Cache lookup** | <0.5ms |
| **Bulk read (100 nodes)** | <5ms |

### Migration Strategy

If SQLite becomes a bottleneck (unlikely at 5000 nodes):
1. Keep storage interface abstract
2. Implement PostgreSQL backend
3. Migration script: SQLite → PostgreSQL
4. Zero downtime migration possible

---

## Implementation Plan

### Phase 1: Core Storage Layer (Today)
- Create `storage_layer.py` with abstract interface
- Implement SQLite backend
- Schema: nodes, policies, path_cache tables

### Phase 2: Integration (Tomorrow)
- Migrate mesh_api.py to use storage
- Migrate pathfinder_orchestrator cache
- Add transaction support

### Phase 3: Testing (Tomorrow)
- Unit tests for CRUD operations
- Failure recovery tests
- Performance benchmarks

---

## Schema Design

### Table: nodes
```sql
CREATE TABLE nodes (
    node_id TEXT PRIMARY KEY,
    interfaces TEXT NOT NULL,  -- JSON array
    protocols TEXT NOT NULL,   -- JSON array
    started BOOLEAN DEFAULT 0,
    routes_discovered INTEGER DEFAULT 0,
    created_at REAL NOT NULL,
    updated_at REAL NOT NULL
);
CREATE INDEX idx_nodes_started ON nodes(started);
```

### Table: policies
```sql
CREATE TABLE policies (
    policy_id TEXT PRIMARY KEY,
    yaml_content TEXT NOT NULL,
    rules_count INTEGER NOT NULL,
    created_at REAL NOT NULL,
    updated_at REAL NOT NULL
);
```

### Table: path_cache
```sql
CREATE TABLE path_cache (
    cache_key TEXT PRIMARY KEY,  -- "{source}:{dest}:{k}"
    source TEXT NOT NULL,
    destination TEXT NOT NULL,
    k INTEGER NOT NULL,
    bundle_json TEXT NOT NULL,    -- JSON serialized PathBundle
    created_at REAL NOT NULL,
    expires_at REAL NOT NULL
);
CREATE INDEX idx_cache_expires ON path_cache(expires_at);
CREATE INDEX idx_cache_source_dest ON path_cache(source, destination);
```

---

## Risk Assessment

| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| Write concurrency bottleneck | Low (10%) | Medium | Write queue + batch updates |
| Database file corruption | Very Low (1%) | High | Regular backups + WAL mode |
| Migration complexity | Low (5%) | Medium | Abstract interface from day 1 |

---

## Success Criteria

- ✅ All CRUD operations <1ms
- ✅ 100% data durability across restarts
- ✅ 5+ tests passing
- ✅ Zero external dependencies
- ✅ Easy backup/restore (single file)

---

## Approval

**Decision**: SQLite selected for persistence layer  
**Approved by**: System Architect  
**Date**: 2025-11-05  
**Status**: **IMPLEMENTATION BEGINS NOW** 🚀

---

*Document: storage_decision.md*  
*Location: docs/decisions/*  
*Next: Implementation in storage_layer.py*
