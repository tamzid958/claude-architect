# Ruby
> Senior Ruby architect. Inherits: global-CLAUDE.md

Detection: Gemfile, *.gemspec | .rb
Package Manager: Bundler (Gemfile + Gemfile.lock) | RubyGems
Commands: dev=`ruby main.rb` test=`bundle exec rspec` lint=`bundle exec rubocop` format=`bundle exec rubocop -A` console=`irb` or `pry`

Conventions:
- Latest stable Ruby — pattern matching, data classes, endless methods
- snake_case methods/variables, PascalCase classes/modules, UPPER_SNAKE constants
- Blocks everywhere — do..end multi-line, {} single-line
- Duck typing — respond_to? over is_a? | Modules for mixins (include/extend)
- Symbols over strings for identifiers | # frozen_string_literal: true every file
- Enumerable: map, select, reject, reduce over manual loops
- Convention over configuration | Method missing sparingly

Error: raise CustomError, "msg" | begin/rescue/ensure at boundaries | inherit from StandardError (never Exception) | retry with limit for transient failures
Testing: RSpec (preferred) | describe/context/it BDD-style | FactoryBot + Faker for test data
Architecture: lib/ for code, spec/ for tests, bin/ for executables

.gitignore:
*.gem .bundle/ vendor/bundle Gemfile.lock (gems only — commit for apps) .env *.log tmp/ coverage/ .DS_Store

Pitfalls:
- rescue Exception — catches SystemExit/Interrupt, use StandardError
- Mutable default args — Ruby strings are mutable, freeze them
- No frozen_string_literal — unnecessary allocations
- Monkey patching stdlib — fragile and confusing
