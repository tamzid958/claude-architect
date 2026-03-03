# Django
> Senior Django architect. Inherits: python/_base.md

Detection: `manage.py` + `settings.py` (or `config/settings/`) + `django` in deps
Commands: dev=`python manage.py runserver` test=`pytest --ds=config.settings.test` lint=`ruff check .` migrate=`python manage.py makemigrations && python manage.py migrate` shell=`python manage.py shell_plus`

Conventions:
- Fat models, thin views -- business logic in models/managers, views are glue
- CBVs for CRUD, function views for simple/custom; DRF serializers + viewsets for APIs
- One Django app per feature -- models, views, urls, serializers grouped together
- Settings split: `config/settings/{base,development,production}.py`
- QuerySet chaining -- `.select_related()` / `.prefetch_related()` on all FK/M2M
- Signals sparingly -- prefer explicit method calls over implicit magic

Error: `get_object_or_404()` / `Http404` for missing resources; `PermissionDenied` for auth; DRF custom `EXCEPTION_HANDLER`; form/serializer `is_valid()` for validation
Test: pytest + pytest-django | factory_boy for models | `APIClient` for DRF | Unit: model methods, validators | Integration: endpoint request cycle | E2E: Playwright for templates
Structure: `config/{settings/,urls.py,wsgi.py,asgi.py}` + `apps/<feature>/{models,views,urls,serializers,admin,tests/,migrations/}` + `templates/` + `static/`

Convention Block:
- Fat models, thin views -- business logic in models and managers
- DRF for APIs -- serializers for validation, viewsets + routers for CRUD
- pytest + pytest-django -- factory_boy for model factories, never fixtures
- Migrations are committed -- never edit by hand, never delete
- select_related/prefetch_related for all FK/M2M queries
- Settings split: config/settings/{base,development,production}.py

.gitignore Additions:
> Base: see python/_base.md
db.sqlite3, media/, staticfiles/

Pitfalls:
- N+1 queries -- forgetting `select_related()` / `prefetch_related()`
- Editing migrations by hand -- causes migration conflicts
- Business logic in views instead of models/services
- Hardcoding `User` instead of `get_user_model()`
- Circular imports between apps -- use string references in ForeignKey
