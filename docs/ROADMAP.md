# Build & Infrastructure Roadmap

> Living document for the CMake template. Updated as phases land.

---

## Vision

Evolve this repository from a **working C++23 skeleton** into a **production-minded template** that teams can fork without rewriting build infrastructure.

Target properties:

| Property | Meaning |
|----------|---------|
| **Target-based CMake** | No global flags; every setting flows through named targets |
| **Preset-driven workflows** | One command for configure → build → test (local and CI) |
| **Testable core** | Library logic is linkable and verifiable without shell hacks |
| **Installable artifacts** | `cmake --install` and packaging replace ad-hoc `cp` |
| **Reproducible releases** | Same inputs → same binaries (within toolchain limits) |

---

## Design Principles

1. **Presets over scripts** — `CMakePresets.json` is the source of truth; Makefile only forwards workflows.
2. **Analyze separately from compile** — clang-tidy, coverage, and sanitizers run via dedicated presets, not on every incremental build.
3. **Thin executable, fat library** — `${PROJECT_SLUG}` is the CLI shell; logic lives in `${PROJECT_SLUG}_lib`.
4. **Portable by default** — no shell `grep` tests, no hardcoded distro paths in toolchains.
5. **Progressive complexity** — ship a minimal useful template; advanced tooling is opt-in via presets/options.
6. **Fork-friendly** — rename `project()`, update the `defaultproject` namespace/includes, keep the CMake layout.

---

## Non-Goals

- Full monorepo / Bazel migration
- Conan/vcpkg as mandatory dependencies
- Windows / macOS first-class support (Linux-first is intentional)
- Heavy framework choices baked in (Qt, Boost, etc.)
- C++20 modules layout by default (optional future path only)

---

## Current State — Phase 1 ✅

Foundation and infrastructure polish are complete.

| Item | Status | Implementation |
|------|--------|----------------|
| Lib / exe split | ✅ | `src/lib/` → `${PROJECT_SLUG}_lib`; `src/main.cpp` → `${PROJECT_SLUG}` |
| INTERFACE targets | ✅ | `cmake/TargetDefaults.cmake`: `${PROJECT_SLUG}_options/warnings/sanitizers` |
| Modular CMake | ✅ | `Options`, `CompilerSupport`, `TargetDefaults`, `UnitTest`, `InstallRules` |
| Target-based config | ✅ | `apply_target_defaults()` / `set_output_directories()` — no global flags |
| `PROJECT_SLUG` naming | ✅ | Derived from `project(DefaultProject)` via `cmake/ProjectVariables.cmake` |
| Target aliases | ✅ | `DefaultProject::lib`, `DefaultProject::cli`, `::options/warnings/sanitizers` |
| Unit test binaries | ✅ | `tests/unit/*_test.cpp` → `${PROJECT_SLUG}_test_*` + CTest |
| Workflow presets | ✅ | `debug`, `release`, `sanitize`, `lto` |
| Test presets | ✅ | `debug`, `release`, `debug-sanitize` |
| Thin Makefile | ✅ | `make debug` → `cmake --workflow --preset debug` |
| `install()` rules | ✅ | `cmake/InstallRules.cmake` |
| Toolchain layout | ✅ | `cmake/toolchains/linux-{x86_64,aarch64}.cmake` |

```text
.
├── cmake/
│   ├── ProjectVariables.cmake
│   ├── Options.cmake
│   ├── CompilerSupport.cmake
│   ├── TargetDefaults.cmake
│   ├── UnitTest.cmake
│   ├── InstallRules.cmake
│   └── toolchains/
├── include/defaultproject/
├── src/
│   ├── main.cpp                 # ${PROJECT_SLUG} (executable)
│   └── lib/                     # ${PROJECT_SLUG}_lib (STATIC)
├── tests/unit/
├── CMakePresets.json
└── Makefile
```

```bash
cmake --workflow --preset debug
cmake --install build/debug --prefix dist/install
```

### Known gaps

- Tests use `assert()` — migrate to doctest/Catch2 in Phase 2.
- `package-linux-*` still copies binaries manually instead of `cmake --install`.
- No CI, static analysis gate, or `find_package` consumer story yet.
- CMake minimum tracks latest stable (4.3+); bootstrap script in `scripts/install-cmake.sh`.

---

## Phase 2 — Developer Experience & Quality

