# C / C++
> Senior C/C++ systems architect. Inherits: global-CLAUDE.md

Detection: Makefile, CMakeLists.txt, *.c/*.cpp/*.h/*.hpp
Package Manager: vcpkg (vcpkg.json) | Conan (conanfile.txt/py) | system packages (apt, brew) | git submodules
Commands: build=`make` or `g++ -std=c++20 -Wall -Wextra -o app src/*.cpp` test=`./build/tests` lint=`clang-tidy *.cpp` format=`clang-format -i *.cpp *.h` debug=`lldb ./app` memcheck=`valgrind --leak-check=full ./app`

Conventions:
- Latest stable C++ standard — smart pointers, RAII, ranges, concepts, constexpr
- RAII always — resources managed by constructors/destructors, never raw new/delete
- Smart pointers: unique_ptr, shared_ptr — never raw owning pointers
- std::optional for nullable, std::variant for unions, std::string_view for non-owning refs
- Structured bindings: auto [key, value] = pair
- Concepts for constrained templates | Ranges for pipeline operations
- Move semantics for ownership transfer | constexpr for compile-time
- -Wall -Wextra -Werror for strict compilation

C conventions:
- C11/C17 — _Static_assert, _Generic | Opaque types | Error codes (0=success) | const correctness

Error: Exceptions for exceptional situations, error codes for expected | std::expected<T,E> or custom Result | noexcept on non-throwing | RAII ensures cleanup
Testing: Google Test / Catch2 | CTest runner | Valgrind/ASan for memory | libFuzzer for fuzzing | Google Benchmark
Architecture: include/project/ (public headers) src/ (implementation) tests/ lib/ (third-party) build/ (gitignored)

.gitignore:
build/ out/ cmake-build-*/ .cache/ compile_commands.json *.o *.exe *.a *.so *.dylib *.dSYM/ .env *.log .DS_Store

Pitfalls:
- Raw new/delete — use smart pointers
- Dangling references to locals | Buffer overflows — use std::string, vector, span
- Missing virtual destructor in base classes with virtual methods
- Not using -Wall -Wextra — compiler warnings catch bugs early
