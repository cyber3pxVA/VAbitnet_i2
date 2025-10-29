# VABitNet - Windows Ready Fork

> ⚠️ **DEVELOPMENT BUILD** - This is an experimental Windows build for development and testing purposes. The pre-built binaries and build process are functional but not officially supported for production use. Use at your own risk.

This is a Windows-friendly fork of [Microsoft BitNet](https://github.com/microsoft/BitNet) with pre-built binaries and streamlined setup for Windows 11.

## 🚀 Quick Start (No Build Tools Required!)

> **Note:** This build is for development/testing. Binary compatibility and stability may vary across different Windows 11 configurations.

For end users who just want to run inference:

```powershell
# Clone the repo
git clone --recursive https://github.com/cyber3pxVA/VABitNet.git
cd VABitNet

# Run quick setup
.\quick_setup.ps1

# Download and convert a model (first time only)
python setup_env.py -md models/bitnet_b1_58-large -q i2_s

# Run inference
python run_inference.py -m models/bitnet_b1_58-large/ggml-model-i2_s.gguf -p "Hello, world!" -cnv
```

That's it! No Visual Studio, no C++ build tools, no CMake required!

## 📦 Pre-Built Binaries

> ⚠️ **Development Binaries** - These executables are built for testing and may not work on all Windows 11 systems. They were compiled on Windows 11 build 10.0.26200.6901 with LLVM/Clang 21.1.4.

This fork includes pre-compiled Windows binaries in `build/bin/`:
- `llama-cli.exe` - Command-line inference
- `llama-quantize.exe` - Model quantization tool
- `llama-server.exe` - HTTP server for inference

These binaries are compiled with:
- MSVC with Clang-CL toolchain
- Optimized for x86_64 (Intel/AMD CPUs)
- Windows 11 compatible

## 🛠️ For Developers: Building from Source

If you want to rebuild the binaries or contribute:

1. **Install prerequisites:**
   - Visual Studio 2022 with C++ and Clang tools
   - CMake 3.22+
   - Git LFS

2. **Build:**
   ```powershell
   # Open Developer PowerShell for VS 2022
   cd VABitNet
   .\venv\Scripts\Activate.ps1
   .\build_windows.ps1
   ```

See [WINDOWS_BUILD_SETUP.md](WINDOWS_BUILD_SETUP.md) for detailed instructions.

## 📥 Models

Models are downloaded via Git LFS (not Hugging Face API):

```powershell
cd models
git clone https://huggingface.co/1bitLLM/bitnet_b1_58-large
```

Supported models:
- `1bitLLM/bitnet_b1_58-large` (0.7B params)
- `1bitLLM/bitnet_b1_58-3B` (3.3B params)
- `HF1BitLLM/Llama3-8B-1.58-100B-tokens` (8B params)
- Microsoft Official models

## 📝 Usage Examples

### Basic inference:
```powershell
python run_inference.py -m models/bitnet_b1_58-large/ggml-model-i2_s.gguf -p "Microsoft Corporation is" -n 100
```

### Chat mode:
```powershell
python run_inference.py -m models/bitnet_b1_58-large/ggml-model-i2_s.gguf -p "You are a helpful assistant" -cnv
```

### Server mode:
```powershell
python run_inference_server.py -m models/bitnet_b1_58-large/ggml-model-i2_s.gguf
```

## 🔧 What's Different from Original?

- ✅ Pre-built Windows binaries included
- ✅ Removed dev container dependencies
- ✅ Git LFS for model downloads
- ✅ Simplified setup scripts
- ✅ Windows 11 optimized
- ✅ No C++ build tools required for end users

## 📚 Original Documentation

For detailed information about BitNet architecture, performance benchmarks, and technical details, see the original [Microsoft BitNet README](https://github.com/microsoft/BitNet).

## 🙏 Credits

This fork is based on [Microsoft BitNet](https://github.com/microsoft/BitNet) and [llama.cpp](https://github.com/ggerganov/llama.cpp).

## 📄 License

MIT License - See LICENSE file for details
