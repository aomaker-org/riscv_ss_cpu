# jules/docker/riscv_example/CMakeLists.txt
cmake_minimum_required(VERSION 3.16) # Increased version for better Rust/Cargo support if needed later

project(RISCV_HelloWorld_MultiLang LANGUAGES C CXX ASM)

# Output directory for binaries
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib) # For static libraries if any

# Add subdirectories for each language
add_subdirectory(src/c)
add_subdirectory(src/cpp)
add_subdirectory(src/rust)

# A message to confirm configuration
message(STATUS "Configuring RISC-V Multi-Language HelloWorld project")
message(STATUS "Target System: ${CMAKE_SYSTEM_NAME}")
message(STATUS "Target Processor: ${CMAKE_SYSTEM_PROCESSOR}")
message(STATUS "C Compiler: ${CMAKE_C_COMPILER}")
message(STATUS "C++ Compiler: ${CMAKE_CXX_COMPILER}")
message(STATUS "Output Binaries will be in: ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
