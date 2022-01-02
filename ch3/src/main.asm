; 显示文本
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
;
;
;
; 显示数字
;start:
;  mov cx, 0
;  mov ds, cx
;
;  ; 计算65535除以10的结果
;  mov ax, 0xffff
;  xor dx, dx                    ; 初始化被除数
;
;  mov bx, 10                    ; 初始化除数
;
;  div bx                        ; AX: 商 DX: 余数
;  add dl, 0x30                  ; 将数字转换为数字字符
;  mov [0x7c00+buffer+0], dl
;
;  xor dx, dx
;  div bx                        ; AX: 商 DX: 余数
;  add dl, 0x30                  ; 将数字转换为数字字符
;  mov [0x7c00+buffer+1], dl
;
;  xor dx, dx
;  div bx                        ; AX: 商 DX: 余数
;  add dl, 0x30                  ; 将数字转换为数字字符
;  mov [0x7c00+buffer+2], dl
;
;  xor dx, dx
;  div bx                        ; AX: 商 DX: 余数
;  add dl, 0x30                  ; 将数字转换为数字字符
;  mov [0x7c00+buffer+3], dl
;
;  xor dx, dx
;  div bx                        ; AX: 商 DX: 余数
;  add dl, 0x30                  ; 将数字转换为数字字符
;  mov [0x7c00+buffer+4], dl
;
;
;  ; 转化到显存段
;  mov cx, 0xb800
;  mov es, cx                    ; es extra segment reg
;
;  mov al, [0x7c00+buffer+4]
;  mov [es:0x00], al             ; `es:` 段超越前缀
;  mov byte [es:0x01], 0x2f
;
;  mov al, [0x7c00+buffer+3]
;  mov [es:0x02], al
;  mov byte [es:0x03], 0x2f
;
;  mov al, [0x7c00+buffer+2]
;  mov [es:0x04], al
;  mov byte [es:0x05], 0x2f
;
;  mov al, [0x7c00+buffer+1]
;  mov [es:0x06], al
;  mov byte [es:0x07], 0x2f
;
;  mov al, [0x7c00+buffer+0]
;  mov [es:0x08], al
;  mov byte [es:0x09], 0x2f
;
;again:
;  jmp again
;
;buffer:
;  times 5 db 0              ; 临时数组
;
;current:
;  times 510-(current-start) db 0
;  db 0x55, 0xaa
;
;
;
  mov ax,0xb800                 ;指向文本模式的显示缓冲区
  mov es,ax

  ;以下显示字符串"Label offset:"
  mov byte [es:0x00],'L'
  mov byte [es:0x01],0x07
  mov byte [es:0x02],'a'
  mov byte [es:0x03],0x07
  mov byte [es:0x04],'b'
  mov byte [es:0x05],0x07
  mov byte [es:0x06],'e'
  mov byte [es:0x07],0x07
  mov byte [es:0x08],'l'
  mov byte [es:0x09],0x07
  mov byte [es:0x0a],' '
  mov byte [es:0x0b],0x07
  mov byte [es:0x0c],'o'
  mov byte [es:0x0d],0x07
  mov byte [es:0x0e],'f'
  mov byte [es:0x0f],0x07
  mov byte [es:0x10],'f'
  mov byte [es:0x11],0x07
  mov byte [es:0x12],'s'
  mov byte [es:0x13],0x07
  mov byte [es:0x14],'e'
  mov byte [es:0x15],0x07
  mov byte [es:0x16],'t'
  mov byte [es:0x17],0x07
  mov byte [es:0x18],':'
  mov byte [es:0x19],0x07

  mov ax,number                 ;取得标号number的汇编地址(段内偏移地址)
  mov bx,10

  ;设置数据段的基地址
  mov cx,cs
  mov ds,cx

  ;求个位上的数字
  mov dx,0
  div bx
  mov [0x7c00+number+0x00],dl   ;保存个位上的数字

  ;求十位上的数字
  xor dx,dx
  div bx
  mov [0x7c00+number+0x01],dl   ;保存十位上的数字

  ;求百位上的数字
  xor dx,dx
  div bx
  mov [0x7c00+number+0x02],dl   ;保存百位上的数字

  ;求千位上的数字
  xor dx,dx
  div bx
  mov [0x7c00+number+0x03],dl   ;保存千位上的数字

  ;求万位上的数字
  xor dx,dx
  div bx
  mov [0x7c00+number+0x04],dl   ;保存万位上的数字

  ;以下用十进制显示标号的偏移地址
  mov al,[0x7c00+number+0x04]
  add al,0x30
  mov [es:0x1a],al
  mov byte [es:0x1b],0x04

  mov al,[0x7c00+number+0x03]
  add al,0x30
  mov [es:0x1c],al
  mov byte [es:0x1d],0x04

  mov al,[0x7c00+number+0x02]
  add al,0x30
  mov [es:0x1e],al
  mov byte [es:0x1f],0x04

  mov al,[0x7c00+number+0x01]
  add al,0x30
  mov [es:0x20],al
  mov byte [es:0x21],0x04

  mov al,[0x7c00+number+0x00]
  add al,0x30
  mov [es:0x22],al
  mov byte [es:0x23],0x04

  mov byte [es:0x24],'D'
  mov byte [es:0x25],0x07

infi:
  jmp near infi                 ;无限循环

number:
  db 0,0,0,0,0

  times 203 db 0
  db 0x55,0xaa
