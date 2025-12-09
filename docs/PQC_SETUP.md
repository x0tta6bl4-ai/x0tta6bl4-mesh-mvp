# PQC Setup Guide - Action A4
**Status:** Phase 1 - PoC Development  
**Date:** 2025-11-07  
**Updated:** 2025-11-07

---

## 📋 Prerequisites

### System Requirements
- **OS:** Linux (Ubuntu 20.04+, Debian 11+, Fedora 35+) or macOS 12+
- **Python:** 3.9 or higher
- **Build Tools:**
  - CMake 3.10+
  - Ninja (recommended) or Make
  - GCC 7+ or Clang 10+
  - Git

### Install Build Dependencies

#### Ubuntu/Debian
```bash
sudo apt-get update
sudo apt-get install -y \
    git cmake ninja-build \
    gcc g++ \
    python3 python3-pip python3-dev \
    libssl-dev
```

#### Fedora/RHEL
```bash
sudo dnf install -y \
    git cmake ninja-build \
    gcc gcc-c++ \
    python3 python3-pip python3-devel \
    openssl-devel
```

#### macOS
```bash
brew install cmake ninja gcc python3
```

---

## 🔧 Installation: liboqs (Open Quantum Safe)

### Option 1: Build from Source (Recommended)

#### Step 1: Clone Repository
```bash
cd /tmp
git clone -b main https://github.com/open-quantum-safe/liboqs.git
cd liboqs
```

#### Step 2: Configure Build
```bash
mkdir build && cd build

# Configure with Ninja
cmake -GNinja \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DBUILD_SHARED_LIBS=ON \
    ..

# Alternative: Configure with Make
cmake \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DBUILD_SHARED_LIBS=ON \
    ..
```

#### Step 3: Build
```bash
# With Ninja (faster)
ninja

# Or with Make
make -j$(nproc)
```

#### Step 4: Install
```bash
sudo ninja install
# Or: sudo make install

# Update library cache (Linux only)
sudo ldconfig
```

#### Step 5: Verify Installation
```bash
# Check if liboqs is installed
ldconfig -p | grep oqs

# Should show: liboqs.so.0 (libc6,x86-64) => /usr/local/lib/liboqs.so.0
```

### Option 2: Using Docker (Quick Start)

```bash
# Pull pre-built image
docker pull openquantumsafe/liboqs-python:latest

# Run container
docker run -it --rm \
    -v $(pwd):/workspace \
    openquantumsafe/liboqs-python:latest \
    bash

# Inside container, you can run Python with liboqs
python3 -c "import oqs; print(oqs.__version__)"
```

---

## 🐍 Python Bindings: liboqs-python

### Install liboqs-python

#### Option 1: From PyPI (if available)
```bash
pip install liboqs-python
```

#### Option 2: From Source
```bash
cd /tmp
git clone https://github.com/open-quantum-safe/liboqs-python.git
cd liboqs-python

# Install
pip install .

# Or for development
pip install -e .
```

### Verify Python Installation
```bash
python3 -c "import oqs; print('✅ liboqs-python installed')"
python3 -c "import oqs; print(f'Version: {oqs.__version__}')"
```

---

## ✅ Verification Tests

### Quick Test Script

Create `test_pqc_setup.py`:
```python
#!/usr/bin/env python3
"""Quick verification of PQC setup"""

import sys

# Test 1: Import oqs
try:
    import oqs
    print("✅ oqs module imported successfully")
    print(f"   Version: {getattr(oqs, '__version__', 'unknown')}")
except ImportError as e:
    print(f"❌ Failed to import oqs: {e}")
    sys.exit(1)

# Test 2: Check Kyber768
try:
    kem = oqs.KeyEncapsulation("Kyber768")
    print("✅ Kyber768 available")
    
    # Quick test
    public_key = kem.generate_keypair()
    print(f"   Public key size: {len(public_key)} bytes")
except Exception as e:
    print(f"❌ Kyber768 error: {e}")
    sys.exit(1)

# Test 3: Check Dilithium3
try:
    sig = oqs.Signature("Dilithium3")
    print("✅ Dilithium3 available")
    
    # Quick test
    verify_key = sig.generate_keypair()
    print(f"   Verify key size: {len(verify_key)} bytes")
except Exception as e:
    print(f"❌ Dilithium3 error: {e}")
    sys.exit(1)

# Test 4: Full Kyber768 roundtrip
try:
    kem = oqs.KeyEncapsulation("Kyber768")
    public_key = kem.generate_keypair()
    ciphertext, shared_secret_1 = kem.encap_secret(public_key)
    secret_key = kem.export_secret_key()
    
    kem2 = oqs.KeyEncapsulation("Kyber768")
    kem2.import_secret_key(secret_key)
    shared_secret_2 = kem2.decap_secret(ciphertext)
    
    assert shared_secret_1 == shared_secret_2
    print("✅ Kyber768 roundtrip successful")
except Exception as e:
    print(f"❌ Kyber768 roundtrip error: {e}")
    sys.exit(1)

# Test 5: Full Dilithium3 roundtrip
try:
    sig = oqs.Signature("Dilithium3")
    verify_key = sig.generate_keypair()
    signing_key = sig.export_secret_key()
    
    message = b"Test message"
    signature = sig.sign(message)
    
    is_valid = sig.verify(message, signature, verify_key)
    assert is_valid is True
    print("✅ Dilithium3 sign-verify successful")
except Exception as e:
    print(f"❌ Dilithium3 sign-verify error: {e}")
    sys.exit(1)

print("\n" + "="*60)
print("🎉 ALL TESTS PASSED - PQC Setup Complete!")
print("="*60)
```

