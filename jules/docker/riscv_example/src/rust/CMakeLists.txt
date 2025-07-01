# jules/docker/riscv_example/src/rust/CMakeLists.txt
include(ExternalProject)

# Define the RISC-V target for Rust.
# For a 32-bit system without an OS, and with integer and multiplication/division support,
# riscv32im-unknown-none-elf could be a target.
# However, for QEMU user mode emulating Linux syscalls, a GNU target might be more appropriate
# if we want to use std, e.g., riscv32gc-unknown-linux-gnu.
# Given our C/C++ setup uses -march=rv32im and aims for static linking for a generic system,
# let's try to align Rust similarly.
# We'll use riscv32imac-unknown-none-elf, which is common for no_std development but can also work
# if we are careful with what std features we use or if QEMU provides enough.
# The 'a' (atomic) and 'c' (compressed) are often part of general-purpose targets.
set(RUST_TARGET "riscv32imac-unknown-none-elf")
# If the above target causes issues with std::println, we might need to:
# 1. Switch to a no_std Rust `main.rs` and implement a custom print.
# 2. Or, use a Linux GNU target for Rust (e.g., riscv32gc-unknown-linux-gnu)
#    and adjust C/C++ to match if we want consistent std lib behavior.
# For now, let's assume the Dockerfile will install this target via rustup.

# Find Cargo
find_package(Cargo QUIET)
if(NOT Cargo_FOUND)
    message(FATAL_ERROR "Cargo not found. Please ensure Rust and Cargo are installed and in PATH.")
endif()

# Get the path to the cargo executable
set(CARGO_EXECUTABLE ${Cargo_CARGO_EXECUTABLE})

set(CARGO_BUILD_FLAGS "--release") # Build in release mode

# Define the ExternalProject for building the Rust code
ExternalProject_Add(hello_rust_cargo_build
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/hello_rust_cargo
    SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR} # Location of Cargo.toml and src/main.rs
    # Download step (not needed as source is local)
    # Update/Patch step (not needed)
    CONFIGURE_COMMAND "" # No configure step for cargo build usually
    BUILD_COMMAND ${CARGO_EXECUTABLE} build --target=${RUST_TARGET} ${CARGO_BUILD_FLAGS}
    INSTALL_COMMAND "" # We will copy the binary manually after build
    BUILD_BYPRODUCTS <BINARY_DIR>/target/${RUST_TARGET}/release/hello_rust # Tell CMake where to find the output
    # Test step (not needed for this example)
)

# After the external project builds, copy the executable to CMake's binary dir
# This makes it available to 'install' command and for CPack if used.
set(RUST_BINARY_SOURCE_PATH ${CMAKE_CURRENT_BINARY_DIR}/hello_rust_cargo/build/target/${RUST_TARGET}/release/hello_rust)
set(RUST_BINARY_DEST_PATH ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/hello_rust)

add_custom_command(
    OUTPUT ${RUST_BINARY_DEST_PATH}
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${RUST_BINARY_SOURCE_PATH} ${RUST_BINARY_DEST_PATH}
    DEPENDS hello_rust_cargo_build # Ensure this runs after cargo build
    COMMENT "Copying Rust binary hello_rust to ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}"
)

# Create a custom target that depends on the copied binary
add_custom_target(hello_rust ALL DEPENDS ${RUST_BINARY_DEST_PATH})

install(FILES ${RUST_BINARY_DEST_PATH} DESTINATION bin)

message(STATUS "Added Rust executable: hello_rust (via Cargo external project)")
