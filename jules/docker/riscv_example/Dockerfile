# Dockerfile for RISC-V QEMU User Mode Emulation

# Base image
FROM ubuntu:latest

# Arguments for non-interactive installation
ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies: QEMU for user mode, RISC-V GCC toolchain, and binutils
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    qemu-user \
    gcc-riscv64-unknown-elf \
    binutils-riscv64-unknown-elf \
    ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a directory for the application
WORKDIR /app

# Copy the pre-compiled RISC-V binary into the image
# This assumes hello.bin is in the context directory (e.g., programs/hello.bin relative to project root)
# For Docker build, the path needs to be relative to the Dockerfile's context.
# We will place hello.bin alongside the Dockerfile for simplicity during the conceptual build.
COPY hello.bin /app/hello.bin

# Command to execute the RISC-V binary using QEMU
# We compiled for rv32im (ilp32), so we use qemu-riscv32
CMD ["qemu-riscv32", "/app/hello.bin"]
