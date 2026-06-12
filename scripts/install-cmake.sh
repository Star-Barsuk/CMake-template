#!/usr/bin/env bash
# Build and install a specific CMake release into ~/.local/cmake/<version>.
#
# Usage:
#   ./scripts/install-cmake.sh              # latest pinned version
#   ./scripts/install-cmake.sh 4.3.3         # explicit version
#   CMAKE_PREFIX=$HOME/.local/cmake/4.3.3 ./scripts/install-cmake.sh
#
# After install, prepend to PATH:
#   export PATH="$HOME/.local/cmake/4.3.3/bin:$PATH"

set -euo pipefail

VERSION="${1:-4.3.3}"
JOBS="${JOBS:-$(nproc 2>/dev/null || echo 4)}"
PREFIX="${CMAKE_PREFIX:-$HOME/.local/cmake/${VERSION}}"
WORKDIR="${TMPDIR:-/tmp}/cmake-build-${VERSION}"
TARBALL="cmake-${VERSION}.tar.gz"
URL="https://github.com/Kitware/CMake/releases/download/v${VERSION}/${TARBALL}"

if command -v cmake >/dev/null 2>&1 && cmake --version | head -1 | grep -q "${VERSION}"; then
    echo "cmake ${VERSION} already on PATH: $(command -v cmake)"
    exit 0
fi

echo "→ Installing CMake ${VERSION} to ${PREFIX}"

mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

if [[ ! -f "${TARBALL}" ]]; then
    echo "→ Downloading ${URL}"
    curl -fsSL -o "${TARBALL}" "${URL}"
fi

if [[ ! -d "cmake-${VERSION}" ]]; then
    tar xzf "${TARBALL}"
fi

cd "cmake-${VERSION}"

OPENSSL_FLAG="-DCMAKE_USE_OPENSSL=ON"
if ! pkg-config --exists openssl 2>/dev/null; then
    echo "→ OpenSSL dev headers not found; building without OpenSSL support"
    OPENSSL_FLAG="-DCMAKE_USE_OPENSSL=OFF"
fi

./bootstrap \
    --prefix="${PREFIX}" \
    --parallel="${JOBS}" \
    -- \
    -DCMAKE_BUILD_TYPE=Release \
    ${OPENSSL_FLAG}

cmake --build . --parallel "${JOBS}"
cmake --install .

echo ""
echo "Done. Add to your shell profile:"
echo "  export PATH=\"${PREFIX}/bin:\$PATH\""
echo ""
"${PREFIX}/bin/cmake" --version
