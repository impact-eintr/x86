  ;; 声明常数(用户程序起始逻辑扇区号)
  ;; 常数的声明不会占用汇编地址
  app_lba_start equ 100

SECTION mbr align=16 vstart=0x7c00
  ;;设置堆栈段和栈指针
  mov ax, 0
  mov ss, ax
  mov sp, ax

  ;; 将phy_base这个用户起始段地址算出来
  mov ax, [cs:phy_base]         ;计算用于加载用户程序的逻辑段地址 0x0000:0x7c00+phy_base
  mov dx, [cs:phy_base+0x02]
  mov bx, 0x10
  div bx
  mov ds, ax                    ;令DS和ES指向该段以进行操作
  mov es, ax

  ;;  以下读取程序的起始部分
  xor di, di
  mov si, app_lba_start         ;程序在硬盘上的起始逻辑扇区号
  xor bx, bx                    ;加载到DS:0x0000处
  call read_hard_disk_0

  ;; 1. 程序的总长度
  ;; 2. 入口点(段地址:偏移地址)
  ;; 3. 段重定位表项数
  ;; 4. 段重定位表

  ;; 程序的总长度
  mov dx, [0x02]
  mov ax, [0x00]                ;高16位DX 低16位AX 32位记录长度
  mov bx, 512
  div bx
  cmp dx, 0                     ;对比余数
  jnz @1                        ;没有除尽 商要比实际扇区小1
  dec ax

@1:
  cmp ax, 0
  jz direct                     ;长度小于512的情况

  ;; 读取剩余的扇区
  push ds                       ;保存ds寄存器的内容
  mov cx, ax                    ;循环次数(剩余扇区数)
@2:
  mov ax, ds
  add ax, 0x20                  ;得到下一个以512为边界的段地址 eg. 0x1000+0X20 = 0x1020 => 0x10200 0x200 == 512
  mov ds, ax                    ;修改段基地址

  xor bx, bx                    ; DS:BX 的值 = ds+0x20:0x0000 用来存放读到的数据
  inc si                        ; DI:SI 的初始值 = 0x0000:app_lba_start 扇区号递增
  call read_hard_disk_0
  loop @2

  pop ds                        ;恢复DS的内容

  ;; 计算入口点代码段基址
  ;; 包括 入口点: 偏移地址 用不着计算 一个字的长度
  ;;      入口点所在代码段的 汇编地址 两个字的长度
direct:
  ;; ds已经恢复
  ;; 为什么从6开始 不应该是4? 这里是在计算入口代码所在的代码段的汇编地址
  mov dx, [0x08]
  mov ax, [0x06]
  call calc_segment_base
  mov [0x06], ax                ;回填修正后的入口点代码段基址

realloc:



;; ---------------------------read_hard_disk_0-------------------------------------
read_hard_disk_0:               ;从硬盘读取一个逻辑扇区
                                ;输入 DI:SI 起始逻辑扇区号
                                ;DS:BX = 目标缓冲区地址
  ;; 保存原有数据
  push ax
  push bx
  push cx
  push dx

  mov dx, 0x1f2
  mov al, 0x01   ; 一个扇区
  out dx, al     ; 1~255 表示读取1~255个扇区 0表示读取256个扇区

  ;; 扇区号 = DS : SI xxxxabcd xxxxxxxx : xxxxxxxx xxxxxxxx
  inc dx                        ;0x1f3
  mov ax, si
  out dx, al                    ; 7~0

  inc dx                        ;0x1f4
  mov al, ah
  out dx, al                    ; 15~8

  inc dx                        ;0x1f5
  mov ax, di
  out dx, al                    ; 23~16

  inc dx                        ;0x1f6
  mov al, 0xe0                  ;11(CHS/LBA)10(主/从) 0000
  or al, ah                     ; 27~24 11100000 | xxxxabcd == 1110abcd
  out dx, al                    ;1110 abcd(28位的前4位)

  mov dx, 0x1f7
  mov al, 0x20                  ;读命令
  out dx, al

  mov dx, 0x1f7                 ;0x1f7 既是状态端口又是命令端口
.waits:
  in al, dx
  and al, 0x88                  ;0x88 1000 1000 表示不忙，且硬盘已经准备好数据了
  cmp al, 0x08
  jnz .waits

  ;; 假定DS已经指向存放扇区数据的段 BX里是段内偏移地址
  mov cx, 256                   ;总共要读取的字数
  mov dx, 0x1f0
.readw:
  in ax, dx
  mov [bx], ax
  add bx, 2
  loop .readw

  ;; 恢复原有数据
  pop ax
  pop bx
  pop cx
  pop dx

  ret

;; ---------------------------calc_segment_base-------------------------------------
;; 根据用户程序的其实物理内存地址 计算段的真实物理地址 再转换成段地址
calc_segment_base:              ;计算16位段地址
                                ;输入: DX:AX=32位汇编地址
                                ;返回: AX=16位段基地址
  push dx

  add ax, [cs:phy_base]
  adc dx, [cs:phy_base+0x02]    ;带进位的加法 把上一步可能的进位加上
  shr ax, 4                     ;逻辑右移 4位 0000xxxx xxxxxxxx
  ror dx, 4                     ;循环右移 4位 abcd???? ????????
  and dx, 0xf000                ;保留前4位 后边全清零 abcd0000 00000000
  or ax, dx                     ;组合dx:ax abcdxxxx xxxxxxxx

  pop dx

  ret


;; ----------------------------------------------------------------
phy_base:                       ;用户程序被加载的物理起始地址 注意是32位的 H=>DX L=>AX
  dd 0x10000

  times 510-($-$$) db 0
  db 0x55aa
