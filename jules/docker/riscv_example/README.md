# RISC-V QEMU User Mode Docker Environment

This directory contains a Docker setup to run RISC-V 32-bit (RV32IM) programs using QEMU user-mode emulation.

## Files

-   `Dockerfile`: Defines the Docker image. It installs QEMU, the RISC-V GCC toolchain (for utilities, though the primary use here is QEMU), and copies a pre-compiled RISC-V binary.
-   `hello.bin`: A pre-compiled "Hello, World!" program for RV32IM. This binary is copied into the Docker image. (Originally compiled from `programs/hello.c` in the parent repository).

## Prerequisites

-   Docker installed and running on your system.

## Building the Docker Image

To build the Docker image, navigate to this directory (`jules/docker/riscv_example/`) in your terminal and run:

```bash
docker build -t riscv_qemu_example .
```

## Running the Example

Once the image is built, you can run the `hello.bin` program (which is the default command for the image):

```bash
docker run --rm riscv_qemu_example
```

### Expected Output

When you run the container, it will execute `qemu-riscv32 /app/hello.bin`. The `hello.bin` program is designed to print "Hello, World!" followed by a newline to standard output. So, the expected output is:

```
Hello, World!
```

## Purpose

This setup demonstrates:
1.  Cross-compilation of a C program for a RISC-V target (RV32IM).
2.  Execution of the RISC-V binary in an emulated environment using QEMU user mode.
3.  Packaging this environment within a Docker container for portability and ease of use.

This allows testing of RISC-V programs independently of specific hardware or complex HDL simulations.
