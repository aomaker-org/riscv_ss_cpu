# RISC-V Multi-Language Cross-Compilation Docker Environment

This directory contains a Docker setup to create a dedicated environment for **cross-compiling** applications written in C, C++, and Rust for a RISC-V 32-bit target (RV32IMAC).

The build process within Docker utilizes CMake as a meta-build system, which in turn invokes GCC for C/C++ and Cargo for Rust. The compiled binaries are placed in the `/app/bin/` directory within the image.

## Files

-   `Dockerfile`: Defines the Docker image. It installs:
    -   Ubuntu base system.
    -   `build-essential`, `cmake`, `ninja-build` for the build environment.
    -   `gcc-riscv64-unknown-elf`, `binutils-riscv64-unknown-elf` for C/C++ cross-compilation.
    -   `rustup` to install the Rust toolchain (stable) and the `riscv32imac-unknown-none-elf` target.
    -   `qemu-user` (useful for potential build-time checks, but not for primary execution within this image).
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

To build the Docker image, navigate to this directory (`jules/docker/riscv_cross_compile_env/`) in your terminal and run:

```bash
docker build -t riscv_cross_compiler .
```
This process might take some time, especially the first time, as it downloads the base image and installs all the toolchains.

## Using the Cross-Compilation Environment

This Docker image is designed to compile your RISC-V projects. The typical workflow involves mounting your source code into the container and then running the build process. The compiled binaries will be in the `/app/bin` directory within the container, which you can then copy out or access via a mounted output volume.

**Example Workflow (Building included "Hello World" examples):**

1.  **Build the image (as shown above):**
    ```bash
    docker build -t riscv_cross_compiler .
    ```

2.  **Run the build (if you want to re-build or build newly mounted sources):**
    If you want to use the image to build sources from your host machine, you can mount your project directory. For example, if your project is in `~/my_riscv_project` on your host and it's structured similarly to the `src/` directory here (with CMakeLists.txt etc.):
    ```bash
    # Create a directory on your host for the build output
    mkdir -p ~/my_riscv_project_build_output

    docker run --rm -v ~/my_riscv_project:/usr/src/app/src \
               -v ~/my_riscv_project_build_output:/usr/src/app/build_output \
               riscv_cross_compiler \
               sh -c "./build_all.sh && cp -r /app/bin/* /usr/src/app/build_output/"
    ```
    This command:
    - Mounts `~/my_riscv_project` to `/usr/src/app/src` inside the container.
    - Mounts `~/my_riscv_project_build_output` to `/usr/src/app/build_output` for easy access to binaries.
    - Runs the `build_all.sh` script (which builds into `/app/bin` inside the container based on CMAKE_INSTALL_PREFIX).
    - Then copies the contents of `/app/bin` to the mounted `/usr/src/app/build_output/`.

    *Note: The `build_all.sh` script in this example uses `CMAKE_INSTALL_PREFIX=/app`. So binaries are in `/app/bin`.*

3.  **Accessing Binaries:**
    The compiled RISC-V binaries (e.g., `hello_c`, `hello_cpp`, `hello_rust`) will be located in `/app/bin/` inside the Docker image. If you used volume mounting for output as in the example above, they will be on your host machine in the specified output directory.

    These binaries are now ready to be run on a RISC-V target or using a separate RISC-V QEMU execution environment (see `../riscv_qemu_runner/` for an example of such an environment).

## Default CMD

If you run the container without a command, it will drop you into a bash shell within the `/usr/src/app` directory and print a help message.
```bash
docker run --rm -it riscv_cross_compiler
```

This provides a flexible environment for your RISC-V cross-compilation needs.
