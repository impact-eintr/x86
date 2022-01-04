  jmp start
start:
  mov ax, -6002
  cwd
  mov bx, -10
  idiv bx

  jmp $

number times 5 db 0

  times 510-($-$$) db 0
  db 0x55, 0xaa
