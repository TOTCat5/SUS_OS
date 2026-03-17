

waitPS2_InputClear:
    .loop:
        inb 0x64,al
        test al,2
        jne .loop
    ret



handlePS2KeyboardInt:
    mov dword edi,[cursorPos]
    add edi,edi
    add edi,VGA_TerminalBuffer

    xor eax,eax
    inb 0x60,al
    test al,0x80
    jnz .done
    ; mov bl,[eax+conversionState]
    ; mov byte [edx],al
    ; mov byte [edx+1],0x07
    ; mov bl,[conversionState+2]
    ; mov [edx],bl

    ; inc dword [cursorPos]
    ; mov bx,[cursorPos]
    ; call setCursorPos

    mov ebx,[eax+convStage]
    mov al,bl
    call putChar

    mov bx,[cursorPos]
    call setCursorPos




    .done:

    ret



keyBoardIntMsg: db "a keyboard interrupt happened",0


convStage:
    db "0 1234567890-=0"
    db "0qwertyuiop[]",13
    db "0asdfghjkl;'`"
    db "0\zxcvbnm,./0"