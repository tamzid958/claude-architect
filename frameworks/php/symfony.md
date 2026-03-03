# Symfony
> Senior Symfony architect. Inherits: php/_base.md

Detection: `symfony/framework-bundle` in composer.json + symfony.lock + config/bundles.php
Commands: dev=`symfony server:start` test=`./vendor/bin/phpunit` lint=`./vendor/bin/php-cs-fixer fix --dry-run` console=`php bin/console` migrate=`php bin/console doctrine:migrations:migrate`

Conventions:
- Autowired DI — constructor injection, no manual service definitions unless needed
- Attributes routing: #[Route('/users', methods: ['GET'])] on controller methods
- Doctrine ORM — entity attribute mapping, repository pattern, migrations
- Flex recipes auto-configure bundles on install
- YAML config in config/packages/, environment-specific in config/packages/{env}/
- Twig templates, Form component (FormType classes) for form handling
- Validation constraints as attributes on entity/DTO properties
- security.yaml for firewall, voters for authorization
- Messenger for async message handling

Error: ExceptionListener for global errors, createNotFoundException(), ProblemDetails for APIs, validation auto-returns 422
Test: PHPUnit + WebTestCase (functional) | KernelTestCase (service) | createClient() for HTTP | Panther for E2E
Structure: config/{packages/,routes/,services.yaml} src/{Controller/,Entity/,Repository/,Service/,Form/,Message/,MessageHandler/} templates/ migrations/ tests/ public/

Convention Block:
- Autowired DI — constructor injection, no manual service definitions unless needed
- Attributes routing on controllers: #[Route]
- Doctrine ORM — attribute mapping, repository pattern
- Twig for templates, Form component for form handling
- security.yaml for firewall config, voters for authorization
- PHPUnit + WebTestCase for functional testing
- Symfony Flex for bundle auto-configuration

Pitfalls:
- Not using autowiring — manually configuring auto-wirable services
- Business logic in controllers — extract to services
- Not using Doctrine migrations — manual schema changes
- Forgetting cache:clear after config changes in prod
- Inline role checks instead of voters for authorization
