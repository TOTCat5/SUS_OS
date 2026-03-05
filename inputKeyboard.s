
debugMsg: db "an Keyboard interrupt happened",0

handlePS2KeyboardInt:
    mov esi,debugMsg
    call printC_StringOS
    call carryReturnLineOS

    ret
    