SECTION header VSTART=0         ;程序的头部
progran_length:
  dd program_end ;程序的总长度

  ;; 用户程序入口点
code_entry:
  dw start              ;偏移地址
  dd section.code.start ;段地址

  ;; 段重定位表项个数
  realloc_tbl_len dw (segtbl_end-segtbl_begin)/4

  ;; 段重定位表
segtbl_begin:
  code_segment dd section.code.start ;[0x0C]
  data_segment dd section.data.start ;[0x10]
  stack_segment dd  section.stack.start ;[0x14]
segtbl_end:

;; =================================================================
SECTION code ALIGN=16 VSTART=0
start:
  ;; 初识执行时 DS 和 ES 指向用户程序头部段
  mov ax, [stack_segment]
  mov ss, ax
  mov sp, stack_pointer         ;设置初识的栈顶指针

  mov ax, [data_segment]        ;设置用户程序自己的数据段
  mov ds, ax

  mov ax, 0xb800
  mov es, ax

  mov si, message
  mov di, 0

next:
  mov al, [si]
  cmp al, 0
  je exit
  mov byte [es:di], al
  mov byte [es:di], 0x07
  inc si
  add di, 2
  jmp next

exit:
  jmp $

;; =================================================================
SECTION data ALIGN=16 VSTART=0
message:
  db 'hello world.', 0

;; =================================================================
SECTION stack ALIGN=16 VSTART=0
  resb 256
stack_pointer:

;; =================================================================
SECTION trail ALIGN=16
program_end:
