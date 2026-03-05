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

%include "interruptHandling.s"

%include "SIMD.s"

%macro println 1
    mov esi,%+%1
    call printC_StringOS
    call endLineOS
%endmacro

OS_Begin:
    call clearScreenOS

    mov esi,successMsg
    mov ecx,11
    call printStringOS
    call endLineOS
    mov esi,LogoInLines.line0
    call printC_StringOS
    call endLineOS
    mov esi,LogoInLines.line1
    call printC_StringOS
    call endLineOS
    mov esi,LogoInLines.line2
    call printC_StringOS
    call endLineOS
    mov esi,LogoInLines.line3
    call printC_StringOS
    call endLineOS

    call endLineOS

    mov esi,SIMD_Check
    call printC_StringOS
    call endLineOS

    CheckingSIMD_Extensions:
        mov eax,0x1
        cpuid

        ; ---- SSE ----
            test edx, SSE_Available
            jz .noSSE
            pushad
            println SSE_Msg.SSE_Available
            
            popad
        .noSSE:

        ; ---- SSE2 ----
            test edx, SSE2_Available
            jz .noSSE2
            pushad
            println SSE_Msg.SSE2_Available
            
            popad
        .noSSE2:

        ; ---- SSE3 ----
            test ecx, SSE3_Available
            jz .noSSE3
            pushad
            println SSE_Msg.SSE3_Available
            
            popad
        .noSSE3:

        ; ---- SSSE3 ----
            test ecx, SSSE3_Available
            jz .noSSSE3
            pushad
            println SSE_Msg.SSSE3_Available
            
            popad
        .noSSSE3:

        ; ---- SSE4.1 ----
            test ecx, SSE4v1_Available
            jz .noSSE4v1
            pushad
            println SSE_Msg.SSE4v1_Available
            
            popad
        .noSSE4v1:

        ; ---- SSE4.2 ----
            test ecx, SSE4v2_Available
            jz .noSSE4v2
            pushad
            println SSE_Msg.SSE4v2_Available
            
            popad
        .noSSE4v2:

    checkEnd:


    println initInterruptHandlingMsg

    call initInterruptHandling

    println finishInterruptHandling


    OS_Loop:
        hlt

        jmp OS_Loop


; variables

helloWorld: db "Hello World ! ",0

cursorPos: dd 0

successMsg: db "OS Loaded !",0

LogoInLines:
    .line0: db " ____ _  _  _____      ___   ____",0
    .line1: db "/ __/| || |/ ___/     / _ \ / __/",0
    .line2: db "\___\| || |\____\    | |_| |\___\",0
    .line3: db "\___/\____/\____/=====\___/ \___/",0

logoMsg: db ""

initInterruptHandlingMsg: db "Initializing The Interrupt Handling",0
finishInterruptHandling: db "Finishing The Interrupt Handling",0

SIMD_Check: db "Available Extensions:",0
SSE_Msg:
    .SSE_Available: db "    -SSE",0
    .SSE2_Available: db "    -SSE2",0
    .SSE3_Available: db "    -SSE3",0
    .SSSE3_Available: db "    -SSSE3",0
    .SSE4v1_Available: db "    -SSE4.1",0
    .SSE4v2_Available: db "    -SSE4.2",0





times ((0x10*512)-($$-$)) db 0 ; padding