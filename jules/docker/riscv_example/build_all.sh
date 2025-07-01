#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status.

echo "---- Sourcing Cargo environment ----"
# Source Cargo environment. This path might differ if rustup was installed by a different user (e.g. root)
# If installed system-wide or for a specific user in Docker, adjust as needed.
# Common location for user install:
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
elif [ -f "/opt/rust/.cargo/env" ]; then # Example if installed to /opt/rust
    source "/opt/rust/.cargo/env"
elif [ -f "/usr/local/cargo/env" ]; then # Another possible location
    source "/usr/local/cargo/env"
else
    echo "Warning: Could not find .cargo/env to source. Assuming rustc/cargo are in PATH."
fi

echo "---- Configuring CMake ----"
# Configure CMake, pointing to the toolchain file.
# Build files will be placed in the 'build' subdirectory.
cmake -B build -S . -DCMAKE_TOOLCHAIN_FILE=riscv32-unknown-elf.cmake -DCMAKE_INSTALL_PREFIX=/app

echo "---- Building with CMake ----"
# Build the projects using CMake. This will invoke GCC for C/C++ and Cargo for Rust.
cmake --build build --verbose

echo "---- Installing with CMake ----"
# Install the built binaries to CMAKE_INSTALL_PREFIX (e.g., /app/bin)
cmake --install build

echo "---- Build and Install Complete ----"
echo "Binaries should be available in /app/bin:"
ls -l /app/bin || echo "/app/bin not found or empty."

echo "---- To run an example (e.g., hello_c): ----"
echo "qemu-riscv32 /app/bin/hello_c"
echo "---- To run Rust example (hello_rust): ----"
echo "qemu-riscv32 /app/bin/hello_rust"
