#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PATH="${SCRIPT_DIR}/VAbitnet_i2/tools/mingw64/bin:${SCRIPT_DIR}/VAbitnet_i2/tools/cmake-3.30.5-windows-x86_64/bin:$PATH"

echo "=== BitNet Complete Build Script ==="
echo ""

# Configure if needed
if [ ! -d "build_mingw" ]; then
    echo "Step 1/2: Configuring project with CMake..."
    mkdir -p build_mingw
    cd build_mingw
    cmake .. -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++
    cd ..
    echo "✓ Configuration complete"
    echo ""
fi

# Build
echo "Step 2/2: Building (this takes 5-10 minutes)..."
cmake --build build_mingw --config Release -j 2

echo ""
echo "✓ Build completed successfully!"
echo "✓ Binaries are in: build_mingw/bin/"
echo ""
echo "To test inference, run:"
echo "  ./build_mingw/bin/llama-cli.exe -m models/bitnet_b1_58-large/ggml-model-i2_s.gguf -p 'Hello' -n 20"
