
struc idt_entry_t
    .isr_low: resw 1
    .kernel_cs: resw 1
    .reserved: resb 1
    .attributes: resb 1
    .isr_high: resw 1
endstruc

struc idr_t
    .limit: resw 1
    .base: resd 1
endstruc

idr:resb idr_t_size

align 0x10
idt: resb idt_entry_t_size*256


initInterruptHandling:

            