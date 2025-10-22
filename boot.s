[org 0x7C00]
[BITS 16]

start:

    mov si,hello
    call printString

hang:
    ; and bl,7

    ; xor bh,bh
    ; mov al,[loadingThingsPreloaded+bx]
    ; mov [loadingThing+1],al

    ; mov si,loadingThing
    ; call printString
    ; add bl,1

    ; xor dx,dx
    ; countLoop:
    ; nop
    ; inc dx
    ; cmp dx,0x0
    ; jne countLoop


    jmp hang

hello: db "Please Wait,The OS is Loading...",10,13,0

loadingThing: db 13,"-",0
loadingThingsPreloaded: db "\|/-\|/-"



; all the real mode functions are defined
printString:
    lodsb         ; load byte at DS:SI into AL
    cmp al,0
    je endPrintStringFunction
    mov ah,0x0e   ; BIOS teletype
    int 0x10
    jmp printString
    endPrintStringFunction:
    ret

times 510-($-$$) db 0
dw 0xaa55