Run test:
```bash
python3 test_pqc_setup.py
```

Expected output:
```
✅ oqs module imported successfully
   Version: 0.8.0
✅ Kyber768 available
   Public key size: 1184 bytes
✅ Dilithium3 available
   Verify key size: 1952 bytes
✅ Kyber768 roundtrip successful
✅ Dilithium3 sign-verify successful

============================================================
🎉 ALL TESTS PASSED - PQC Setup Complete!
============================================================
```

---

## 🔬 Run Action A4 PoC

### Test PQC Primitives Implementation

```bash
cd /mnt/AC74CC2974CBF3DC/x0tta6bl4_paradox_zone

# Run PoC script
python3 crypto/pqc_primitives.py
```

Expected output:
```
============================================================
🔐 PQC Primitives Status - Action A4
============================================================
liboqs Available: ✅
liboqs Version: 0.8.0
Kyber768: ✅
Dilithium3: ✅
============================================================

🔬 Running PoC tests...

--- Kyber768 Key Exchange ---
✅ Keygen: public=1184 bytes, secret=2400 bytes
✅ Encapsulate: ct=1088 bytes, secret=32 bytes
✅ Decapsulate: secret=32 bytes
✅ Shared secrets match!

--- Dilithium3 Digital Signatures ---
✅ Keygen: verify=1952 bytes, signing=4000 bytes
✅ Sign: signature=3293 bytes
✅ Verify: True
✅ Signature valid!

📊 Running benchmarks (10 iterations)...

Kyber768 Performance:
  Keygen: 2.45ms (target: <50ms)
  Encapsulate: 0.89ms (target: <10ms)
  Decapsulate: 0.91ms (target: <10ms)

Dilithium3 Performance:
  Keygen: 3.12ms (target: <50ms)
  Sign: 8.76ms (target: <100ms)
  Verify: 2.34ms (target: <50ms)

✅ PoC Complete!
```

### Run Unit Tests

```bash
# Run PQC unit tests
pytest tests/test_pqc_kyber_dilithium.py -v

# With coverage
pytest tests/test_pqc_kyber_dilithium.py --cov=crypto.pqc_primitives --cov-report=term-missing
```

---

## 🐛 Troubleshooting

### Issue: `ImportError: liboqs.so.0: cannot open shared object file`

**Solution:**
```bash
# Update library cache
sudo ldconfig

# Or add to LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

# Make permanent (add to ~/.bashrc)
echo 'export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH' >> ~/.bashrc
source ~/.bashrc
```

### Issue: `ModuleNotFoundError: No module named 'oqs'`

**Solution:**
```bash
# Reinstall liboqs-python
pip uninstall liboqs-python -y
pip install liboqs-python

# Or install from source
cd /tmp/liboqs-python
pip install .
```

### Issue: CMake configuration fails

**Solution:**
```bash
# Install missing dependencies
sudo apt-get install -y cmake ninja-build gcc g++

# Clear build cache
cd liboqs
rm -rf build
mkdir build && cd build
cmake -GNinja ..
```

### Issue: Python.h not found during build

**Solution:**
```bash
# Install Python development headers
sudo apt-get install -y python3-dev

# Or on Fedora
sudo dnf install -y python3-devel
```

### Issue: OpenSSL FFI conflicts

**Status:** Under investigation (Week 1-2 objective)

**Temporary workaround:**
1. Use Docker container (isolated environment)
2. Or use separate Python virtual environment

```bash
python3 -m venv pqc_env
source pqc_env/bin/activate
pip install liboqs-python
```

---

## 📚 Additional Resources

### Official Documentation
- **liboqs:** https://github.com/open-quantum-safe/liboqs
- **liboqs-python:** https://github.com/open-quantum-safe/liboqs-python
- **NIST PQC:** https://csrc.nist.gov/projects/post-quantum-cryptography

### Algorithm Specifications
- **Kyber:** https://pq-crystals.org/kyber/
- **Dilithium:** https://pq-crystals.org/dilithium/
- **NIST Standards:** https://csrc.nist.gov/Projects/post-quantum-cryptography/selected-algorithms-2022

### Docker Images
- **liboqs-python:** `openquantumsafe/liboqs-python:latest`
- **Custom builds:** See `Dockerfile` in project root

---

## ✅ Checklist: Setup Complete

- [ ] Build tools installed (CMake, Ninja, GCC)
- [ ] liboqs compiled and installed
- [ ] Python bindings installed (`import oqs` works)
- [ ] Kyber768 available and tested
- [ ] Dilithium3 available and tested
- [ ] PoC script runs successfully
- [ ] Unit tests pass
- [ ] Performance benchmarks meet targets

---

## 📞 Support

**Issues with setup?**
- GitHub: Open issue with label `action-a4`, `pqc`, `setup`
- Discord: #dev channel
- Documentation: See `docs/ru/reality-map.md`

---

**Last Updated:** 2025-11-07  
**Action A4 Phase:** Week 1-2 (PoC Development)  
**Next Milestone:** Week 3-4 (Full Implementation)
