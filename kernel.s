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
            jne .noSSE
            mov esi,SSE_Msg.SSE_Available
            call printC_StringOS
            call endLineOS
        .noSSE:

        ; ---- SSE2 ----
            test edx, SSE2_Available
            jne .noSSE2
            mov esi,SSE_Msg.SSE2_Available
            call printC_StringOS
            call endLineOS
        .noSSE2:

        ; ---- SSE3 ----
            test ecx, SSE3_Available
            jne .noSSE3
            mov esi,SSE_Msg.SSE3_Available
            call printC_StringOS
            call endLineOS
        .noSSE3:

        ; ---- SSSE3 ----
            test ecx, SSSE3_Available
            jne .noSSSE3
            mov esi,SSSE3_AvailableMsg
            call printC_StringOS
            call endLineOS
        .noSSSE3:
    checkEnd:

    
    

    jmp $

    ; OS_Loop:
    ;     hlt
    ;     jmp OS_Loop


; variables
helloWorld: db "Hello World ! ",

cursorPos: dd 0

successMsg: db "OS Loaded !",0

LogoInLines:
    .line0: db " ____ _  _  _____      ___   ____",0
    .line1: db "/ __/| || |/ ___/     / _ \ / __/",0
    .line2: db "\___\| || |\____\    | |_| |\___\",0
    .line3: db "\___/\____/\____/=====\___/ \___/",0

logoMsg: db ""

SIMD_Check: db "Available Extensions:",0

SSE_Msg:
    .SSE_Available: db "    -SSE",0
    .SSE2_Available: db "    -SSE2",0
    .SSE3_Available: db "    -SSE3",0
    .SSE4v1_Available: db "    -SSE4.1",0
    .SSE4v2_Available: db "    -SSE4.2",0
SSSE3_AvailableMsg: db "    -SSSE3",0





times ((0x10*512)-($$-$)) db 0 ; padding