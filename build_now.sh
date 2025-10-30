#!/bin/bash
# Quick build script that stays in the right directory

cd "$(dirname "$0")"
pwd

echo "Building BitNet with MinGW..."
./tools/cmake-3.30.5-windows-x86_64/bin/cmake.exe --build build_mingw --config Release -j 4
