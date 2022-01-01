;   org 0x07c00
;   mov ax,cs
;   mov ds,ax
;   mov es,ax
;   mov ax,Message
;   mov bp,ax
;   mov cx, 13
;   mov ax,0x1301
;   mov bx,0x0002
;   mov dh,0
;   mov dl,0
;   int 0x10
;   jmp $
;Message:
;   db "Hello, world!"
;   times 510-($-$$) db 0
;   dw  0xaa55
;
;start:
;    mov ax, 0xb800
;    mov ds, ax
;
;    mov byte [0x00], 'A'
;    mov byte [0x01], 0x0c       ;黑底红字无闪烁
;
;    mov byte [0x02], 's'
;    mov byte [0x03], 0x04
;
;    mov byte [0x04], 's'
;    mov byte [0x05], 0x04
;
;    mov byte [0x06], 'e'
;    mov byte [0x07], 0x04
;
;    mov byte [0x08], 'm'
;    mov byte [0x09], 0x04
;
;    mov byte [0x0a], 'b'
;    mov byte [0x0b], 0x04
;
;    mov byte [0x0c], 'l'
;    mov byte [0x0d], 0x04
;
;    mov byte [0x0e], 'y'
;    mov byte [0x0f], 0x04
;
;    mov byte [0x10], '.'
;    mov byte [0x11], 0x04
;
;again:
;    jmp near start
;
;current:
;    times 510-(current-start) db 0
;    db 0x55, 0xaa               ; DB作为汇编语言中的伪操作命令，它用来定义操作数占用的字节数
start:
  mov cx, 0
  mov ds, cx

  ; 计算65535除以10的结果
  mov ax, 0xffff
  xor dx, dx                    ; 初始化被除数

  mov bx, 10                    ; 初始化除数

  div bx                        ; AX: 商 DX: 余数
  add dl, 0x30                  ; 将数字转换为数字字符
  mov [0x7c00+buffer+0], dl

  xor dx, dx
  div bx                        ; AX: 商 DX: 余数
  add dl, 0x30                  ; 将数字转换为数字字符
  mov [0x7c00+buffer+1], dl

  xor dx, dx
  div bx                        ; AX: 商 DX: 余数
  add dl, 0x30                  ; 将数字转换为数字字符
  mov [0x7c00+buffer+2], dl

  xor dx, dx
  div bx                        ; AX: 商 DX: 余数
  add dl, 0x30                  ; 将数字转换为数字字符
  mov [0x7c00+buffer+3], dl

  xor dx, dx
  div bx                        ; AX: 商 DX: 余数
  add dl, 0x30                  ; 将数字转换为数字字符
  mov [0x7c00+buffer+4], dl


  ;; 转化到显存段
  mov cx, 0xb800
  mov es, cx                    ; es extra segment reg

  mov [0x00], al
buffer:
  times 5 db 0              ; 临时数组

current:
  times 510-(current-start) db 0
  db 0x55, 0xaa
