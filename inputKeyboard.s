

waitPS2_InputClear:
    .loop:
        inb 0x64,al
        test al,2
        jne .loop
    ret




handlePS2KeyboardInt:
    mov edx,[cursorPos]
    add edx,edx
    add edx,VGA_TerminalBuffer

    xor eax,eax
    inb 0x60,al
    test al,0x80
    jnz .done
    ; mov bl,[eax+conversionState]
    ; mov byte [edx],al
    ; mov byte [edx+1],0x07
    mov bl,[conversionState+2]
    mov [edx],bl

    inc dword [cursorPos]
    mov bx,[cursorPos]
    call setCursorPos

    ; println keyBoardIntMsg

    .done:

    ret

conversionState:
    db 0
    db 27
    db "1234567890-="
    db 8
    db 9
    db "qwertyuiop[]"
    db 13
    db 0
    db "asdfghjkl;'`"
    db 0
    db "\zxcvbnm,./"
    db 0
    db "*"
    db 0
    db " "

conversionStateLen: dd conversionState-$

keyBoardIntMsg: db "a keyboard interrupt happened",0
    