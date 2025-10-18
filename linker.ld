ENTRY(_start)

SECTIONS
{
    .=0x7C00;        /* Load address (can be 0x7C00 for bootloaders) */

    .text :
    {
        *(.text)
    }

    .rodata :
    {
        *(.rodata)
    }

    .data :
    {
        *(.data)
    }

    .bss :
    {
        *(COMMON)
        *(.bss)
    }
}