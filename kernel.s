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

OS_Hang:
    jmp OS_Hang


%include "renderingVGA.s"

OS_Begin:
    cli
    call clearScreenOS
    mov eax,helloWorld
    call printC_StringOS
    
    ; mov bx,[cursorPos]
    ; call setCursorPos


    OS_Loop:

    jmp OS_Loop


; variables
helloWorld: db "Hello World !",0

cursorPos: dw 0

times ((0x10*512)-($$-$)) db 0 ; padding