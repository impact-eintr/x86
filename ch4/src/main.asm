  jmp start

mytext :
  db 'L',0x07,'a',0x07,'b',0x07,'e',0x07,'l',0x07,' ',0x07,'o',0x07
  db 'f',0x07,'f',0x07,'s',0x07,'e',0x07,'t',0x07,':',0x07

start:
  mov ax, 0x07c0
  mov ds, ax                    ;设置数据段基地址

  mov ax, 0xb800
  mov es, ax                    ;设置附加段基地址

  cld                           ;方向标志清零指令 指示传送方向为 从低到高
  mov si, mytext                ;设置文本偏移
  mov di, 0                     ;设置显存偏移

  mov cx, (start-mytext)/2
  rep movsw


  ; 得到标号所代表的汇编地址
  mov ax, number

  ; 分解各个数位
  mov bx, ax
  mov cx, 5                     ;循环次数
  mov si, 10                    ;除数

digit:
  xor dx, dx
  div si
  mov [bx], dl                  ;保留数位
  inc bx                        ;相当于(*bx)++
  loop digit                    ;当cx为0时 结束循环

  ;; 开始显示各个数位
  mov bx, number
  mov si, 4
show:
  mov al, [bx+si]               ;遍历number数组 => ds + bx + si 基址变址寻址
  add al, 0x30                  ;转换为字符
  mov ah, 0x04                  ;上色 [al|ah] 8086是低端字节序

  mov [es:di], ax               ;接着之前的文本继续写
  add di, 2

  dec si
  jns show                      ;SF==0 执行跳转 , SF==1 向下执行

  jmp $

number times 5 db 0

  times 510-($-$$) db 0
  db 0x55, 0xaa
