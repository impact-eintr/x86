  jmp start

message:
  db '1+2+3+...+100='

start:
  mov ax, 0x07c0
  mov ds, ax                    ;设置数据段基地址

  mov ax, 0xb800
  mov es, ax                    ;设置附加段基地址

  ;; 显示字符串
  mov si, message
  mov di, 0
  mov cx, start - message
showmsg:
  mov al, [si]
  mov [es:di], al
  inc di
  mov byte [es:di], 0x07
  inc di
  inc si
  loop showmsg

  ;; 以下计算1到100
  xor ax, ax                    ;ax存放累加结果
  mov cx, 1
summate:
  add ax, cx
  inc cx
  cmp cx, 100
  jle summate

  ;; 以下分解累加和的各个数位
  xor cx, cx                    ;设置SS
  mov ss, cx
  mov sp, cx

  mov bx, 10
  xor cx, cx
decompo:
  inc cx
  xor dx, dx
  div bx                        ;商在ax 余数在dx
  add dl, 0x30
  push dx

  cmp ax, 0                     ;如果商为0,就结束循环
  jne decompo

shownum:
  pop dx
  mov [es:di], dl
  inc di
  mov byte [es:di], 0x07
  inc di
  loop shownum

  jmp $

number times 5 db 0

  times 510-($-$$) db 0
  db 0x55, 0xaa
