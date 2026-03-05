
handlePS2KeyboardInt:
    
    in al,60h

    mov byte [cursorPos],al

    ret
    