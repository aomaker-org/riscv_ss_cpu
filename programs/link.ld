/* programs/link.ld - Minimal linker script for hello.c */

ENTRY(_start) /* Define the entry point of the program */

MEMORY
{
    /* Define memory regions.
       These need to align with the simulated hardware memory map.
       Assuming a simple model:
       - RAM starts at 0x00000000, size 64KB (for .text, .data, .bss, stack)
       - MMIO for putchar is at 0xFFFF0000 (as defined in hello.c)
         This MMIO region is not directly managed by the linker for program sections,
         but knowing its location is important for the overall memory map.
    */
    RAM (rwx) : ORIGIN = 0x00000000, LENGTH = 64K /* 0x10000 bytes */
    /* MMIO (rw): ORIGIN = 0xFFFF0000, LENGTH = 4  (conceptual, not for sections) */
}

SECTIONS
{
    /* Place the .text.init section (our _start code) first at the beginning of RAM */
    .text.init :
    {
        KEEP(*(.text.init)) /* Keep all code from .text.init sections */
    } > RAM

    /* Then place the rest of the .text section (compiled C code) */
    .text :
    {
        *(.text .text.*)
    } > RAM

    /* Read-only data */
    .rodata :
    {
        *(.rodata .rodata.*)
    } > RAM

    /* Read-write data */
    .data :
    {
        *(.data .data.*)
    } > RAM

    /* Uninitialized data (zeroed out at startup by crt0 if it were more complex) */
    .bss :
    {
        *(.bss .bss.* COMMON)
    } > RAM

    /* End of sections that go into RAM. Stack will grow downwards from end of RAM. */
    _end = .; /* Define a symbol for the end of the loaded program sections */
}
