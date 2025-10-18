nasm -f bin boot.s -o boot.img
qemu-system-x86_64 -drive format=raw,file=boot.img