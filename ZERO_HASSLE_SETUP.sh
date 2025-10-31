#!/bin/bash
# ZERO-HASSLE SETUP - Handles everything automatically

set -e

cd "$(dirname "$0")"

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║         VA BitNet - ZERO-HASSLE SETUP                        ║"
echo "║         Fixes everything, builds everything, done.           ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# 1. Download MinGW if needed
if [ ! -f "tools/mingw64/bin/gcc.exe" ]; then
    echo "[1/5] Downloading MinGW (~80 MB)..."
    curl -L -# -o mingw64.7z "https://github.com/niXman/mingw-builds-binaries/releases/download/14.2.0-rt_v12-rev0/x86_64-14.2.0-release-posix-seh-ucrt-rt_v12-rev0.7z"
    
    echo "[2/5] Extracting MinGW..."
    python -m pip install --quiet py7zr
    python -c "import py7zr; py7zr.SevenZipFile('mingw64.7z', 'r').extractall('tools')"
    rm -f mingw64.7z
    echo "✓ MinGW installed"
else
    echo "✓ MinGW already installed"
fi

# 2. Fix CMake if needed
if [ ! -f "tools/cmake-3.30.5-windows-x86_64/share/cmake-3.30/Modules/CMakeInit.cmake" ]; then
    echo "[3/5] Downloading fresh CMake..."
    curl -L -# -o cmake.zip "https://github.com/Kitware/CMake/releases/download/v3.30.5/cmake-3.30.5-windows-x86_64.zip"
    rm -rf tools/cmake-3.30.5-windows-x86_64
    unzip -q cmake.zip -d tools/
    rm cmake.zip
    echo "✓ CMake installed"
else
    echo "✓ CMake already installed"
fi

# 3. Initialize submodules (skip if already done)
echo "[4/5] Checking submodules..."
if [ ! -f "3rdparty/llama.cpp/CMakeLists.txt" ]; then
    echo "  Initializing git submodules (this takes a few minutes)..."
    git submodule update --init --recursive --depth 1
fi
echo "✓ Submodules ready"

# 4. Build
echo "[5/5] Building BitNet (5-10 minutes)..."
echo ""

export PATH="$(pwd)/tools/mingw64/bin:$(pwd)/tools/cmake-3.30.5-windows-x86_64/bin:$PATH"

rm -rf build_mingw
mkdir build_mingw
cd build_mingw

echo "  Configuring..."
cmake .. \
    -G "MinGW Makefiles" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER=gcc \
    -DCMAKE_CXX_COMPILER=g++ \
    > ../cmake_config.log 2>&1

if [ $? -ne 0 ]; then
    echo "✗ Configuration failed:"
    tail -30 ../cmake_config.log
    exit 1
fi

cd ..

echo "  Compiling (be patient, this takes 5-10 minutes)..."
cmake --build build_mingw --config Release -j 2 > cmake_build.log 2>&1 &
BUILD_PID=$!

# Progress indicator
while kill -0 $BUILD_PID 2>/dev/null; do
    sleep 10
    BUILT=$(grep -c "Built target" cmake_build.log 2>/dev/null || echo 0)
    echo "    [$BUILT targets built so far...]"
done

wait $BUILD_PID
if [ $? -ne 0 ]; then
    echo "✗ Build failed:"
    tail -50 cmake_build.log
    exit 1
fi

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                  BUILD SUCCESSFUL!                           ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "✓ Everything installed and built"
echo ""
echo "Run it now:"
echo "  ./run_optimized.sh \"Who is Jimi Hendrix?\" 150"
echo ""
