# Dockerfile for RISC-V Multi-Language Cross-Compilation Environment with QEMU

# Base image
FROM ubuntu:latest

# Arguments for non-interactive installation
ARG DEBIAN_FRONTEND=noninteractive

# Install base dependencies: QEMU for user mode, RISC-V GCC toolchain, CMake, build tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    build-essential \
    cmake \
    ninja-build \
    qemu-user \
    gcc-riscv64-unknown-elf \
    binutils-riscv64-unknown-elf \
    gdb-multiarch && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Rust using rustup and add the RISC-V target
# Install rustup to a location accessible by subsequent RUN commands (e.g. /opt/rust or /usr/local)
ENV RUSTUP_HOME=/opt/rust
ENV CARGO_HOME=/opt/rust
ENV PATH=/opt/rust/bin:$PATH

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
    sh -s -- -y --no-modify-path --default-toolchain stable --profile minimal && \
    chmod -R a+w $RUSTUP_HOME && \
    rustup target add riscv32imac-unknown-none-elf

# Create a working directory for the application source and build
WORKDIR /usr/src/app

# Copy the CMake toolchain file, build script, root CMakeLists.txt, and the src directory
COPY riscv32-unknown-elf.cmake ./
COPY build_all.sh ./
COPY CMakeLists.txt ./
COPY src ./src/

# Make the build script executable
RUN chmod +x build_all.sh

# Run the build script to compile all projects
# This will create binaries in /usr/src/app/build/bin and install them to /app/bin
RUN ./build_all.sh

# Set up a directory for the final application binaries (as defined by CMAKE_INSTALL_PREFIX)
WORKDIR /usr/src/app # Default to the source/build directory

# Default command: Provide a shell or a help message.
CMD ["sh", "-c", "echo 'RISC-V Cross-Compilation Environment.'; echo 'Binaries are built and installed to /app/bin within the image.'; echo 'Mount your source code to /usr/src/app and run ./build_all.sh to build.'; echo 'Or use this image as a base for further operations. Starting shell...'; /bin/bash"]
