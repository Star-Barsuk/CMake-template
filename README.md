<div align="center">

# C++23 Template

[![C++23](https://img.shields.io/badge/C++-23-00599C?style=flat&logo=cplusplus&logoColor=white)](https://isocpp.org/) [![CMake](https://img.shields.io/badge/CMake-3.28+-brightgreen?style=flat&logo=cmake&logoColor=white)](https://cmake.org/) [![Ninja](https://img.shields.io/badge/Ninja-Build-orange.svg)](https://ninja-build.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![Platform](https://img.shields.io/badge/Platform-Linux-lightgrey?style=flat&logo=linux&logoColor=white)](https://github.com/Star-Barsuk/CMake-template)

</div>

A C++23 project template with CMake presets.

---

# 📦 Quick Start

```bash
# 1. Clone
git clone https://github.com/star-barsuk/cmake-template.git ./cmake-template
cd cmake-template

# 2. Build
make debug

# 3. Run
./bin/Debug/defaultproject
```

Expected output (no args → help):

```text
Usage: defaultproject [KEYWORD] [ARG]...
       defaultproject --version
       defaultproject --help
```

When forking, rename `project(DefaultProject ...)` in `CMakeLists.txt`. CMake derives `PROJECT_SLUG` (`defaultproject`) for the executable, include paths, and install layout.

---

# 🗂️ Project Structure

```text
.
├── CMakeLists.txt
├── CMakePresets.json
├── cmake/
│   ├── ProjectVariables.cmake   # PROJECT_SLUG, include paths
│   ├── Options.cmake
│   ├── CompilerSupport.cmake
│   ├── TargetDefaults.cmake     # INTERFACE targets + apply_target_defaults()
│   ├── UnitTest.cmake
│   ├── InstallRules.cmake
│   └── toolchains/
│       ├── linux-x86_64.cmake
│       └── linux-aarch64.cmake
├── include/defaultproject/      # Public API (#include <defaultproject/...>)
├── src/
│   ├── main.cpp                 # CLI entry point
│   └── lib/                     # ${PROJECT_SLUG}_lib (STATIC)
├── tests/unit/                  # ${PROJECT_SLUG}_test_* (CTest)
└── README.md
```

Public headers: `include/defaultproject/`. Implementation: `src/lib/`.

---

# ⚙️ Build Layout

| Path | CMake target | Alias |
|------|--------------|-------|
| `src/main.cpp` | `defaultproject` | `DefaultProject::cli` |
| `src/lib/**` | `defaultproject_lib` | `DefaultProject::lib` |
| `tests/unit/*_test.cpp` | `defaultproject_test_*` | — |

Compiler settings flow through INTERFACE targets (`defaultproject_options`, `defaultproject_warnings`) — never global `CMAKE_CXX_FLAGS`.

---

# 🚀 Build Commands

| Target | Action |
|--------|--------|
| `make debug` | Workflow: configure → build → test |
| `make release` | Release workflow |
| `make sanitize` | ASan + UBSan workflow |
| `make lto` | Release + LTO |
| `make test` | Same as `make debug` |
| `make clean` | Remove `build/`, `bin/`, `compile_commands.json` |
| `make format` / `make lint` | clang-format |

```bash
cmake --workflow --preset debug
cmake --install build/debug --prefix dist/install
```

### Presets

| Preset | Build type | Notes |
|--------|------------|--------|
| `debug` | Debug | `-O0 -g`, IPO off |
| `release` | Release | `-O3`, IPO off |
| `debug-sanitize` | Debug | ASan + UBSan |
| `release-lto` | Release | IPO on |

---

# ⚙️ CMake Options

| Option | Default | Description |
|--------|---------|-------------|
| `ENABLE_THREADS` | `OFF` | Link with `Threads::Threads` |
| `ENABLE_IPO` | `ON` | IPO/LTO for Release |
| `ENABLE_SANITIZERS` | `OFF` | ASan + UBSan (Debug only) |
| `WARNINGS_AS_ERRORS` | `OFF` | `-Werror` |

---

# 📊 Output Layout

```text
bin/Debug/
├── defaultproject
├── defaultproject_test_parser
├── defaultproject_test_cstring
└── lib/libdefaultproject_lib.a
```

---

# 📋 Requirements

| Component | Version |
|-----------|---------|
| CMake | 3.28+ |
| Ninja | Latest |
| GCC | 14+ |
| Clang | 18+ |
| GNU Make | 4.0+ |

Optional: clang-format 18+

---

# ➕ Extending

1. Headers → `include/defaultproject/<area>/`
2. Sources → `src/lib/<area>/` (list in `src/lib/CMakeLists.txt`)
3. Tests → `tests/unit/<name>_test.cpp` + `add_unit_test(<name>)` in `tests/unit/CMakeLists.txt`

```bash
make debug
```

---

# 📄 License

MIT — see [LICENSE](LICENSE).

---

<div align="center">

**© 2026 Star-Barsuk**

</div>
