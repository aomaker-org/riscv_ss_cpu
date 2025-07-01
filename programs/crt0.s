# programs/crt0.s
# Minimal startup code for RISC-V

.section .text.init
.global _start

_start:
    # Initialize stack pointer (sp)
    # The stack grows downwards.
    # Let's set the stack pointer to the end of our 64KB RAM (0x10000).
    # lui loads the upper 20 bits of the immediate into the destination register
    # and sets the lower 12 bits to 0.
    # So, lui sp, 0x10 will result in sp = 0x00010000.
    lui sp, 0x10

    # Call main function
    call main

    # If main returns (it shouldn't for this hello.c), loop indefinitely
    # This is also where a halt or exit syscall would go in a more complex system.
_hang:
    j _hang
