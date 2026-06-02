# 🚀 ]C++23 Template

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
./bin/Debug/calculator
```

Expected output:

```text
2 + 3 = 5
10 - 4 = 6
```

---

# 🌐 Automatic Target Discovery

Targets are generated automatically based on the `src/` directory structure.

| Pattern | Target | Type |
|----------|----------|----------|
| `src/demo.cpp` | `demo` | Executable |
| `src/calculator/main.cpp` | `calculator` | Executable |
| `src/math/*.cpp` | `libmath.a` | Static Library |
| `src/main.cpp` (with `SINGLE_APP=ON`) | `${PROJECT_NAME}` | Single executable |

`src/main.cpp` is reserved for single-app mode and is **not** picked up by the root `src/*.cpp` glob in multi-target mode.

---

# 📦 Single-app mode

For one CLI or pet project with a single entry point:

1. Rename `project(...)` in `CMakeLists.txt` (e.g. `project(mytool ...)`).
2. Add `src/main.cpp` (see `src/main.cpp.example`).
3. Enable `SINGLE_APP=ON` via `CMakeUserPresets.json` (see below) or when configuring:

```bash
cmake --preset debug -DSINGLE_APP=ON
make build-debug
```

Run:

```bash
./bin/Debug/mytool      # Debug
./bin/Release/mytool    # Release — name matches project()
```

There is no separate `single` preset: single-app is the same `debug` / `release` flow with one CMake option.

In this mode:

- only `src/main.cpp` becomes an executable;
- `src/*.cpp` glob and directory executables (e.g. `calculator/`) are disabled;
- static libraries under `src/*/` (without `main.cpp`) are still built.

---

# 🗂️ Project Structure

```text
.
├── 🔨 CMakeLists.txt              # Build configuration
├── ⚙️ CMakePresets.json           # CMake presets (debug, release, etc.)
├── 🎨 .clang-format               # Code style configuration
├── ⚡ Makefile                     # Command shortcuts
├── 📁 src/                         # Source code
│   ├── 🎯 demo.cpp                  # Root executable (auto-detected)
│   ├── 📁 calculator/               # Calculator module
│   │   ├── 📄 main.cpp               # Entry point → executable
│   │   ├── 📄 calculator.cpp         # Implementation
│   │   └── 📄 calculator.hpp         # Header
│   └── 📁 math/                     # Math library
│       ├── 📄 vector.cpp             # Implementation
│       └── 📄 vector.hpp             # Vector2 structure
└── 📄 README.md                  # This file
```

---

# ⚙️ Discovery Rules

## Standalone Executable

```text
src/example.cpp
```

becomes

```text
example
```

---

## Directory Executable

```text
src/calculator/
├── main.cpp
├── calculator.cpp
└── calculator.hpp
```

becomes

```text
calculator
```

All `.cpp` files inside the directory are compiled into the executable.

---

## Static Library

```text
src/math/
├── vector.cpp
└── vector.hpp
```

becomes

```text
libmath.a
```

Any directory containing `.cpp` files but **without** `main.cpp` becomes a static library.

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

**After switching presets** (`debug` ↔ `release`) or changing CMake options (e.g. `SINGLE_APP`), run `make clean`, then `make config-<preset>`.

For single-app by default, copy `CMakeUserPresets.json.example` → `CMakeUserPresets.json` (gitignored) and set `SINGLE_APP=ON` on `debug` / `release` — then `make debug` works without extra flags.

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

# 🎯 Build Individual Targets

Configure cmake:
```bash
cmake --preset debug
```

Build only the calculator:

```bash
cmake --build --preset debug --target calculator
```

Build only the demo application:

```bash
cmake --build --preset debug --target demo
```

Build only the math library:

```bash
cmake --build --preset debug --target math
```

---

## Custom Options

```bash
cmake --preset debug \
    -DSINGLE_APP=ON \
    -DENABLE_THREADS=ON \
    -DWARNINGS_AS_ERRORS=ON

cmake --build --preset debug
```

---

# ⚙️ Available Options

| Option | Default | Description |
|----------|----------|----------|
| `SINGLE_APP` | `OFF` | Only `src/main.cpp` as executable; no root glob / dir executables |
| `ENABLE_THREADS` | `OFF` | Link with `Threads::Threads` |
| `ENABLE_IPO` | `ON` | Enable IPO/LTO for Release (checked once per configure) |
| `ENABLE_SANITIZERS` | `OFF` | Enable sanitizers (Debug only) |
| `WARNINGS_AS_ERRORS` | `OFF` | Treat warnings as errors |

Example:

```bash
cmake --preset debug \
    -DSINGLE_APP=ON \
    -DENABLE_THREADS=ON \
    -DWARNINGS_AS_ERRORS=ON
```

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
│   ├── calculator
│   ├── demo
│   └── lib/
│       └── libmath.a
│
└── Release/
    ├── calculator
    ├── demo
    └── lib/
        └── libmath.a
```

---

# 📋 Requirements

| Component | Version |
|------------|------------|
| CMake | 3.28+ |
| Ninja | Latest |
| GCC | 14+ |
| Clang | 18+ |
| GNU Make | 4.0+ |

Optional:

- clang-format 18+ (20+ recommended for `InsertBraces`, `RemoveSemicolon`)
- Threading support

---

# ➕ Adding New Executables

Create a new source file:

```bash
cat > src/hello.cpp << EOF
#include <iostream>

int main()
{
    std::cout << "Hello World\n";
}
EOF
```

Build:

```bash
make debug
```

Run:

```bash
./bin/Debug/hello
```

No CMake modifications required.

---

# ➕ Adding New Libraries

Create a module directory:

```bash
mkdir -p src/geometry
```

Implementation:

```cpp
double area(double r)
{
    return 3.14159265359 * r * r;
}
```

Header:

```cpp
#pragma once

double area(double r);
```

Build:

```bash
make debug
```

Generated automatically:

```text
libgeometry.a
```

Location:

```text
bin/Debug/lib/
```

---

# 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

**© 2026 Star-Barsuk**

</div>
