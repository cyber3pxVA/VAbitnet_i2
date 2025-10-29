# Build script for VABitNet using MinGW (no admin rights required)

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "VABitNet - MinGW Build" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# Check if tools exist
$mingwDir = "$PSScriptRoot\tools\mingw64"
$cmakeDir = "$PSScriptRoot\tools\cmake-3.30.5-windows-x86_64"

if (-not (Test-Path "$mingwDir\bin\gcc.exe")) {
    Write-Host "✗ MinGW not found!" -ForegroundColor Red
    Write-Host "  Expected location: $mingwDir" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Run setup_mingw.ps1 first to download build tools." -ForegroundColor Yellow
    exit 1
}

if (-not (Test-Path "$cmakeDir\bin\cmake.exe")) {
    Write-Host "✗ CMake not found!" -ForegroundColor Red
    Write-Host "  Expected location: $cmakeDir" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Run setup_mingw.ps1 first to download build tools." -ForegroundColor Yellow
    exit 1
}

Write-Host "✓ MinGW found: $mingwDir" -ForegroundColor Green
Write-Host "✓ CMake found: $cmakeDir" -ForegroundColor Green
Write-Host ""

# Add tools to PATH for this session
$env:PATH = "$mingwDir\bin;$cmakeDir\bin;$env:PATH"

# Verify tools
Write-Host "Verifying build tools..." -ForegroundColor Yellow
try {
    $gccVersion = & gcc --version 2>&1 | Select-Object -First 1
    $cmakeVersion = & cmake --version 2>&1 | Select-Object -First 1
    Write-Host "  GCC: $gccVersion" -ForegroundColor Gray
    Write-Host "  CMake: $cmakeVersion" -ForegroundColor Gray
    Write-Host ""
} catch {
    Write-Host "✗ Tool verification failed" -ForegroundColor Red
    exit 1
}

# Build directory
$buildDir = "$PSScriptRoot\build_mingw"

# Configure CMake
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "Step 1: Configuring CMake" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

if (Test-Path $buildDir) {
    Write-Host "Build directory exists, cleaning..." -ForegroundColor Yellow
    Remove-Item $buildDir -Recurse -Force
}

Write-Host "Running CMake configuration..." -ForegroundColor Yellow
Write-Host "  Generator: MinGW Makefiles" -ForegroundColor Gray
Write-Host "  Build Type: Release" -ForegroundColor Gray
Write-Host "  BitNet TL2: ON" -ForegroundColor Gray
Write-Host ""

$cmakeArgs = @(
    "-B", $buildDir,
    "-G", "MinGW Makefiles",
    "-DCMAKE_BUILD_TYPE=Release",
    "-DBITNET_X86_TL2=ON",
    "-DCMAKE_C_COMPILER=gcc",
    "-DCMAKE_CXX_COMPILER=g++"
)

try {
    & cmake @cmakeArgs
    if ($LASTEXITCODE -ne 0) {
        throw "CMake configuration failed with exit code $LASTEXITCODE"
    }
    Write-Host ""
    Write-Host "✓ CMake configuration successful" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "✗ CMake configuration failed: $_" -ForegroundColor Red
    exit 1
}

# Build
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "Step 2: Building Project" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "This will take 5-10 minutes..." -ForegroundColor Yellow
Write-Host "Building with 4 parallel jobs..." -ForegroundColor Gray
Write-Host ""

try {
    & cmake --build $buildDir --config Release -j 4
    if ($LASTEXITCODE -ne 0) {
        throw "Build failed with exit code $LASTEXITCODE"
    }
    Write-Host ""
    Write-Host "✓ Build successful" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "✗ Build failed: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Check build_mingw\CMakeFiles\*.log for details" -ForegroundColor Yellow
    exit 1
}

# Verify binaries
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "Step 3: Verifying Binaries" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

$llamaCli = "$buildDir\bin\llama-cli.exe"
if (Test-Path $llamaCli) {
    Write-Host "✓ llama-cli.exe found" -ForegroundColor Green
    
    try {
        $version = & $llamaCli --version 2>&1
        Write-Host "  Version: $version" -ForegroundColor Gray
    } catch {
        Write-Host "  Warning: Could not get version" -ForegroundColor Yellow
    }
} else {
    Write-Host "✗ llama-cli.exe not found!" -ForegroundColor Red
    exit 1
}

# List all binaries
Write-Host ""
Write-Host "Built binaries in $buildDir\bin:" -ForegroundColor White
Get-ChildItem "$buildDir\bin\*.exe" | ForEach-Object {
    $size = [math]::Round($_.Length / 1MB, 2)
    Write-Host "  $($_.Name) ($size MB)" -ForegroundColor Gray
}

Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host "✓ Build Complete!" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Test inference with:" -ForegroundColor Yellow
Write-Host "  .\build_mingw\bin\llama-cli.exe -m models\bitnet_b1_58-large\ggml-model-i2_s.gguf -p `"Hello, world!`" -n 50" -ForegroundColor Cyan
Write-Host ""
Write-Host "Or use the optimized script:" -ForegroundColor Yellow
Write-Host "  bash run_optimized.sh `"Your prompt here`" 100" -ForegroundColor Cyan
Write-Host ""
