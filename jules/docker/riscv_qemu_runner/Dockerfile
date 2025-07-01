# Dockerfile for RISC-V QEMU Runner Environment
# This image is intended to run pre-compiled RISC-V binaries on a non-RISC-V host (e.g., amd64)
# using qemu-user-static and binfmt_misc.

# Base image (standard amd64 Ubuntu)
FROM ubuntu:latest

# Arguments for non-interactive installation
ARG DEBIAN_FRONTEND=noninteractive

# Install qemu-user-static. This package typically handles
# the registration of binfmt_misc handlers for various architectures, including RISC-V.
# It also copies the static QEMU binaries (e.g., qemu-riscv32-static) into the image,
# which are used by the kernel to execute foreign architecture binaries.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    qemu-user-static \
    ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a directory for the application
WORKDIR /app

# Copy the pre-compiled RISC-V binary into the image.
# This binary (hello_c_riscv32.bin) is expected to be in the Docker build context.
COPY hello_c_riscv32.bin /app/hello_c_riscv32.bin

# Make it executable (though qemu-user-static usually doesn't strictly need the +x bit on the file itself,
# it's good practice). The execution is handled by the binfmt_misc mechanism calling the static QEMU binary.
RUN chmod +x /app/hello_c_riscv32.bin

# Command to execute the RISC-V binary.
# Because qemu-user-static and binfmt_misc are set up, we can often run it directly.
# QEMU will be invoked automatically by the kernel.
CMD ["/app/hello_c_riscv32.bin"]

# Alternatively, to be explicit (though usually not needed if binfmt is working):
# CMD ["qemu-riscv32-static", "/app/hello_c_riscv32.bin"]
