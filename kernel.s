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

%macro println 1
    mov esi,%1
    call printC_StringOS
    call endLineOS
%endmacro

%include "renderingVGA.s"

%include "interruptHandling.s"

%include "SIMD.s"



%macro checkSSE_Extension 2
    test %2, %1%+_Available
            jz .no%+%1
            pushad
            println SSE_Msg.%+%1%+_Available
            
            popad
        .no%+%1%+:
%endmacro

OS_Begin:
    call clearScreenOS

    println successMsg
    println LogoAsMsg

    call endLineOS

    println SIMD_Check

    CheckingSIMD_Extensions:
        mov eax,0x1
        cpuid

        test edx,SSE_Available
            jz .noSSE
            pushad
            println SSE_Msg.SSE_Available
            
            popad
            inc byte [SSE_Test]
        .noSSE:

        checkSSE_Extension SSE2,edx
        checkSSE_Extension SSE3,ecx
        checkSSE_Extension SSSE3,ecx
        checkSSE_Extension SSE4v1,ecx
        checkSSE_Extension SSE4v2,ecx

    checkEnd:

    println initInterruptHandlingMsg

    call initInterruptHandling

    println finishInterruptHandling

    println SSE_ActivateMsg
    call activateSSE
    println SSE_FinishActivateMsg


    OS_Loop:
        hlt

        jmp OS_Loop


; variables

SSE_Test: db 0

helloWorld: db "Hello World ! ",0

cursorPos: dd 0

successMsg: db "OS Loaded !",0


LogoAsMsg:
    db " ____ _  _  _____      ___   ____",13
    db "/ __/| || |/ ___/     / _ \ / __/",13
    db "\___\| || |\____\    | |_| |\___\",13
    db "\___/\____/\____/=====\___/ \___/",0


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

SSE_ActivateMsg: db "Activating SSE",0
SSE_FinishActivateMsg: db "Finished Activating SSE",0



times ((0x10*512)-($$-$)) db 0 ; padding