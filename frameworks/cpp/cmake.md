# CMake C++ Project
> Senior C++ build architect. Inherits: cpp/_base.md

Detection: CMakeLists.txt at project root + build/ directory + vcpkg.json/conanfile.txt or FetchContent
Commands: configure=`cmake -B build -DCMAKE_BUILD_TYPE=Release` build=`cmake --build build` test=`cd build && ctest --output-on-failure` lint=`clang-tidy -p build src/*.cpp` format=`clang-format -i src/*.cpp include/*.h`

Conventions:
- Modern CMake (3.20+) — targets, not variables
- target_link_libraries(), target_include_directories(), target_compile_features()
- PRIVATE/PUBLIC/INTERFACE visibility on all target commands
- find_package() for system/vcpkg packages, FetchContent for fetching at configure
- project() with version and languages: project(MyApp VERSION 1.0 LANGUAGES CXX)
- add_library() for testable library targets, add_executable() as thin entry point
- CMakePresets.json for reproducible configure/build/test settings
- Generator expressions for build vs install paths
- Never use legacy: include_directories(), link_directories(), add_definitions()

Error: Exception handling per C++ conventions, RAII for resource management
Test: CTest + Google Test (GTest::gtest_main) or Catch2 (Catch2::Catch2WithMain) | Valgrind integration | Google Benchmark
Structure: CMakeLists.txt CMakePresets.json cmake/ include/project/ src/{CMakeLists.txt,main.cpp,module.cpp} tests/{CMakeLists.txt,test_module.cpp} external/ vcpkg.json

Convention Block:
- Modern CMake 3.20+ — target-based, no directory-level commands
- target_link_libraries with PRIVATE/PUBLIC/INTERFACE
- FetchContent or vcpkg for dependencies
- CTest for test runner, Google Test/Catch2 for framework
- CMakePresets.json for reproducible builds
- Out-of-source builds in build/ directory

Pitfalls:
- include_directories() instead of target_include_directories()
- Missing PUBLIC/PRIVATE on target_link_libraries (leaks dependencies)
- In-source builds — always use cmake -B build
- Missing CMAKE_EXPORT_COMPILE_COMMANDS — needed for clang-tidy/IDE
- No presets — inconsistent builds across developers
