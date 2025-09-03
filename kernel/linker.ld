/* Source: https://github.com/Arnau478/ytos/blob/master/kernel/linker.ld */
ENTRY(_start)

PHDRS {
    text PT_LOAD FLAGS((1 << 0) | (1 << 2)); /* Execute + Read */
    rodata PT_LOAD FLAGS((1 << 2)); /* Read only */
    data PT_LOAD FLAGS((1 << 1) | (1 << 2)); /* Read + Write */
}

SECTIONS {
    . = 0xffffffff80000000;

    .text : ALIGN(4K) {
        *(.text .text.*)
    } :text

    . = ALIGN(4K);

    .rodata : ALIGN(4K) {
        *(.rodata .rodata.*)
    } :rodata

    . = ALIGN(4K);

    .data : ALIGN(4K) {
        *(.data .data.*)
        
        /* Place .bss right after .data in the same segment */
        *(.bss .bss.*)
        *(COMMON)
    } :data

    /DISCARD/ : {
        *(.eh_frame)
        *(.note .note.*)
        *(.dynamic .dynamic.*)
    }
}
