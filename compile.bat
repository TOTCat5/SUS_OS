nasm -f bin boot.s -o boot.bin
nasm -f bin kernel.s -o kernel.bin
copy /b boot.bin + kernel.bin boot.img
qemu-system-x86_64 -drive format=raw,file=boot.img -monitor stdio