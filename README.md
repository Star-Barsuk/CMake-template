# 🚀 Universal C++23 Template

[![C++23](https://img.shields.io/badge/C%2B%2B-23-blue.svg)](https://en.cppreference.com/w/cpp/23) [![CMake](https://img.shields.io/badge/CMake-3.28%2B-green.svg)](https://cmake.org/) [![Ninja](https://img.shields.io/badge/Ninja-Build-orange.svg)](https://ninja-build.org/) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A C++23 project template with CMake presets, sanitizers, LTO support, and zero-boilerplate project organization.

---

## ✨ Features

- ⚡ **Modern C++23** — latest language features and best practices
- 🔨 **Automatic target discovery** — executables and libraries detected automatically
- 🎯 **Multi-target support** — build multiple applications and libraries from a single configuration
- 🧹 **Convention over configuration** — `main.cpp` creates an executable, otherwise a library
- 🛡️ **Sanitizer ready** — AddressSanitizer and UndefinedBehaviorSanitizer support
- 🚀 **LTO / IPO support** — maximum optimization for release builds (enabled by default)
- 🎨 **clang-format integration** — consistent formatting across the entire project
- ⚙️ **CMake presets** — Debug, Release, Sanitizers, and LTO configurations
- 🏗️ **Cross-platform** — GCC, Clang, and MSVC support
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

## Debug Build

```bash
make debug
```

GCC/Clang flags:

```text
-O0 -g
```

MSVC flags:

```text
/Od /Zi (automatically set by CMake for Debug configuration)
```
---

## Release Build

```bash
make release
```

GCC/Clang flags:

```text
-O3
```

MSVC flags:

```text
/O2 (automatically set by CMake for Release configuration)
```

---

## Sanitizers

```bash
make sanitize
```

Enables (GCC/Clang only):

- AddressSanitizer
- UndefinedBehaviorSanitizer

---

## LTO / IPO

```bash
make lto
```

Enables:

- Link-Time Optimization
- Interprocedural Optimization

⚠️ Important: LTO/IPO is enabled by default for all configurations via the `ENABLE_IPO` option. The `release-lto` preset explicitly ensures it's active for release builds. If you want to disable LTO, use `-DENABLE_IPO=OFF`.

---

## Clean

```bash
make clean
```

Removes:

```text
build/
bin/
```

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
    -DENABLE_THREADS=ON \
    -DWARNINGS_AS_ERRORS=ON

cmake --build --preset debug
```

---

# ⚙️ Available Options

| Option | Default | Description |
|----------|----------|----------|
| `ENABLE_THREADS` | `OFF` | Link with `Threads::Threads` |
| `ENABLE_IPO` | `ON` | Enable IPO/LTO (applies to all build types) |
| `ENABLE_SANITIZERS` | `OFF` | Enable sanitizers (Debug only, GCC/Clang only) |
| `WARNINGS_AS_ERRORS` | `OFF` | Treat warnings as errors |

Example:

```bash
cmake --preset debug \
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

## MSVC

Warnings:

```text
/W4
/permissive-
```

Optional (when WARNINGS_AS_ERRORS is ON):

```text
/WX
```

Note: MSVC optimization flags (/Od, /O2) are automatically set by CMake based on the build type and are not explicitly configured in this project.

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
| MSVC | Visual Studio 2022+ |
| GNU Make | 4.0+ |

Optional:

- clang-format 18+
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

# 💡 Philosophy

This template follows a simple rule:

> Structure defines build targets.

No manual `add_executable()`.
No manual `add_library()`.
No per-target boilerplate.

Just create files and build.

---

# 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

Made with ❤️ for Modern C++ Development

**© 2026 Star-Barsuk**

</div>
