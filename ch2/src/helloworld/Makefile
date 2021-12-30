.PHONY: build

obj=main

build:
	nasm $(obj).asm -o $(obj).o
	dd if=/dev/zero of=b.img bs=512 count=2048
	dd if=$(obj).o of=b.img bs=512 seek=0 conv=notrunc

.PHONY: clean

clean:
	$(RM) ./*.img ./*.o
