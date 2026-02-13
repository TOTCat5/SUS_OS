[BITS 32]
org 0x10000

start:

    cli
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov fs, ax
    mov gs, ax

    mov esp, 0x90000


    jmp OS_Begin

OS_Hang:
    jmp OS_Hang


%include "renderingVGA.s"

helloWorld: db "HelloWorld",0

OS_Begin:
    cli
    call clearScreenOS
    mov eax,helloWorld
    call printStringOS
    jmp OS_Hang


times ((0x10*512)-($$-$)) nop