  jmp start

string:
  db 'abcdefghijklmnopqrstuvwxyz'

start:
  mov ax, 0x07c0
  mov ds, ax                    ;设置数据段基地址

  mov ax, 0xb800                ;设置显存段基地址
  mov es, ax

;  mov ax, cs                    ;设置栈段的段基地址
;  mov ss, ax
;  mov sp, 0
;
;  mov cx, start-string
;  mov di, string
;lppush:
;  mov al, [di]
;  push ax
;  inc di
;  loop lppush
;
;  mov cx, start-string
;  mov si, string
;lppop:
;  pop ax
;  mov [si], al
;  inc si
;  loop lppop

  mov bx, string
  mov si, 0
  mov di, start-string-1
revert:
  mov ah, [bx+si]
  mov al, [bx+di]
  mov [bx+si], al
  mov [bx+di], ah
  inc si
  dec di
  cmp si, di
  jl revert

  mov si, 0
  mov di, 0
  mov bx, string
showstr:
  mov al, [bx+si]               ;访问string
  inc si

  mov [es:di], al               ;访问显存
  mov byte [es:di+1], 0x07
  add di, 2

  cmp si, start-string
  jl showstr

  jmp $

  times 510-($-$$) db 0
  db 0x55, 0xaa
