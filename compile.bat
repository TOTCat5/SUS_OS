nasm -f bin boot.s -o boot.bin -Ox
nasm -f bin kernel.s -o kernel.bin -Ox
copy /b boot.bin + kernel.bin boot.img
qemu-system-x86_64 -cpu max -drive format=raw,file=boot.img -monitor stdio