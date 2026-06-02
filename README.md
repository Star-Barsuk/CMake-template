# 🚀 C++23 Template

[![C++23](https://img.shields.io/badge/C%2B%2B-23-blue.svg)](https://en.cppreference.com/w/cpp/23) [![CMake](https://img.shields.io/badge/CMake-3.28%2B-green.svg)](https://cmake.org/) [![Ninja](https://img.shields.io/badge/Ninja-Build-orange.svg)](https://ninja-build.org/) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

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

Expected output:

```text
2 + 3 = 5
10 - 4 = 6
distance (0,0)-(3,4) = 5
```

`calculator` links against the `math` module (`vector_length`, `vector_sub`) to compute distances.

Rename `project(...)` in `CMakeLists.txt` to change the executable name (e.g. `project(mytool ...)` → `./bin/Debug/mytool`).

---

# 🗂️ Project Structure

```text
.
├── 🔨 CMakeLists.txt              # Build configuration
├── ⚙️ CMakePresets.json           # CMake presets (debug, release, etc.)
├── 🎨 .clang-format               # Code style configuration
├── ⚡ Makefile                     # Command shortcuts
├── 📁 src/                         # Source code
│   ├── 📄 main.cpp                 # Application entry point
│   ├── 📁 calculator/               # Calculator module (static library)
│   │   ├── 📄 calculator.cpp
│   │   └── 📄 calculator.hpp
│   └── 📁 math/                     # Math library (static library)
│       ├── 📄 vector.cpp
│       └── 📄 vector.hpp
└── 📄 README.md                  # This file
```

---

# ⚙️ Build Layout

| Path | CMake target | Type |
|------|----------------|------|
| `src/main.cpp` | `${PROJECT_NAME}` | Executable |
| `src/<module>/*.cpp` | `<module>` | Static library (linked into the executable) |

Each module lives in `src/<module>/` with its own `CMakeLists.txt`. Dependencies are declared there (e.g. `calculator` → `math`). The executable links only the top layer (`DefaultProject::calculator`); transitive libs are pulled automatically.

To add a module: create `src/<name>/`, add sources + `CMakeLists.txt`, register `add_subdirectory(src/<name>)` in the root (after its dependencies), and link aliases `${PROJECT_NAME}::<name>` where needed.

---

# 🚀 Build Commands

`make` is a shortcut layer over CMake presets — no options, only fixed targets.

| Target | Action |
|--------|--------|
| `make config-debug` | Configure preset `debug` |
| `make build-debug` | Build preset `debug` |
| `make debug` | `config-debug` + `build-debug` |
| `make config-release` | Configure preset `release` |
| `make build-release` | Build preset `release` |
| `make release` | `config-release` + `build-release` |
| `make config-sanitize` / `make build-sanitize` / `make sanitize` | Preset `debug-sanitize` |
| `make config-lto` / `make build-lto` / `make lto` | Preset `release-lto` |
| `make clean` | Remove `build/`, `bin/`, `compile_commands.json` |
| `make format` / `make lint` | clang-format |

Typical flow after editing code: `make build-debug`.  
After changing preset or CMake options: `make config-debug` (or `make debug`).

Equivalent CMake commands:

```bash
cmake --preset debug && cmake --build --preset debug   # same as make debug
cmake --build --preset debug                           # same as make build-debug
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
│   ├── DefaultProject
│   └── lib/
│       ├── libcalculator.a
│       └── libmath.a
│
└── Release/
    ├── DefaultProject
    └── lib/
        ├── libcalculator.a
        └── libmath.a
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

# ➕ Adding a Module

Create a directory under `src/` with implementation files:

```bash
mkdir -p src/geometry
```

```cpp
// src/geometry/area.hpp
#pragma once
double area(double r);

// src/geometry/area.cpp
#include "area.hpp"
double area(double r) { return 3.14159265359 * r * r; }
```

Use headers from `main.cpp` (or other modules). Rebuild:

```bash
make debug
```

The `geometry` static library is created and linked automatically.

---

# 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

**© 2026 Star-Barsuk**

</div>
