
keyBoardIntMsg: db "a keyboard interrupt happened",0
handlePS2KeyboardInt:
    mov edx,[cursorPos]
    add edx,edx
    add edx,VGA_TerminalBuffer

    in al,60h
    mov byte [edx],al
    

    
    ret
    