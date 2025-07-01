# RISC-V QEMU Runner Docker Environment

This directory provides a Docker setup to run pre-compiled RISC-V 32-bit binaries on a non-RISC-V host system (e.g., amd64) using `qemu-user-static`.

## How it Works

The Docker image is based on a standard Ubuntu (amd64) image and installs the `qemu-user-static` package. This package allows the host kernel to execute binaries from different architectures (like RISC-V) by transparently invoking the appropriate static QEMU emulator. This is typically achieved through Linux's `binfmt_misc` mechanism, which `qemu-user-static` helps configure.

This means you don't need a full RISC-V operating system image to run RISC-V user-space programs; you can run them within this amd64-based Docker container.

## Files

-   `Dockerfile`: Defines the Docker image. It installs `qemu-user-static` and copies an example RISC-V binary (`hello_c_riscv32.bin`) into the image.
-   `hello_c_riscv32.bin`: An example pre-compiled "Hello, World!" program for RV32IM. This binary is copied into the Docker image and executed by default. (This specific binary was originally compiled from `programs/hello.c` in the parent repository using a RISC-V cross-compiler).

## Prerequisites

-   Docker installed and running on your system.
-   Your host system's kernel must support `binfmt_misc`. This is common on most Linux distributions.
-   For `qemu-user-static` to register its handlers correctly with `binfmt_misc` when the image is built or run, Docker might need privileged access or specific configurations. Often, this is handled by running a command once on the Docker host:
    ```bash
    docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
    ```
    This command registers QEMU handlers with the kernel. You typically only need to do this once per Docker host reboot, not for every container run. The `qemu-user-static` package within the image *may* attempt this, but doing it explicitly on the host is more reliable.

## Building the Docker Image

To build the Docker image, navigate to this directory (`jules/docker/riscv_qemu_runner/`) in your terminal and run:

```bash
docker build -t riscv_qemu_runner .
```

## Running an Example RISC-V Binary

The Dockerfile is set up to run the included `hello_c_riscv32.bin` by default.

1.  **Run the default example:**
    ```bash
    docker run --rm riscv_qemu_runner
    ```
    **Expected Output:**
    ```
    Hello, World from C (RISC-V)!
    ```

2.  **Running other RISC-V binaries:**
    You can use this image to run other statically linked RISC-V 32-bit binaries.
    -   **Option A: Copy binary into a custom image based on this one.**
        Modify the Dockerfile:
        ```dockerfile
        # ... (qemu-user-static setup) ...
        COPY your_riscv_program /app/your_program
        CMD ["/app/your_program"]
        ```
        Then build and run your custom image.

    -   **Option B: Mount a directory with binaries and run interactively.**
        ```bash
        # Assuming your_riscv_binary is on your host in the current directory
        docker run --rm -it -v "$(pwd)/your_riscv_binary:/app/your_riscv_binary" riscv_qemu_runner sh
        ```
        Inside the container shell:
        ```sh
        /app/your_riscv_binary
        ```

## Purpose

This setup demonstrates:
-   How to create a Docker environment on a non-RISC-V host (e.g., amd64) capable of executing RISC-V user-space binaries.
-   The use of `qemu-user-static` for transparent execution of foreign architecture binaries.

This is useful for testing RISC-V programs without needing access to physical RISC-V hardware or setting up a full RISC-V virtual machine. It complements a cross-compilation environment (like the one in `../riscv_cross_compile_env/`) by providing a way to run the compiled artifacts.
