
%define VGA_TerminalBuffer 0xb8000


; string arg in eax
; modifies eax,edx and bl
printC_StringOS:

    mov edx,VGA_TerminalBuffer
    add edx,[cursorPos]
    add edx,[cursorPos]

    .next:
    mov bl,[eax]                                    ; Load the character
    cmp bl,0                                        ; Check for '\0'
    je .done

    mov byte [edx], bl                              ; load on the screen the character
    mov byte [edx+1], 15

    add edx,2                                       ; go to next character
    inc word [cursorPos]
    inc eax
    jmp .next

    .done:
        mov bx,[cursorPos]
        call setCursorPos
        ret

; take eax as the string and ebx as its size in characters
; modify cl,edx,eax and ebx
printStringOS:
    mov edx, [cursorPos]
    shl edx,1
    add edx, VGA_TerminalBuffer
    shl ebx,1
    add ebx, VGA_TerminalBuffer     ; Transform size into pointer

    .next:
    cmp ebx,edx                     ; check if reached end pointer
    je .done

    mov cl,[eax]                    ; get character
    mov byte [edx], cl              ; load on the screen the character
    mov byte [edx+1], 15

    add edx,2                       ; increment stuff
    inc word [cursorPos]
    inc eax
    jmp .next

    .done:
        mov bx,[cursorPos]
        mov bx,[cursorPos]
        call setCursorPos
        ret


; modifies eax,and possibly edi and ecx... I used chatGPT for that one,forgive me
clearScreenOS:
    xor eax, eax
    mov edi, VGA_TerminalBuffer
    mov ecx, 4000/4
    rep stosd
    ret



; use bx as input
; modifies ax
setCursorPos:
    mov dx, 0x03d4
	mov al, 0x0f
	out dx, al

	inc dl
	mov al, bl
	out dx, al

	dec dl
	mov al, 0x0E
	out dx, al

	inc dl
	mov al, bh
	out dx, al
    ret
