# PHP
> Senior PHP architect. Inherits: global-CLAUDE.md

Detection: composer.json | .php
Package Manager: Composer (composer.json + composer.lock)
Commands: dev=`php -S localhost:8000` test=`./vendor/bin/phpunit` lint=`./vendor/bin/php-cs-fixer fix --dry-run` analyze=`./vendor/bin/phpstan analyse` format=`./vendor/bin/php-cs-fixer fix`

Conventions:
- Latest stable PHP — enums, readonly classes, fibers, intersection types, null safe operator
- declare(strict_types=1) first line of every file
- PSR-4 autoloading (namespace-to-directory) | PSR-12 coding standard
- Type everything — properties, params, returns, union types, ?nullable
- Readonly properties for immutable data | Enums over string constants
- Named arguments for clarity | Match expression over switch
- Arrow functions: fn($x) => $x * 2 for single-expression closures

Error: Custom exceptions from RuntimeException, specific types, never @ suppression, set_exception_handler() for global handling
Testing: PHPUnit or Pest | PHPStan level 8+ / Psalm for static analysis
Architecture: PSR-4 namespace structure, src/ and tests/ separation

.gitignore:
/vendor/ .env *.log .phpunit.cache/ .php-cs-fixer.cache .DS_Store

Pitfalls:
- Missing declare(strict_types=1) — PHP silently coerces types
- Not using type hints — loses PHP's strongest modern feature
- @ error suppression — hides real bugs
- Not running PHPStan — catches many bugs at build time
