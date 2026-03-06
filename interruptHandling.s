
%macro outb 2
    mov dx,%1
    mov al,%2
    out dx,al
%endmacro
%macro inb 2
    mov dx,%1
    in %2,dx
%endmacro

struc idt_entry_t
    .isr_low: resw 1
    .kernel_cs: resw 1
    .reserved: resb 1
    .attributes: resb 1
    .isr_high: resw 1
endstruc

struc idtr_t
    .limit: resw 1
    .base: resd 1
endstruc

idtr:resb idtr_t_size

align 0x10
idt: resb idt_entry_t_size*256

align 0x1


exceptionMsg: db "an exception happened",0
exceptionHandler:
    println exceptionMsg

    .halt:
    cli
    hlt
    jmp .halt

    ret


%define PIC1_Port 0x20
%define PIC1_Data (PIC1_Port+1)
%define PIC2_Port 0xA0
%define PIC2_Data (PIC2_Port+1)
%define PIC_EndOfInterrupt 0x20

; the arg is the PIC command port
%macro acknowledgePIC 1
    mov dx,%+%1
    mov al,PIC_EndOfInterrupt
    out dx, al
%endmacro

%macro isr_err_stub 1
isr_stub_%+%1:
    call exceptionHandler
    add esp,4
    iret
%endmacro

%macro isr_no_err_stub 1
isr_stub_%+%1:
    call exceptionHandler
    iret
%endmacro

%include "inputKeyboard.s"


    isr_no_err_stub 0
    isr_no_err_stub 1
    isr_no_err_stub 2
    isr_no_err_stub 3
    isr_no_err_stub 4
    isr_no_err_stub 5
    isr_no_err_stub 6
    isr_no_err_stub 7
    isr_err_stub    8
    isr_no_err_stub 9
    isr_err_stub    10
    isr_err_stub    11
    isr_err_stub    12
    isr_err_stub    13
    isr_err_stub    14
    isr_no_err_stub 15
    isr_no_err_stub 16
    isr_err_stub    17
    isr_no_err_stub 18
    isr_no_err_stub 19
    isr_no_err_stub 20
    isr_no_err_stub 21
    isr_no_err_stub 22
    isr_no_err_stub 23
    isr_no_err_stub 24
    isr_no_err_stub 25
    isr_no_err_stub 26
    isr_no_err_stub 27
    isr_no_err_stub 28
    isr_no_err_stub 29
    isr_err_stub    30
    isr_no_err_stub 31
    isr_stub_32:
        pushad
        acknowledgePIC PIC1_Port
        popad
    iret
    ; keyboard interrupt
    isr_stub_33:
        pushad
        call handlePS2KeyboardInt
        acknowledgePIC PIC1_Port

        popad
    iret

%define MAX_ISR 34


global isr_stub_table
isr_stub_table:
%assign i 0 
%rep    (MAX_ISR)
    dd isr_stub_%+i ; use DQ instead if targeting 64-bit
%assign i i+1 
%endrep


; edx is the pointer to the isr,bl is the flags and finally bh is the entry index 
idtSetDescriptor:
    movzx ecx, bh                      ; index
    imul ecx, idt_entry_t_size         ; ecx = index * size
    add ecx, idt                       ; ecx = &idt[index]

    mov eax, edx
    mov word [ecx+idt_entry_t.isr_low], ax
    mov word [ecx+idt_entry_t.kernel_cs], 0x08
    mov byte [ecx+idt_entry_t.attributes], bl
    shr eax,16
    mov word [ecx+idt_entry_t.isr_high], ax
    mov byte [ecx+idt_entry_t.reserved], 0

    ret





; PIC for Programmable Interrupt Controller... I... Okay
initPIC:
    mov dx,PIC1_Port
    mov al,0x11
    out dx,al
    mov dx,PIC2_Port
    out dx,al

    outb 0x21, 0x20
    outb 0xA1, 0x28
       
    outb 0x21, 0x04
    outb 0xA1, 0x02

    outb 0x21, 0x01
    outb 0xA1, 0x01

    outb 0x21, 0xFC
    outb 0xA1, 0xFF

    ret




initInterruptHandling:
    ; fill IDTR
    mov dword [idtr+idtr_t.base], idt
    mov word [idtr+idtr_t.limit], idt_entry_t_size*256-1

    ; set each ISR
    xor ecx, ecx       ; vector index
.loop:
    cmp ecx, MAX_ISR
    jge .done

    pushad
    mov bl, 0x8E                 ; present, DPL=0, type=0xE (32-bit interrupt)
    mov bh, cl
    mov edx, [isr_stub_table + ecx*4]
    call idtSetDescriptor
    popad

    inc ecx
    jmp .loop
.done:

    lidt [idtr]      ; load IDT

    call initPIC

    sti              ; enable interrupts

    ret







            