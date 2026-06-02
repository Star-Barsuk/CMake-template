.PHONY: debug release single sanitize lto format lint check-format clean

SRC_FILES := $(shell find src -type f \( -name "*.cpp" -o -name "*.hpp" \))

lint: check-format

debug:
	cmake --preset debug
	cmake --build --preset debug
	@ln -sf build/debug/compile_commands.json compile_commands.json

release:
	cmake --preset release
	cmake --build --preset release

single:
	cmake --preset single
	cmake --build --preset single
	@ln -sf build/single/compile_commands.json compile_commands.json

sanitize:
	cmake --preset debug-sanitize
	cmake --build --preset debug-sanitize

lto:
	cmake --preset release-lto
	cmake --build --preset release-lto

format:
	clang-format -i $(SRC_FILES)

check-format:
	clang-format --dry-run --Werror $(SRC_FILES)

clean:
	rm -rf build bin compile_commands.json
