[org 0x7C00]
[BITS 16]

start:
    cli

    xor ax, ax
    mov es, ax
    mov ss, ax
    mov ds, ax
    mov sp, 0x7C00
    mov [bootDrive], dl

    mov ax, 0x1000
    mov es, ax          ; segment → physical 0x10000
    mov ah, 0x02        ; BIOS read sectors
    mov al, 0x10        ; number of sectors
    mov ch, 0           ; cylinder
    mov cl, 2           ; sector 2 onwards
    mov dh, 0           ; head
    mov dl, [bootDrive]
    mov bx, 0x0000      ; offset
    int 0x13
    jc disk_error       ; optional: jump if error

    mov si, successMsg
    call printStringReal

    cli
    

    lgdt [gdt_descriptor]

    mov eax, cr0
    or eax,1
    mov cr0,eax


    jmp dword 0x08:0x10000

diskErrorMsg: db "There was an error while reading from the disk !",0

bootDrive: db 0

successMsg: db "Disk read success!", 10,13,0

gdt_start:

gdt_null:
    dq 0x0000000000000000

gdt_code:
    dw 0xffff
    dw 0x0000
    db 0x00
    db 10011010b
    db 11001111b
    db 0x00

gdt_data:
    dw 0xffff
    dw 0x0000
    db 0x00
    db 10010010b
    db 11001111b
    db 0x00

gdt_end:


    gdt_descriptor:
        dw gdt_end-gdt_start-1
        dd gdt_start

; all the real mode functions are defined

disk_error:
    mov si,diskErrorMsg
    call printStringReal

    hlt

printStringReal:
    lodsb         ; load byte at DS:SI into AL
    cmp al,0
    je endPrintStringRealFunction
    mov ah,0x0e   ; BIOS teletype
    int 0x10
    jmp printStringReal
    endPrintStringRealFunction:
    ret

    ;End Of The Real Mode Stuff
    times 510-($-$$) db 0
    dw 0xaa55


    