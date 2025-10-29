# MinGW Setup Script for VA Workstation
# Downloads portable MinGW and CMake (no admin rights required)

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "VABitNet - Portable Build Tools Setup" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# Create tools directory
$toolsDir = "$PSScriptRoot\tools"
if (-not (Test-Path $toolsDir)) {
    Write-Host "Creating tools directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $toolsDir | Out-Null
}

# MinGW-w64 Download
$mingwUrl = "https://github.com/niXman/mingw-builds-binaries/releases/download/14.2.0-rt_v12-rev0/x86_64-14.2.0-release-posix-seh-ucrt-rt_v12-rev0.7z"
$mingwZip = "$toolsDir\mingw64.7z"
$mingwDir = "$toolsDir\mingw64"

# CMake Download
$cmakeUrl = "https://github.com/Kitware/CMake/releases/download/v3.30.5/cmake-3.30.5-windows-x86_64.zip"
$cmakeZip = "$toolsDir\cmake.zip"
$cmakeDir = "$toolsDir\cmake-3.30.5-windows-x86_64"

Write-Host "This script will download:" -ForegroundColor White
Write-Host "  1. MinGW-w64 14.2.0 (~80 MB)" -ForegroundColor Gray
Write-Host "  2. CMake 3.30.5 (~40 MB)" -ForegroundColor Gray
Write-Host ""
Write-Host "Total download: ~120 MB" -ForegroundColor Yellow
Write-Host "No admin rights required!" -ForegroundColor Green
Write-Host ""

# Check if already downloaded
$mingwExists = Test-Path $mingwDir
$cmakeExists = Test-Path $cmakeDir

if ($mingwExists -and $cmakeExists) {
    Write-Host "✓ Build tools already installed!" -ForegroundColor Green
    Write-Host ""
    Write-Host "MinGW: $mingwDir" -ForegroundColor Gray
    Write-Host "CMake: $cmakeDir" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Ready to build! Run:" -ForegroundColor Yellow
    Write-Host "  .\build_mingw.ps1" -ForegroundColor Cyan
    exit 0
}

$response = Read-Host "Download build tools now? (y/n)"
if ($response -ne 'y') {
    Write-Host "Setup cancelled." -ForegroundColor Red
    exit 1
}

# Function to download with progress
function Download-File {
    param($url, $output)
    Write-Host "Downloading $(Split-Path $output -Leaf)..." -ForegroundColor Yellow
    
    try {
        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($url, $output)
        Write-Host "  ✓ Downloaded successfully" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "  ✗ Download failed: $_" -ForegroundColor Red
        return $false
    }
}

# Download MinGW
if (-not $mingwExists) {
    Write-Host ""
    Write-Host "=== MinGW-w64 ===" -ForegroundColor Cyan
    
    if (Download-File $mingwUrl $mingwZip) {
        Write-Host "Extracting MinGW..." -ForegroundColor Yellow
        
        # Check if 7-Zip is available
        $7zipPaths = @(
            "$env:ProgramFiles\7-Zip\7z.exe",
            "${env:ProgramFiles(x86)}\7-Zip\7z.exe",
            "C:\Program Files\7-Zip\7z.exe"
        )
        
        $7zip = $null
        foreach ($path in $7zipPaths) {
            if (Test-Path $path) {
                $7zip = $path
                break
            }
        }
        
        if ($7zip) {
            & $7zip x "-o$toolsDir" $mingwZip -y | Out-Null
            Write-Host "  ✓ Extracted successfully" -ForegroundColor Green
            Remove-Item $mingwZip
        }
        else {
            Write-Host "  ✗ 7-Zip not found!" -ForegroundColor Red
            Write-Host "  Please install 7-Zip or extract manually:" -ForegroundColor Yellow
            Write-Host "    $mingwZip" -ForegroundColor Gray
            Write-Host "    Extract to: $toolsDir" -ForegroundColor Gray
            exit 1
        }
    }
}

# Download CMake
if (-not $cmakeExists) {
    Write-Host ""
    Write-Host "=== CMake ===" -ForegroundColor Cyan
    
    if (Download-File $cmakeUrl $cmakeZip) {
        Write-Host "Extracting CMake..." -ForegroundColor Yellow
        
        try {
            Expand-Archive -Path $cmakeZip -DestinationPath $toolsDir -Force
            Write-Host "  ✓ Extracted successfully" -ForegroundColor Green
            Remove-Item $cmakeZip
        }
        catch {
            Write-Host "  ✗ Extraction failed: $_" -ForegroundColor Red
            Write-Host "  Please extract manually:" -ForegroundColor Yellow
            Write-Host "    $cmakeZip" -ForegroundColor Gray
            Write-Host "    Extract to: $toolsDir" -ForegroundColor Gray
            exit 1
        }
    }
}

Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host "✓ Build Tools Setup Complete!" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Tools installed at:" -ForegroundColor White
Write-Host "  MinGW: $mingwDir" -ForegroundColor Gray
Write-Host "  CMake: $cmakeDir" -ForegroundColor Gray
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Run: .\build_mingw.ps1" -ForegroundColor Cyan
Write-Host "  2. Wait 5-10 minutes for build" -ForegroundColor Cyan
Write-Host "  3. Test: .\build_mingw\bin\llama-cli.exe --version" -ForegroundColor Cyan
Write-Host ""
