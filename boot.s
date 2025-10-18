[org 0x7C00]
[BITS 16]

start:
    jmp endFunctionDeclaration

    printString:
    lodsb         ; load byte at DS:SI into AL
    cmp al,0
    je endPrintStringFunction
    mov ah,0x0e   ; BIOS teletype
    int 0x10
    jmp printString
    endPrintStringFunction:
    ret

    endFunctionDeclaration:
    mov si,hello
    call printString




hang:
    jmp hang

hello: db "Hello World!",0

times 510-($-$$) db 0
dw 0xaa55

