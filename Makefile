.PHONY: debug release sanitize lto clean

debug:
	cmake --preset debug
	cmake --build --preset debug

release:
	cmake --preset release
	cmake --build --preset release

sanitize:
	cmake --preset debug-sanitize
	cmake --build --preset debug-sanitize

lto:
	cmake --preset release-lto
	cmake --build --preset release-lto

clean:
	rm -rf build
	rm -rf bin
