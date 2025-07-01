# RISC-V Multi-Language Cross-Compilation & QEMU Docker Environment

This directory contains a Docker setup to:
1.  Cross-compile "Hello World" applications written in C, C++, and Rust for a RISC-V 32-bit target (RV32IMAC).
2.  Run these compiled RISC-V binaries using QEMU user-mode emulation.

The build process within Docker utilizes CMake as a meta-build system, which in turn invokes GCC for C/C++ and Cargo for Rust.

## Files

-   `Dockerfile`: Defines the Docker image. It installs:
    -   Ubuntu base system.
    -   `build-essential`, `cmake`, `ninja-build` for the build environment.
    -   `gcc-riscv64-unknown-elf`, `binutils-riscv64-unknown-elf` for C/C++ cross-compilation.
    -   `rustup` to install the Rust toolchain (stable) and the `riscv32imac-unknown-none-elf` target.
    -   `qemu-user` for `qemu-riscv32` user-mode emulation.
-   `riscv32-unknown-elf.cmake`: CMake toolchain file for configuring cross-compilation for the RISC-V target.
-   `CMakeLists.txt`: The root CMake file that orchestrates the build for all languages.
-   `src/`: Contains subdirectories for each language with their "Hello World" source code and respective `CMakeLists.txt` files.
    -   `src/c/hello_c.c` & `src/c/CMakeLists.txt`
    -   `src/cpp/hello_cpp.cpp` & `src/cpp/CMakeLists.txt`
    -   `src/rust/main.rs`, `src/rust/Cargo.toml` & `src/rust/CMakeLists.txt`
-   `build_all.sh`: A shell script executed during Docker image build. It runs CMake to configure, build, and install all the projects. Binaries are installed to `/app/bin/` inside the image.

## Prerequisites

-   Docker installed and running on your system.

## Building the Docker Image

To build the Docker image, navigate to this directory (`jules/docker/riscv_example/`) in your terminal and run:

```bash
docker build -t riscv_multilang_qemu_example .
```
This process might take some time, especially the first time, as it downloads the base image and installs all the toolchains.

## Running the Examples

Once the image is built, you can run the container. The default command will list the available compiled binaries and provide instructions on how to run them.

```bash
docker run --rm riscv_multilang_qemu_example
```

This will output something like:
```
Available RISC-V binaries in /app/bin:
hello_c
hello_cpp
hello_rust

To run an example (e.g., hello_c):
  qemu-riscv32 /app/bin/hello_c
To run Rust example (hello_rust):
  qemu-riscv32 /app/bin/hello_rust
```

To run a specific "Hello World" program, you can override the default command or execute it inside a running container:

**Option 1: Override CMD**
```bash
# Run the C example
docker run --rm riscv_multilang_qemu_example qemu-riscv32 /app/bin/hello_c

# Run the C++ example
docker run --rm riscv_multilang_qemu_example qemu-riscv32 /app/bin/hello_cpp

# Run the Rust example
docker run --rm riscv_multilang_qemu_example qemu-riscv32 /app/bin/hello_rust
```

**Option 2: Interactive Shell**
```bash
docker run --rm -it riscv_multilang_qemu_example sh
```
Then, inside the container's shell:
```sh
ls /app/bin
# Output: hello_c  hello_cpp  hello_rust

qemu-riscv32 /app/bin/hello_c
# Expected Output: Hello, World from C (RISC-V)!

qemu-riscv32 /app/bin/hello_cpp
# Expected Output: Hello, World from C++ (RISC-V) using print_string!

qemu-riscv32 /app/bin/hello_rust
# Expected Output: Hello, World from Rust (RISC-V)!
```

## Purpose

This setup demonstrates:
1.  Setting up a Dockerized cross-compilation environment for C, C++, and Rust targeting RISC-V.
2.  Using CMake to manage a multi-language build, including integration with Cargo for Rust.
3.  Executing the compiled RISC-V binaries in an emulated environment using QEMU user mode.
4.  Providing a self-contained environment for RISC-V software development and testing.
