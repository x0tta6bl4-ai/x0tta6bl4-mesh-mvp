# Legacy Requirements Files (Archived)

**Date Archived:** 2025-11-03  
**Reason:** Consolidated into `pyproject.toml` with optional dependency groups

## Files in this directory

These requirements files have been replaced by the unified dependency management in `pyproject.toml`:

- `requirements-dev.txt` → `[project.optional-dependencies] dev = [...]`
- `requirements-ml.txt` → `[project.optional-dependencies] ml = [...]`
- `requirements-lora.txt` → `[project.optional-dependencies] lora = [...]`
- `requirements-p04.txt` → (merged into appropriate groups)
- `requirements.consolidated.txt` → (superseded)

## Migration

Old installation pattern:
```bash
pip install -r requirements.txt
pip install -r requirements-dev.txt
pip install -r requirements-ml.txt
```

New installation pattern:
```bash
pip install -e ".[dev,ml,lora,monitoring]"
```

For production (minimal dependencies):
```bash
pip install -e .
```

## Rollback

If you need to restore the old requirements files:
```bash
cd docs/archive/requirements_legacy
cp *.txt ../../../
```

---
*Archived as part of Sprint 1 Technical Debt Reduction (Nov 2-9, 2025)*
