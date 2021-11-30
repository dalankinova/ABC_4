C:\NASM\nasm -DUSEWINDOWS -f elf64 -o proc.o proc.asm
c:\mingw64\bin\gcc -o mainapp.exe mainapp.cpp proc.o 
del proc.o



