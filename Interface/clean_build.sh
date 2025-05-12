#!/bin/bash
echo "[i] Checking if virtual environment exists"
if [ ! -d "../../venv" ]; then
    echo "[i] Virtual environment does not exist, creating"
    python3 -m venv ../../venv
fi
echo "[i] Activating virtual environment"
source ../../venv/bin/activate
echo "[i] Installing conan"
pip install conan
conan profile detect
echo "[i] Cleaning build directory"
mkdir -p build
rm -rf build/*
cd build
echo "[i] Installing conan dependencies"
cp ../conanfile.txt .
conan install . --build=missing -s build_type=Release -g CMakeToolchain
echo "[i] Genrating SBOM"
conan config install https://github.com/conan-io/conan-extensions.git
pip install 'cyclonedx-python-lib>=5.0.0,<6'
conan sbom:cyclonedx --format 1.4_json . > sbom.cyclonedx.json
echo "[i] CMake compiling"
cmake .. -DCMAKE_TOOLCHAIN_FILE=build/conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=clang++
echo "[i] CMake building"
cmake --build .

