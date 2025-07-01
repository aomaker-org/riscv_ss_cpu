# jules/docker/riscv_example/src/c/CMakeLists.txt

# Define the executable and its source file
add_executable(hello_c hello_c.c)

# No special libraries needed for this simple example if relying on QEMU's syscalls
# for putchar or if we define _putchar to use a raw MMIO address.
# The -static flag in the toolchain file should handle linking necessary C runtime parts.

target_compile_definitions(hello_c PRIVATE QEMU_USER_MODE_SIM)

install(TARGETS hello_c DESTINATION bin) # Installs to <prefix>/bin

message(STATUS "Added C executable: hello_c")
