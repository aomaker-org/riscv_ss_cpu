// jules/docker/riscv_example/src/cpp/hello_cpp.cpp
#include <iostream> // For std::cout, std::endl
#include <cstdio>   // For putchar (used in _putchar)

// Using similar logic as the C example for _putchar.
// For QEMU user mode, iostream and cstdio should work via syscall emulation.

#ifndef QEMU_USER_MODE_SIM
// Simple MMIO putchar for a hypothetical bare-metal target
#define MMIO_PUTCHAR_ADDR ((volatile unsigned char*)0xFFFF0000) // Example, adjust if needed
void _putchar(char character) {
    *MMIO_PUTCHAR_ADDR = character;
}
#else
// For QEMU user mode, stdio putchar (from cstdio) should work
void _putchar(char character) {
    putchar(character);
}
#endif

void print_string(const char* str) {
    while (*str) {
        _putchar(*str);
        str++;
    }
}

int main() {
    // Using C++ iostream for comparison, but also providing print_string
    // to show a more C-like bare-metal approach if iostream isn't available/desired.
    // std::cout << "Hello, World from C++ (RISC-V) using iostream!" << std::endl;

    print_string("Hello, World from C++ (RISC-V) using print_string!\\n");
    return 0; // Exit code 0
}
