// jules/docker/riscv_example/src/c/hello_c.c
#include <stdio.h>

// Minimal putchar for bare-metal RISC-V QEMU user mode.
// QEMU user mode often maps UART or a simple console device.
// For simplicity, we rely on stdio, which QEMU user mode
// often redirects to the host's stdio via syscall emulation.
// If this were truly bare-metal for specific hardware,
// we'd write to a memory-mapped UART register.

#ifndef QEMU_USER_MODE_SIM
// Simple MMIO putchar for a hypothetical bare-metal target
#define MMIO_PUTCHAR_ADDR ((volatile unsigned char*)0xFFFF0000) // Example, adjust if needed
void _putchar(char character) {
    *MMIO_PUTCHAR_ADDR = character;
}
#else
// For QEMU user mode, stdio putchar should work via syscall emulation
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
    print_string("Hello, World from C (RISC-V)!\\n");
    return 0; // Exit code 0
}
