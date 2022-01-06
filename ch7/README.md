# INTEL 8086处理器的寻址方式
> 寻址方式

如何找到要操作的数据,以及如何找到操作结果存放的地方

## 寄存器 立即数和直接寻址
> 寄存器寻址

``` assembly
mov ax, cx
add bx, 0xf000
inc dx
```

> 立即数寻址

``` assembly
add bx, 0xf000
mov dx, mydata
```

> 直接内存寻址

``` assembly
mov ax, [0x5c0f]
add word [ox0230], 0x5000
xor byte [es:mydata], 0x05
```

## 基址(寄存器)寻址
使用 BX/BP 基址寄存器

``` assembly
    mov bx, buffer
    mov cx, 5
lpinc:
    inc word [bx]
    add bx, 2
    loop lpinc
```

``` assembly
mov ax, 0x5000
mov bx, 0x7000
mov cx, 0x8000

push ax
push bx
push cx

mov bp, sp
mov dx, [bp+2] ; bp 默认使用的SS 默认访问栈段

pop ax
pop bx
pop cx

```

## 变址(寄存器)寻址

使用了 SI/DI 索引寄存器

``` assembly
; 使用编制寻址的例子
mov [si], dx

add ax, [di]

xor word [si], 0x8000

mov [si+0x100], al

and byte [di+mydata], 0x80
```


> 原地反转字符串

``` assembly
jmp start

string:
  db 'abcdefghijklmnopqrstuvwxyz'

start:
  mov ax, 0x07c0
  mov ds, ax                    ;设置数据段基地址

  mov ax, 0xb800                ;设置显存段基地址
  mov es, ax

  mov ax, cs                    ;设置栈段的段基地址
  mov ss, ax
  mov sp, 0

  mov cx, start-string
  mov di, string
lppush:
  mov al, [di]
  push ax
  inc di
  loop lppush

  mov cx, start-string
  mov si, string
lppop:
  pop ax
  mov [si], al
  inc si
  loop lppop

  mov cx, start-string
  mov di, string
  mov si, 0
showstr:
  mov al, [di]
  mov [es:si], al
  inc di
  mov byte [es:si+1], 0x07
  add si, 2
  loop showstr

  jmp $

  times 510-($-$$) db 0
  db 0x55, 0xaa

```


## 基址变址寻址

``` assembly
[bx + si]
[bx + di]
[bx + si + 偏移量]
[bx + di + 偏移量]

mov ax, [bx+si+0x03]

[bp + si]
[bp + di]
[bp + si + 偏移量]
[bp + di + 偏移量]
```

> 原地反转字符串 - 基址变址寻址

``` assembly
jmp start

string:
  db 'abcdefghijklmnopqrstuvwxyz'

start:
  mov ax, 0x07c0
  mov ds, ax                    ;设置数据段基地址

  mov ax, 0xb800                ;设置显存段基地址
  mov es, ax

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

```
