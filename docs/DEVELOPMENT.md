# x0tta6bl4 Development Guide

**Last Updated:** 2025-11-03  
**Status:** Active Development

## Quick Start

### Installation

```bash
# Clone repository
git clone https://github.com/x0tta6bl4/x0tta6bl4_paradox_zone.git
cd x0tta6bl4_paradox_zone

# Install with all development tools
pip install -e ".[dev,ml,lora,monitoring]"

# Install pre-commit hooks
pre-commit install
```

### Running Tests

```bash
# Run all tests with coverage
pytest --cov=x0tta6bl4_core --cov-report=term-missing

# Run specific test file
pytest tests/edge/test_drift_detector_edge.py

# Run with verbose output
pytest -v
```

### Code Quality Checks

```bash
# Linting
ruff check .
ruff check . --fix  # Auto-fix issues

# Formatting
black .
black --check .  # Check only

# Type checking
mypy x0tta6bl4_core
```

### Security Scans

```bash
# Dependency vulnerabilities
pip-audit

# Static analysis
bandit -r x0tta6bl4_core

# Secret scanning
gitleaks detect --no-git
```

## Project Structure

```
x0tta6bl4_paradox_zone/
├── x0tta6bl4_core/          # Core library code
├── x0tta6bl4/core/          # New modular core (logging, etc.)
├── tests/                   # Test suite
│   ├── unit/                # Unit tests
│   ├── edge/                # Edge case tests
│   └── integration/         # Integration tests
├── scripts/                 # Utility scripts
├── docs/                    # Documentation
│   └── archive/             # Archived/deprecated docs
├── pyproject.toml           # Project configuration & dependencies
└── .pre-commit-config.yaml  # Git hooks configuration
```

## Development Workflow

### 1. Create Feature Branch

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/bug-description
```

### 2. Make Changes

- Write code following project conventions
- Add tests for new functionality
- Update documentation as needed
- Run quality checks before committing

### 3. Commit

Pre-commit hooks will automatically run:
- Ruff (linting)
- Black (formatting)
- MyPy (type checking)
- Bandit (security)
- Gitleaks (secret scanning)

```bash
git add .
git commit -m "feat: description of feature"
```

### 4. Push and Create PR

```bash
git push -u origin feature/your-feature-name

# Create PR using GitHub CLI
gh pr create --title "Feature: Your Feature" --body "Description"
```

### 5. PR Review

Your PR must pass:
- ✅ All tests (coverage ≥ 75%)
- ✅ Linting (Ruff, Black)
- ✅ Type checking (MyPy)
- ✅ Security scans (Bandit, pip-audit)

## Coding Standards

### Python Style

- **Line length:** 127 characters (configured in pyproject.toml)
- **Python version:** 3.11+
- **Formatting:** Black
- **Linting:** Ruff
- **Type hints:** Required for public APIs

### Commit Messages

Follow conventional commits:

```
feat: add new drift detection strategy
fix: correct spike threshold calculation
docs: update installation instructions
test: add edge cases for seasonal anomaly
chore: update dependencies
refactor: simplify logging interface
```

### Logging

Use structured JSON logging:

```python
from x0tta6bl4.core.logging import get_logger

logger = get_logger(__name__)
logger.info("operation_complete", metric_name="latency", value=0.123)
logger.error("operation_failed", error_code="E001", details="Connection timeout")
```

### Testing

- Write tests for all new functionality
- Aim for ≥ 75% coverage
- Include edge cases and error scenarios
- Use descriptive test names

```python
def test_drift_detector_handles_nan_gracefully():
    detector = DriftDetector(config)
    events = detector.update([float('nan'), 1.0, 2.0])
    assert len(events) >= 0  # Should not crash
```

## Dependencies

Dependencies are managed in `pyproject.toml`:

```toml
[project.optional-dependencies]
dev = ["pytest>=7.0", "ruff>=0.6.0", ...]
ml = ["scikit-learn>=1.2.0", "pandas>=1.5.0"]
lora = ["peft>=0.2.0", "transformers>=4.40.0"]
monitoring = ["prometheus-client>=0.21.0"]
```

### Adding New Dependencies

1. Add to appropriate group in `pyproject.toml`
2. Specify minimum version
3. Document rationale in PR
4. Run security scan: `pip-audit`

## Troubleshooting

### Pre-commit hooks failing

```bash
# Update hooks
pre-commit autoupdate

# Run manually
pre-commit run --all-files
```

### Tests failing locally

```bash
# Clean Python cache
find . -type d -name __pycache__ -exec rm -rf {} +
find . -type f -name "*.pyc" -delete

# Reinstall in development mode
pip install -e ".[dev,ml]"
```

### Import errors

Ensure you're using editable install:
```bash
pip install -e .
```

## Resources

- **Main README:** `/README.md`
- **Architecture:** `/docs/ARCHITECTURE.md`
- **Technical Debt Roadmap:** `/x0tta6bl4_tech_debt_roadmap.md`
- **Sprint Plans:** `/SPRINT_1_EXECUTION.md`

## Getting Help

- Open an issue on GitHub
- Check existing documentation in `/docs/`
- Review test files for usage examples

---
**Sprint 1 Focus:** Technical debt reduction (Nov 2-9, 2025)
