# Flask
> Senior Flask architect. Inherits: python/_base.md

Detection: `flask` in deps + `app.py` or `wsgi.py` with `Flask(__name__)` + `config.py` or `instance/`
Commands: dev=`flask run --debug` test=`pytest` lint=`ruff check .`

Conventions:
- Application factory -- `create_app()` in `__init__.py`, never global `app = Flask()`
- Blueprints per feature -- `users_bp`, `auth_bp` for modular route groups
- Flask-SQLAlchemy + Flask-Migrate (Alembic) for ORM and migrations
- Config classes -- `DevelopmentConfig`, `ProductionConfig`, `TestingConfig`
- Context locals -- understand scoping of `g`, `request`, `session`, `current_app`
- Extensions in `extensions.py` -- Flask-Login, Flask-WTF, Flask-CORS, Flask-Marshmallow

Error: `abort(404)` for HTTP errors; `@app.errorhandler(Exception)` for global handling; return tuples `jsonify({"error": msg}), 404`; custom exceptions via `@app.errorhandler(CustomError)`
Test: pytest + `app.test_client()` for routes | `app.test_request_context()` for unit | Unit: utils, model methods, form validators | Integration: route tests with test_client | E2E: Playwright for templates
Structure: `app/{__init__.py,config.py,extensions.py}` + `app/{models,routes,services,templates,static}/` + `tests/` + `migrations/` + `wsgi.py`

Convention Block:
- Application factory pattern -- create_app() in __init__.py
- Blueprints per feature -- routes, models, services grouped
- Flask-SQLAlchemy + Flask-Migrate for DB + migrations
- Config classes: Development, Production, Testing
- abort() for HTTP errors, @errorhandler for custom handling
- pytest + test_client() for route testing

.gitignore Additions:
> Base: see python/_base.md
instance/

Pitfalls:
- Global `app = Flask(__name__)` instead of factory pattern -- untestable
- Working outside application context -- accessing `current_app` without context
- All routes in one file instead of Blueprints -- grows unmanageable
- Forgetting `db.session.commit()` after SQLAlchemy changes
- Using `flask run` in production instead of Gunicorn/uWSGI
