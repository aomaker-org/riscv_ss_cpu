# jules/docker/riscv_example/riscv32-unknown-elf.cmake
# CMake Toolchain file for cross-compiling to RISC-V 32-bit (rv32im)
# For use with riscv64-unknown-elf-gcc (which supports -march=rv32im -mabi=ilp32)

# Set the system name (CMake uses this to know we're cross-compiling)
set(CMAKE_SYSTEM_NAME Generic) # Or "Linux" if targeting Linux user-space for QEMU
set(CMAKE_SYSTEM_PROCESSOR riscv32)

# Specify the cross-compilers
# These should be found in the PATH within the Docker container
set(CMAKE_C_COMPILER riscv64-unknown-elf-gcc)
set(CMAKE_CXX_COMPILER riscv64-unknown-elf-g++)
set(CMAKE_ASM_COMPILER riscv64-unknown-elf-gcc) # For any .s files if needed

# Specify compiler flags for rv32im target
set(CMAKE_C_FLAGS "-march=rv32im -mabi=ilp32 -static" CACHE STRING "C compiler flags")
set(CMAKE_CXX_FLAGS "-march=rv32im -mabi=ilp32 -static" CACHE STRING "C++ compiler flags")
set(CMAKE_ASM_FLAGS "-march=rv32im -mabi=ilp32" CACHE STRING "ASM compiler flags")

# Set the find root path for cross-compiling (where to find libraries, headers for the target)
# For a bare-metal/generic target, this might point to the sysroot of the compiler.
# For QEMU user mode, this might be less critical if relying on host stdio.
# set(CMAKE_FIND_ROOT_PATH /path/to/riscv32/sysroot) # Adjust if a specific sysroot is used

# Don't run the try_compile stage for the compiler (can fail in cross-compilation)
set(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")

# Where to look for programs, libraries, includes - only in the sysroot.
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
