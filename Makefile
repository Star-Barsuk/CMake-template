.PHONY: clean format lint check-format
.PHONY: debug release sanitize lto test
.PHONY: config-debug build-debug config-release build-release
.PHONY: config-sanitize build-sanitize config-lto build-lto
.PHONY: package-linux-x86_64 package-linux-aarch64 package-linux

SRC_FILES := $(shell find src include tests -type f \( -name "*.cpp" -o -name "*.hpp" \))
UNAME_M := $(shell uname -m)

# ── Workflows (configure → build → test) ────────────────────

debug:
	cmake --workflow --preset debug
	@ln -sf build/debug/compile_commands.json compile_commands.json

release:
	cmake --workflow --preset release

sanitize:
	cmake --workflow --preset sanitize
	@ln -sf build/debug-sanitize/compile_commands.json compile_commands.json

lto:
	cmake --workflow --preset lto

test:
	cmake --workflow --preset debug

# ── Granular steps (optional) ───────────────────────────────

config-debug:
	cmake --preset debug
	@ln -sf build/debug/compile_commands.json compile_commands.json

build-debug:
	cmake --build --preset debug

config-release:
	cmake --preset release

build-release:
	cmake --build --preset release

config-sanitize:
	cmake --preset debug-sanitize
	@ln -sf build/debug-sanitize/compile_commands.json compile_commands.json

build-sanitize:
	cmake --build --preset debug-sanitize

config-lto:
	cmake --preset release-lto

build-lto:
	cmake --build --preset release-lto

# ── Tooling ─────────────────────────────────────────────────

format:
	clang-format -i $(SRC_FILES)

check-format:
	clang-format --dry-run --Werror $(SRC_FILES)

lint: check-format

clean:
	rm -rf build bin compile_commands.json dist

# ── Release packages (Phase 3 — manual staging) ───────────

DIST_DIR := dist
TOOLCHAIN_AARCH64 := $(CURDIR)/cmake/toolchain-aarch64-linux-gnu.cmake

package-linux-x86_64:
	@mkdir -p $(DIST_DIR)
	cmake --preset release-x86_64
	cmake --build --preset release-x86_64
	cp bin/Release/defaultproject $(DIST_DIR)/defaultproject-linux-x86_64
	strip $(DIST_DIR)/defaultproject-linux-x86_64
	@echo "→ $(DIST_DIR)/defaultproject-linux-x86_64"

package-linux-aarch64:
	@mkdir -p $(DIST_DIR)
	cmake --preset release-aarch64
	cmake --build --preset release-aarch64
	cp bin/Release/defaultproject $(DIST_DIR)/defaultproject-linux-aarch64
ifeq ($(UNAME_M),aarch64)
	strip $(DIST_DIR)/defaultproject-linux-aarch64
	@echo "→ $(DIST_DIR)/defaultproject-linux-aarch64 (native arm64)"
else
	aarch64-linux-gnu-strip $(DIST_DIR)/defaultproject-linux-aarch64
	@echo "→ $(DIST_DIR)/defaultproject-linux-aarch64 (cross from $(UNAME_M))"
endif

package-linux: package-linux-x86_64 package-linux-aarch64
