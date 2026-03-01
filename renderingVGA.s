
%define VGA_TerminalBuffer 0xb8000
%define VGA_TerminalSizeX 80
%define VGA_TerminalSizeY 25
%define VGA_TerminalArea 2000
%define VGA_TerminalBufferSize 4000
%define VGA_ColorWhiteOnBlack 15


; use bx as input
; modifies ax
; %macro setCursorPos 0
setCursorPos:
    mov dx, 0x03D4
    mov al, 0x0F
    out dx, al

    mov dx, 0x03D5
    mov al, bl
    out dx, al

    mov dx, 0x03D4
    mov al, 0x0E
    out dx, al

    mov dx, 0x03D5
    mov al, bh
    out dx, al
    ret
; %endmacro


; esi as string and ecx as size
; modifies edi,esi,al and ecx
printStringOS:
    mov dword edi,[cursorPos]
    shl edi,1
    add edi,VGA_TerminalBuffer

    add dword [cursorPos],ecx

    .next:
        test ecx,ecx
        jz .done
        mov al,[esi]
        mov [edi],al
        mov byte [edi+1],VGA_ColorWhiteOnBlack

        add edi,2
        inc esi
        dec ecx
        jmp .next
    .done:
        mov dword ebx,[cursorPos]
        call setCursorPos
        ret

; esi as string
; modifies esi,edi and al
printC_StringOS:
    mov dword edi,[cursorPos]
    shl edi,1
    add edi,VGA_TerminalBuffer

    .next:
        mov al,[esi]
        test al,al
        jz .done

        mov [edi],al
        mov byte [edi+1],VGA_ColorWhiteOnBlack

        add edi,2
        inc esi
        inc dword [cursorPos]
        jmp .next
    .done:
        mov word bx,[cursorPos]
        call setCursorPos
        ret


; modifies ecx,eax,edx and bx
endLineOS:
    mov eax,[cursorPos]
    xor edx,edx
    mov ecx,VGA_TerminalSizeX
    div ecx              ; eax=cursorPos/80

    inc eax              ; next line
    mul ecx              ; eax=eax*80

    mov [cursorPos],eax

    mov bx,ax
    call setCursorPos
    ret

; modifies eax, edi and ecx
clearScreenOS:
    mov eax,0x0f200f20          ; 2x ' ' + white on black
    mov edi,VGA_TerminalBuffer
    mov ecx,VGA_TerminalArea/4
    rep stosd

    xor ebx,ebx
    mov dword [cursorPos],ebx
    call setCursorPos
    ret


