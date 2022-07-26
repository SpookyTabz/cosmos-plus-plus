ENTRY (loader)
OUTPUT_FORMAT(elf32-i386)
OUTPUT_ARCH(i386)

SECTIONS
{
    . = 0x0100000;

    .text :
    {
        *(.multiboot)
        *(.text)
        *(.rodata)
    }

    .data :
    {
        *(.data)
    }

    .bbs :
    {
        *(.bbs)
    }

    /DISCARD/ :
    {
        *(.fini_array*)
        *(.comment)
    }
}