

waitPS2_InputClear:
    .loop:
        inb 0x64,al
        test al,2
        jne .loop
    ret



handlePS2KeyboardInt:

    xor eax,eax
    inb 0x60,al

    cmp al,0xe0
        jne .extendedScancodeCheck
        call waitPS2_InputClear

        ret



    .extendedScancodeCheck:

    mov bl,al
    and bl,~0x80
    cmp bl,2ah
        jne .shiftLeftCheck
        mov bl,shiftTable-convTable-1
        xor [shift],bl
        ret
    .shiftLeftCheck:

    cmp bl,36h
        jne .shiftRightCheck
        mov bl,shiftTable-convTable-1
        xor [shift],bl
        ret
    .shiftRightCheck:

    cmp al,3ah
        jne .shiftLockCheck
        mov bl,shiftTable-convTable-1
        xor [shift],bl
        ret
    .shiftLockCheck:

    test al,0x80
    jne .done

    ; inc dword [cursorPos]
    ; mov bx,[cursorPos]
    ; call setCursorPos

    add eax,[shift]
    mov ebx,[eax+convTable]
    mov eax,ebx
    
    
    call putChar

    mov bx,[cursorPos]
    call setCursorPos




    .done:

    ret




shift: dd 0

keyBoardIntMsg: db "a keyboard interrupt happened",0


convTable:
    db "001234567890-=0"
    db "0qwertyuiop[]",13
    db "0asdfghjkl;'`"
    db "0\zxcvbnm,./0"
    db "0*  "
    times 0x57-0x37 db "0"


shiftTable:
    db "0!@#$%^&*()_+0"
    db "0QWERTYUIOP{}",13
    db "0ASDFGHJKL:",22h,"~"
    db "0\ZXCVBNM<>?-0"
    db "0*0 "
    times 0x57-0x37 db "0"