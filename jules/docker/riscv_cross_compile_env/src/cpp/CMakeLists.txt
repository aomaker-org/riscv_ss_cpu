# jules/docker/riscv_example/src/cpp/CMakeLists.txt

# Define the executable and its source file
add_executable(hello_cpp hello_cpp.cpp)

# No special libraries needed for this simple example if relying on QEMU's syscalls
# for iostream/putchar or if we define _putchar to use a raw MMIO address.
# The -static flag in the toolchain file should handle linking necessary C++/C runtime parts.

target_compile_definitions(hello_cpp PRIVATE QEMU_USER_MODE_SIM)

install(TARGETS hello_cpp DESTINATION bin) # Installs to <prefix>/bin

message(STATUS "Added C++ executable: hello_cpp")
