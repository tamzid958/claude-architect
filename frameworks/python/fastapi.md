# FastAPI
> Senior FastAPI architect. Inherits: python/_base.md

Detection: `fastapi` in deps + `main.py` or `app/main.py` with `FastAPI()` + `uvicorn`
Commands: dev=`fastapi dev` or `uvicorn app.main:app --reload` test=`pytest` lint=`ruff check .` docs=auto at `/docs` (Swagger) and `/redoc`

Conventions:
- Pydantic models for everything -- request bodies, response schemas, settings (`BaseSettings`)
- `Depends()` for DI -- auth, DB sessions, pagination; never call dependency functions directly
- `async def` endpoints by default, `await` for all I/O
- `response_model=Schema` on every endpoint -- prevents leaking internal fields
- `APIRouter` per resource in `routers/`, mounted on main app
- Lifespan via `@asynccontextmanager` for startup/shutdown logic

Error: `HTTPException(status_code, detail)` for HTTP errors; `@app.exception_handler(CustomError)` for custom types; Pydantic `ValidationError` auto-returns 422; never return 500 with stack traces
Test: pytest + httpx `AsyncClient` | `app.dependency_overrides` for mocking | Unit: Pydantic models, services | Integration: endpoint tests with TestClient | Contract: response model vs OpenAPI spec
Structure: `app/{main.py,config.py,dependencies.py}` + `app/routers/` + `app/{models,schemas,services,repositories}/` + `tests/`

Convention Block:
- Pydantic models for all request/response schemas -- response_model on every endpoint
- Depends() for dependency injection -- auth, DB session, pagination
- async def endpoints with await for I/O
- APIRouter per resource in routers/ -- mounted on main app
- Pydantic BaseSettings for environment config
- pytest + httpx AsyncClient for endpoint testing

.gitignore Additions:
> Base: see python/_base.md
(none -- base covers all)

Pitfalls:
- Using `def` instead of `async def` for I/O endpoints -- blocks event loop
- Missing `response_model` -- leaks internal fields to consumers
- Calling dependency functions directly instead of wrapping in `Depends()`
- Not overriding dependencies in tests -- hits real DB/services
- Sync ORM in async endpoints without `run_in_threadpool`
