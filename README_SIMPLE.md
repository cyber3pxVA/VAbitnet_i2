# 🚀 VA BitNet - ONE COMMAND SETUP

## TL;DR - Just Run This Thing

```bash
git clone https://github.com/cyber3pxVA/VAbitnet_i2.git
cd VAbitnet_i2/VAbitnet_i2
bash ZERO_HASSLE_SETUP.sh
```

Wait 15-20 minutes. Done.

---

## What It Does

**ZERO_HASSLE_SETUP.sh** handles EVERYTHING:

1. ✅ Downloads MinGW compiler (80 MB)
2. ✅ Extracts MinGW (350 MB installed)
3. ✅ Downloads/fixes CMake if needed
4. ✅ Initializes git submodules  
5. ✅ Builds entire project (35+ executables)

**NO manual steps. NO extraction. NO hassle.**

---

## After Setup

Run inference:
```bash
./run_optimized.sh "Who is Jimi Hendrix?" 150
```

More examples:
```bash
./run_optimized.sh "What is the Department of Veterans Affairs?" 200
./run_optimized.sh "Explain machine learning in simple terms" 150
./run_optimized.sh "Write code to reverse a string in Python" 200
```

---

## Requirements

- Windows 10/11
- Git (available in VHA Software Center)
- Python (already on VA workstations)
- 2 GB disk space
- 15-20 minutes for initial setup

**NO admin rights needed**

---

## Troubleshooting

### "Command not found"
Use Git Bash, not CMD or PowerShell:
```bash
bash ZERO_HASSLE_SETUP.sh
```

### "py7zr module not found"
The script installs it automatically. If it fails:
```bash
python -m pip install py7zr
bash ZERO_HASSLE_SETUP.sh
```

### "Build failed"
Check the logs:
```bash
tail -50 cmake_build.log
```

Most common issue: Submodules not initialized. Fix:
```bash
git submodule update --init --recursive
bash ZERO_HASSLE_SETUP.sh
```

---

## What's Automated

| Task | Status | Time |
|------|--------|------|
| MinGW download | ✅ Automated | 2-3 min |
| MinGW extraction | ✅ Automated | 1-2 min |
| CMake download | ✅ Automated (if needed) | 1 min |
| Submodule init | ✅ Automated | 1-2 min |
| Project build | ✅ Automated | 5-10 min |
| **TOTAL** | **✅ ONE COMMAND** | **15-20 min** |

---

## Performance

**VA Workstation (Intel i7-1265U):**
- Setup: 15-20 minutes (one time)
- Inference: ~7 tokens/second
- 150 tokens: ~20-25 seconds

---

## For Developers

### Manual Build (if you already have MinGW)
```bash
bash build_fresh.sh
```

### Run Tests
```bash
bash test_performance.sh
```

### Clean Rebuild
```bash
rm -rf build_mingw
bash build_fresh.sh
```

---

## VA Compliance

✅ No admin rights  
✅ No system changes  
✅ Runs offline after setup  
✅ No cloud services  
✅ Standard VHA tools only  

---

## Summary

**One command. One script. Zero hassle.**

```bash
bash ZERO_HASSLE_SETUP.sh
```

That's it. Come back in 15 minutes and run your local AI.

🚀
