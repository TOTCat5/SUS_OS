[BITS 32]
org 0x10000

; code
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


%include "renderingVGA.s"

OS_Begin:
    call clearScreenOS

    mov esi,successMsg
    mov ecx,11
    call printStringOS
    
    call endLineOS

    OS_Loop:
        hlt
        jmp OS_Loop


; variables
helloWorld: db "Hello World ! ",

cursorPos: dd 0

successMsg: db "OS Loaded !",0

logoMsg: db ""

times ((0x10*512)-($$-$)) db 0 ; padding