| Priority | Item | Rationale |
|----------|------|-----------|
| **P0** | Test framework (doctest or Catch2) | Actionable failures, filtering, future CI integration |
| **P0** | `analyze` workflow preset (clang-tidy) | Off the default debug path; dedicated quality gate |
| **P1** | `.clang-tidy` + `.clang-format` as contracts | Version-controlled tool config |
| **P1** | CMake `format` / `tidy` custom targets | Same entrypoints for IDE and CI |
| **P1** | Generated version metadata | `version.hpp.in` + optional `git describe` |
| **P2** | Coverage preset | `--coverage` / `-fprofile-instr-generate` behind a `coverage` workflow |
| **P2** | Extended sanitizer presets | TSan (separate binary dir), optional LSan |
| **P2** | Compiler-specific warning profiles | `${PROJECT_SLUG}_warnings_gcc` / `_clang` INTERFACE targets |
| **P3** | `ccache` / `sccache` preset option | Faster iteration on large forks |
| **P3** | Optional `pre-commit` config | Format + tidy on staged files |

### Exit criteria

- `cmake --workflow --preset analyze` passes on a clean tree.
- Unit tests report failures with file/line via the test framework.
- `defaultproject --version` can optionally expose git SHA.

---

## Phase 3 — Distribution & Release Engineering

| Priority | Item | Rationale |
|----------|------|-----------|
| **P0** | Install-based staging | Replace `cp` in `package-linux-*` with `cmake --install` |
| **P0** | CPack archives | `tar.gz` / `zip`: `${PROJECT_SLUG}-$VERSION-$ARCH` |
| **P0** | Release workflow preset | configure → build → test → install → package → checksum |
| **P1** | `install(EXPORT)` + `DefaultProjectConfig.cmake` | Downstream `find_package(DefaultProject)` |
| **P1** | Hardening flags (Release) | `_FORTIFY_SOURCE`, `-fstack-protector-strong`, PIE, relro |
| **P1** | Reproducible build flags | `-ffile-prefix-map`, `SOURCE_DATE_EPOCH` in CI |
| **P2** | Portable cross-compilation | Toolchain prefix via env/cache, not hardcoded paths |
| **P2** | SBOM / checksum manifest | `sha256sum` of release artifacts |
| **P3** | Signed releases | GPG / Sigstore for public binaries |

---

## Phase 4 — CI/CD & Automation

| Priority | Item |
|----------|------|
| **P0** | CI using workflow presets (no script drift) |
| **P0** | Matrix: GCC + Clang × debug + release |
| **P1** | Sanitizer + analyze jobs |
| **P1** | Preset validation (`cmake --list-presets`) |
| **P2** | Cross-compile job (`release-aarch64`) |
| **P2** | Integration / golden tests (`tests/integration/`) |
| **P3** | IWYU / cppcheck (non-blocking initially) |

---

## Phase 5 — Advanced & Optional

| Item | When to add |
|------|-------------|
| Benchmark suite | Hot paths need regression tracking |
| Performance presets | Shipping tuned binaries |
| libFuzzer on parser | Parsing surface grows |
| API docs (Doxygen / mdBook) | Public API stabilizes |
| C++20 modules experiment | Compile-time wins justify cost |

---

## Execution Order

### Now — Phase 2

1. doctest + rewrite `tests/unit/*_test.cpp`
2. `.clang-tidy` + `analyze` preset
3. `version.hpp.in` with git metadata
4. CMake `format` target

### Then — Phase 3

5. Release workflow preset
6. CPack + install-based packaging
7. `install(EXPORT)` + `examples/consumer/`
8. Hardening + reproducible flags

### Later — Phase 4

9. CI matrix on workflow presets
10. Integration tests
11. Cross-compile job

---

## Target End State

Checklist:

- [x] Modular target-based CMake
- [x] `${PROJECT_SLUG}` / alias naming convention
- [x] Split `cmake/` modules
- [x] Dedicated unit test binaries + CTest
- [x] Workflow-driven entrypoints
- [x] Basic `install()` rules
- [x] CMake 4.3+ as build-system baseline
- [ ] Proper test framework
- [ ] Static analysis preset
- [ ] Install/export consumer story
- [ ] Reproducible release pipeline
- [ ] CI matrix aligned with presets
- [ ] Integration / golden tests

---

## References

- [CMake Presets](https://cmake.org/cmake/help/latest/manual/cmake-presets.7.html)
- [CMake 4.3 Release Notes](https://cmake.org/cmake/help/latest/release/4.3.html)
- [Professional CMake](https://crascit.com/professional-cmake/)
- [CppBestPractices](https://github.com/lefticus/cppbestpractices)
