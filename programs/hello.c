// programs/hello.c
// Simple Hello World program for RISC-V

// Declaration for our simple putchar function (will be implemented via memory-mapped I/O)
void _putchar(char character);

void print_string(const char* str) {
    while (*str) {
        _putchar(*str);
        str++;
    }
}

int main() {
    print_string("Hello, World!\\n");
    // After printing, enter an infinite loop to halt the CPU.
    // In a real system, this might be an exit syscall.
    while(1);
    return 0;
}

// Basic putchar implementation:
// Write character to a predefined memory-mapped I/O address.
// This address will be simulated in VHDL to display the character.
#define MMIO_PUTCHAR_ADDR 0xFFFF0000 // Example address, can be adjusted

void _putchar(char character) {
    volatile char *out_char = (volatile char *)MMIO_PUTCHAR_ADDR;
    *out_char = character;
}
