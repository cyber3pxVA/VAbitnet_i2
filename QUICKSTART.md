# Quick Start Guide - VABitNet

## Status: Repository Cloned ✓

The VABitNet repository has been successfully cloned and Git is configured for development.

## Current Setup
- ✓ Repository cloned from https://github.com/cyber3pxVA/VAbitnet_i2
- ✓ Git installed and configured
- ✓ Python 3.12.10 installed
- ✓ Model file present: `models/bitnet_b1_58-large/ggml-model-i2_s.gguf` (1.19 GB)
- ✓ Python virtual environment exists at `../.venv/`

## What You Need to Run the Model

This is a **BitNet 1.58-bit** model that requires a custom-built inference engine. You have two options:

### Option 1: Build with MinGW (Recommended - No Admin Rights Required!)

**Perfect for VA workstations with limited permissions.**

1. **Download portable build tools** (one-time setup):
   ```powershell
   .\setup_mingw.ps1
   ```
   This downloads (~120 MB):
   - MinGW-w64 14.2.0 (GCC compiler)
   - CMake 3.30.5 (build system)
   - **No admin rights needed!**

2. **Build the project** (5-10 minutes):
   ```powershell
   .\build_mingw.ps1
   ```
   This compiles the BitNet-specific inference engine.

3. **Run inference**:
   ```powershell
   .\build_mingw\bin\llama-cli.exe -m models\bitnet_b1_58-large\ggml-model-i2_s.gguf -p "Hello, world!" -n 50
   ```

**Everything runs from your user directory - no system modifications!**

### Option 2: Build with Visual Studio (If You Have Admin Rights)

If you can install Visual Studio Build Tools:

1. **Install Visual Studio Build Tools**:
   - Download from: https://visualstudio.microsoft.com/downloads/
   - Select "Desktop development with C++"
   - Requires ~7 GB disk space and admin rights

2. **Install CMake**:
   ```powershell
   winget install --id Kitware.CMake -e
   ```

3. **Build the project**:
   ```bash
   # In Git Bash
   ./build_silent.sh
   ```

### Option 3: Use Pre-built Binaries (If Available)

Check if pre-built binaries exist in `build/bin/` or `build_mingw/bin/`. If they do, you can run directly:

```powershell
.\build_mingw\bin\llama-cli.exe -m models\bitnet_b1_58-large\ggml-model-i2_s.gguf -p "Hello, world!" -n 50
```

## Understanding the Model

- **Model**: Microsoft BitNet-b1.58-2B-4T
- **Size**: 2.4B parameters
- **Format**: 1.58-bit quantized (i2_s - 1.19 GB GGUF file)
- **Special**: Uses BitNet-specific quantization that standard GGUF loaders cannot handle
- **Purpose**: CPU-optimized inference for VA workstations

## Why Standard Python Libraries Don't Work

The `i2_s` format is a **BitNet-specific** quantization format (1.58-bit) that is not compatible with:
- Standard llama-cpp-python
- ctransformers
- transformers library
- Other generic GGUF loaders

You MUST use the BitNet-customized llama.cpp build included in this repository.

## Next Steps

1. Install build tools (Visual Studio or MinGW)
2. Install CMake
3. Run the build script
4. Test inference with the provided model

## Documentation

- Full installation guide: `INSTALL_VA_WORKSTATION.md`
- Deployment guide: `DEPLOYMENT.md`
- Development log: `DEVLOG.md`
- Performance testing: `test_performance.sh`

## Support

This is a proof-of-concept for running AI models on VA workstations without cloud services or special permissions.

---

**Ready to build?** Start with installing the build tools above.
