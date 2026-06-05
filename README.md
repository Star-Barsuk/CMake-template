<div align="center">

# C++23 Template

[![C++23](https://img.shields.io/badge/C++-23-00599C?style=flat&logo=cplusplus&logoColor=white)](https://isocpp.org/) [![CMake](https://img.shields.io/badge/CMake-3.28+-brightgreen?style=flat&logo=cmake&logoColor=white)](https://cmake.org/) [![Ninja](https://img.shields.io/badge/Ninja-Build-orange.svg)](https://ninja-build.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![Platform](https://img.shields.io/badge/Platform-Linux-lightgrey?style=flat&logo=linux&logoColor=white)](https://github.com/Star-Barsuk/CMake-template)

</div>

A C++23 project template with CMake presets.

---

# 📦 Quick Start

## Clone

```bash
# 1. Clone
git clone https://github.com/star-barsuk/cmake-template.git ./cmake-template
cd cmake-template

# 2. Build
make debug

# 3. Run
./bin/Debug/DefaultProject
```

Expected output (no args → help):

```text
Usage: defaultproject [KEYWORD] [ARG]...
       defaultproject --version
       defaultproject --help
```

Rename `project(...)` in `CMakeLists.txt` to change the CMake project name; the executable target stays `defaultproject`.

---

# 🗂️ Project Structure

```text
.
├── 🔨 CMakeLists.txt
├── ⚙️ CMakePresets.json             # configure / build / test / workflow presets
├── 📁 cmake/
│   ├── ProjectSettings.cmake        # INTERFACE targets (options, warnings, sanitizers)
│   └── InstallRules.cmake
├── 📁 include/defaultproject/       # Public API (#include <defaultproject/...>)
│   ├── app/
│   ├── cli/
│   ├── io/
│   └── util/
├── 📁 src/
│   ├── cli/main.cpp                 # Executable entry point
│   └── lib/                         # defaultproject_lib (STATIC)
│       ├── app/
│       ├── cli/
│       └── io/
├── 📁 tests/unit/                   # Dedicated test binaries (CTest)
└── 📄 README.md
```

Public headers live under `include/defaultproject/`. Implementation stays under `src/lib/`.

---

# ⚙️ Build Layout

| Path | CMake target | Type |
|------|----------------|------|
| `src/cli/main.cpp` | `defaultproject` | Executable |
| `src/lib/**` | `defaultproject_lib` (`${PROJECT_NAME}::lib`) | Static library |
| `include/defaultproject/**` | — | Public headers |
| `tests/unit/*.cpp` | `test_*` | Test executables (CTest) |

Compiler flags are applied via INTERFACE targets (`project_options`, `project_warnings`) in `cmake/ProjectSettings.cmake` — not global `CMAKE_CXX_FLAGS`.

The executable links `${PROJECT_NAME}::lib`. Unit tests link the same library target.

---

# 🚀 Build Commands

Preferred entrypoint — **workflow presets** (configure → build → test):

| Target | Action |
|--------|--------|
| `make debug` | Workflow `debug` (configure + build + test) |
| `make release` | Workflow `release` |
| `make sanitize` | Workflow `sanitize` (ASan + UBSan) |
| `make lto` | Workflow `lto` (configure + build) |
| `make test` | Same as `make debug` |
| `make clean` | Remove `build/`, `bin/`, `compile_commands.json` |
| `make format` / `make lint` | clang-format |

Granular steps (`config-*`, `build-*`) remain for incremental builds.

Equivalent CMake commands:

```bash
cmake --workflow --preset debug                      # same as make debug
cmake --preset debug && cmake --build --preset debug # configure + build only
ctest --preset debug                                 # run tests only
cmake --install build/debug --prefix dist/install    # install rules
```

### Preset flags

| Preset | Build type | Notes |
|--------|------------|--------|
| `debug` | Debug | `-O0 -g`, IPO off |
| `release` | Release | `-O3`, IPO off |
| `debug-sanitize` | Debug | ASan + UBSan |
| `release-lto` | Release | IPO on |

`debug` and `release` set `ENABLE_IPO=OFF` for faster iteration. Use `make lto` for a release build with LTO.

---

## Clean

```bash
make clean
```

Removes:

```text
build/
bin/
compile_commands.json
```

**After switching presets** (`debug` ↔ `release` ↔ `debug-sanitize`, etc.) or changing CMake options, run `make clean`, then `make config-<preset>`. Each configure preset uses its own directory: `build/<presetName>/`.

Optional local overrides: `CMakeUserPresets.json` (gitignored) can inherit from any preset and set extra `cacheVariables`.

---

# 🎨 Code Formatting

Format all source files:

```bash
make format
```

Or manually:

```bash
clang-format -i src/**/*.cpp src/**/*.hpp
# or
find src -name "*.cpp" -o -name "*.hpp" | xargs clang-format -i
```

Requires:

```text
clang-format
```

---

## Custom Options

```bash
cmake --preset debug \
    -DENABLE_THREADS=ON \
    -DWARNINGS_AS_ERRORS=ON

cmake --build --preset debug
```

---

# ⚙️ Available Options

| Option | Default | Description |
|--------|---------|-------------|
| `ENABLE_THREADS` | `OFF` | Link with `Threads::Threads` |
| `ENABLE_IPO` | `ON` | Enable IPO/LTO for Release (checked once per configure) |
| `ENABLE_SANITIZERS` | `OFF` | Enable sanitizers (Debug only) |
| `WARNINGS_AS_ERRORS` | `OFF` | Treat warnings as errors |

---

# 🔧 Compiler Configuration

## GCC / Clang

Warnings:

```text
-Wall
-Wextra
-Wpedantic
-Wshadow
-Wconversion
-Wsign-conversion
```

Debug:

```text
-O0 -g
```

Release:

```text
-O3
```

---

# 📊 Output Layout

```text
bin/
├── Debug/
│   ├── defaultproject
│   ├── test_parser
│   ├── test_cstring
│   └── lib/
│       └── libdefaultproject_lib.a
│
└── Release/
    ├── defaultproject
    └── lib/
        └── libdefaultproject_lib.a
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

Optional:

- clang-format 18+ (20+ recommended for `InsertBraces`, `RemoveSemicolon`)
- Threading support

---

# ➕ Extending the Library

1. Add public headers under `include/defaultproject/<area>/`.
2. Add sources under `src/lib/<area>/`.
3. List new `.cpp` files in `src/lib/CMakeLists.txt`.
4. Add a unit test under `tests/unit/` and register it via `add_unit_test(...)`.

Rebuild and test:

```bash
make debug
```

---

# 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

**© 2026 Star-Barsuk**

</div>
