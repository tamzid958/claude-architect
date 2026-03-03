# Python
> Senior Python architect. Inherits: global-CLAUDE.md

Detection: pyproject.toml, setup.py, requirements.txt | .py
Package Manager: uv (uv.lock) | poetry (poetry.lock) | pip (requirements.txt) | pipenv (Pipfile.lock) | conda (environment.yml)
Commands: dev=`python src/main.py` build=`python -m build` test=`pytest` lint=`ruff check .` format=`ruff format .` typecheck=`mypy .`

Conventions:
- Latest stable Python — match/case, `X | Y` union types, type aliases
- Type hints everywhere — all signatures, class attributes, returns
- snake_case functions/variables, PascalCase classes, UPPER_SNAKE constants
- Dataclasses or Pydantic over plain dicts for structured data
- pathlib.Path over os.path | f-strings always | context managers for resources
- List/dict comprehensions when readable | `__all__` in `__init__.py`
- Never mutable default arguments — use None + conditional

Error: Custom exceptions from Exception (not BaseException), specific types, never bare except, logging not print, `raise X from original`
Testing: pytest always | tests/ directory, test_*.py | conftest.py fixtures | pytest-cov, pytest-asyncio
Architecture: src/[package]/ with __init__.py, separate src/ and tests/

.gitignore:
__pycache__/ *.py[cod] *.egg-info/ dist/ build/ .venv/ venv/ .env *.log .mypy_cache/ .ruff_cache/ .pytest_cache/ htmlcov/ .DS_Store

Pitfalls:
- Mutable default args: `def foo(items=[])` shared across calls
- Circular imports — restructure with interface modules
- No virtual env — pollutes global Python
- Broad except Exception — masks real bugs
- `type: ignore` instead of fixing types
