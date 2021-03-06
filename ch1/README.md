# 认识8086

## 寄存器
| name | high | low |
|:----:|:----:|:---:|
| AX   | AH   | AL  |
| BX   | BH   | BL  |
| CX   | CH   | CL  |
| DX   | DH   | DL  |
| SI   |      |     |
| DI   |      |     |
| SP   |      |     |
| BP   |      |     |

这些寄存器都是16位的, 从高到低15-0, 0x5AC3, 0x852F

一个字==2byte==16bit 字也就是机器字长


## 如何访问内存
8086有16根地址线，与内存相连，读写内存,传输数据时需要多少位就传送多少位

``` assembly
0x55AA

BX
15   8 7   0
 | 55 | AA |
```

## 程序在内存中是如何分段存放的
处理器是可以自动取指令和执行指令的器件，为了解决问题需要编排指令，这个过程叫做编程，编程的结果是生成了一个程序。

数据段 + 代码段(指令)

操作码(cpu如何执行该指令的信息)+操作数  => 指令

``` assembly
A1 0C00 ; 将物理内存地址0C00的一个字(053C)传送到AX寄存器
0306 0C02 ; 将寄存器AX的内容和内存地址0C02处的字(0F8B)相加，结果在AX中
;最终结果 AX: 14C7
```

## 程序重定位的问题
处理器中有一个寄存器(IPR)，保存下一条即将执行的指令的地址

程序中不可以使用物理地址，否则无法解决重定位的问题，代码都是编好的，跳转到哪里都是写死的，换个环境全作废

## 段地址和偏移地址

处理器中 `DSR` 寄存器保存了数据段的起始地址

``` assembly
A1 0000 ; 将偏移内存地址1c00 + 0000的一个字(053C)传送到AX寄存器
0306 0002 ; 将寄存器AX的内容和偏移内存地址 1c00 + 0002处的字(0F8B)相加，结果在AX中
;最终结果 AX: 14C7
```

这一次程序不管放到内存中的哪里都可以直接执行了。

## 8086内存访问的困境
8086有20根地址线，寻址(0x00000~0xFFFFF = 1M)

| 名称 | 作用             |
|:----:|:----------------:|
| DS   | 数据段的物理地址 |
| CS   | 代码段的物理地址 |

但8086的寄存器 DS、CS 是16位的放不下20位的地址，这就尴尬了。

**8086选择所有最低4位为0000的地址作为段地址，存放时右移4位，取用时左移4位**
``` assembly
0x12560 / 0x10 = 0x1256 <=> 75104 / 16 = 4694

0x1256 == 4694
```

## 8086的内存访问过程
![img](img/访问内存过程.png)

## 逻辑地址和分段

| 物理地址 | 逻辑地址  |
|:--------:|:---------:|
| 65C75    | 65C7:0005 |
| 65C74    | 65C7:0004 |
| 65C73    | 65C7:0003 |
| 65C72    | 65C7:0002 |
| 65C71    | 65C7:0001 |
| 65C70    | 65C7:0000 |


段内偏移的范围:0000~FFFF = 65536 = 64KB

8086最多可以划分65536个段，最少可以划分16个段
- 1MB / 16 
- 1MB / 64KB

