    org 0x07c00
    mov ax,cs
    mov ds,ax
    mov es,ax
    mov ax,Message
    mov bp,ax
    mov cx, 13
    mov ax,0x1301
    mov bx,0x0002
    mov dh,0
    mov dl,0
    int 0x10
    jmp $
Message:
    db "Hello, world!"
    times 510-($-$$) db 0
    dw  0xaa55
